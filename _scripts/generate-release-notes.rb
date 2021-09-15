#!/usr/bin/ruby
# frozen_string_literal: true

# Run with:
# _scripts/toolbox-ruby _scripts/generate-release-notes.rb

### Editable variables ###

# GitHub repos to consider
@repos = %w[
  cockpit
  cockpit-machines
  cockpit-podman
  cockpit-ostree
]

# Common terms and definitions
@terms = {
  "API": 'Application Programming Interface',
  "ARIA": 'Accessible Rich Internet Applications',
  "AWS": 'Amazon Web Services',
  "CDN": 'Content Delivery Network',
  "CI": 'continuous integration (testing)',
  "Copr": "A build service for unofficial / semi-official Fedora community
    projects. It's a portmanteau, short for \"Community Projects\". Pronounced
    like the metal \"copper\".",
  "CPU": 'Central Processing Unit, the "brain" of a computer',
  "DIMM": 'Dual Inline Memory Module',
  "EC2": 'Amazon Elastic Compute Cloud',
  "FIPS": 'Federal Information Processing Standard',
  "FMF": 'Flexible Metadata Format',
  "HTTP": 'Hypertext Transport Protocol',
  "IPA": 'identity management system ("Identity, Policy, Audit")',
  "LAN": 'Local Area Network',
  "LVM": 'Logical Volume Manager',
  "motd": 'message of the day',
  "NBDE": 'network-bound disk encryption',
  "NFS": 'Network File System',
  "NIC": 'Network Interface Card',
  "NMI": 'Non-Maskable Interrupt',
  "NPM": 'Node Package Manager',
  "OS": 'Operating System',
  "PCP": 'Performance Co-Pilot',
  "RAID": 'Redundant Array of Inexpensive Disks',
  "RAM": 'Random Access Memory',
  "repo": 'repository',
  "RHEL": 'Red Hat Enterprise Linux',
  "SATA": 'Serial "Advanced Technology" Attachment, a bus interface to attach storage devices to a computer',
  "SCSI": 'Small Computer System Interface, commands and protocols for communication with (mainly storage) devices',
  "SELinux": 'Security-Enhanced Linux, policies for enforcing access controls in Linux',
  "single pane of glass": 'console that provides high-level management of
    multiple machines, also known as a "single-pane view"',
  "SRPM": 'source RPM',
  "SSH": 'Secure Shell, a common protocol to securely connect to a remote computer',
  "STI": "Fedora's Standard Test Interface",
  "TLS": 'Transport Layer Security',
  "tmt": 'test management tool',
  "USB": 'Universal Serial Bus, a protocol for hot-pluggable (and usually external) devices',
  "VDO": 'Virtual Data Optimizer',
  "Virtio": 'Virtual Input/Output, a standard for network and disk drivers where
    the guest cooperates with the host for performant virtualization',
  "VM": 'Virtual Machine',
  "VMs": 'Virtual Machines'
}

# Header boilerplate
@header = "
Cockpit is the [modern Linux admin interface](https://cockpit-project.org/).
We release regularly.

Here are the release notes from VERSIONS:
"

# Footer boilerplate
@footer = "
## Try it out

VERSIONS ARE available now:

* [For your Linux system](https://cockpit-project.org/running.html)
"

@footer_dynamic = "
* [NAME Source Tarball](https://github.com/cockpit-project/REPO/releases/tag/VERSIONS)
* [NAME Fedora 35](https://bodhi.fedoraproject.org/updates/?releases=F35&packages=REPO)
* [NAME Fedora 34](https://bodhi.fedoraproject.org/updates/?releases=F34&packages=REPO)
"

### Code below ###

require 'optparse'
require 'ostruct'
require 'bundler'
require 'net/http'
require 'json'
require 'yaml'
require 'etc'

@options = OpenStruct.new

OptionParser.new do |opt|
  opt.on('-p', '--preview', 'Preview release notes with open PRs and more info') { @options[:preview] = true }
  opt.on('-r', '--released', 'Cockpit has been released (do not increment version)') { @options[:released] = true }
  opt.on('-v', '--verbose', 'Show additional information on the command line') { @options[:debug] = true }
end.parse!

@cockpit_version = nil
@frontmatter = ''
@releases = []
@footer_locations = []
@tags = []
@files_images = []
@increment = @options.released ? 0 : 1

# Simple method to make a sanitized string for slugs and filenames
def slugify(filename)
  filename.downcase.gsub(/[^0-9a-z]/i, '-')
end

def markdown_filename
  "#{Time.now.strftime('%F')}-cockpit-#{@cockpit_version}.md"
end

# Join words into a list, with commands and an 'and', when needed.
def oxfordize(parts)
  case parts.size
  when 0..1
    parts.first
  when 2
    parts.join(' and ')
  else
    "#{parts.slice(0..-2).join(', ')}, and #{parts.slice(-1)}"
  end
end

# Fetch, parse, and return JSON from a URI
def get_json(url)
  JSON.parse(Net::HTTP.get(URI(url)))
rescue StandardError => e
  puts "Could not fetch notes from the GitHub API (#{e})"
end

# Drop the 'cockpit-' prefix
def drop_prefix(repo)
  repo.split('-')[1].to_s.capitalize
end

# Make frontmatter metadata based on logged in user and release notes
def build_frontmatter
  cockpit_title = "Cockpit #{@cockpit_version}"

  @frontmatter = {
    title: cockpit_title,
    author: Etc.getlogin,
    date: Time.now.strftime('%F'),
    tags: @tags.join(', '),
    slug: slugify(cockpit_title),
    category: 'release',
    summary: ''
  }.to_yaml.gsub(/^:/, '')
end

# Download the image from GitHub and save locally
def download_image(url, basename)
  extension = url.split('.').last
  filename = "#{basename}.#{extension}"

  # Download and save file
  image = Net::HTTP.get(URI(url))
  File.write("images/#{filename}", image)

  @files_images.push("images/#{filename}")

  # Return filename (with extension)
  filename
end

def process_images(notes)
  markdown_image = /!\[([^\]]*)\]\(([^)]*)\)/m
  iteration = 0
  title = notes.split("\n").first

  notes.gsub(markdown_image) do
    alt = Regexp.last_match[1]
    url = Regexp.last_match[2]
    iteration += 1

    basename = slugify(title)
               .squeeze('-').sub('-', "#{@cockpit_version}-") +
               (iteration == 1 ? '' : "-#{iteration}")

    alt = "screenshot of #{title.split(':').last.strip.downcase}" if alt.match(/^Screen Shot|^image$/)

    filename = download_image(url, basename)

    "![#{alt}]({{ site.baseurl }}/images/#{filename})"
  end
end

# Change raw Markdown from a PR and perform heuristics to make it a release note
def format_issue(issue, repo)
  splitter = /^[# ]*release note.*/i
  underlines = /^[=\-#]+$/
  heading_prefix = repo.match('-') ? "#{drop_prefix(repo)}: " : ''

  # Start polishing the issue body into release note text
  issue_body = issue['body'].gsub(/\r\n/, "\n").strip

  # Attempt to split release notes from the body with the splitter
  release_note = issue_body.split(splitter, 2).last.strip

  # Attempt header & further content extaction, if there was no splitter
  if release_note == issue_body
    # Discard everything before the first heading
    release_note = issue_body.split(/^#/, 2).last
    # Re-add the first "#", if the header split worked
    release_note = "##{release_note}" unless release_note == issue_body
  end

  # Remove extraneous lines, like ==== ---- ####
  release_note.sub!(/^.*$/, '').strip! if release_note.split("\n").first.match(underlines)

  # Handle underline-style headings at the top; converting to ATX-stle
  release_note.sub!(/^(.*)$\n^.*$/, '## \1') if release_note.split("\n")[1].match(underlines)

  # Prepend an issue title when a heading wasn't extracted
  issue_title = release_note.match(/^#/) ? '' : "## #{heading_prefix}#{issue['title']}\n\n"

  puts issue.to_yaml if @options.debug

  state_info = if @options.preview
                 state = issue['state']
                 if state == 'open'
                   alert = 'warn'
                   included = '(will not be included) '
                   merged = 'OPEN'
                 else
                   alert = 'note'
                   included = ''
                   merged = 'merged'
                 end
                 url = issue['html_url']
                 "State: **#{merged}** #{included}@ <#{url}>\n{:.#{alert}}\n\n"
               else
                 ''
               end

  full_note = "#{issue_title}#{release_note.strip}"
              # Normalize headings to H2
              .sub(/^#+/, '##')
              .sub(/\n\n/, "\n\n#{state_info}")

  process_images(full_note)
end

# Locate (and output) any matching terms from the term list in the document
def find_terms(doc)
  terms_match = @terms.select { |term| doc.join('').match(term.to_s) }

  terms_match.map do |term, definition|
    "*[#{term}]: #{definition}".delete("\t\r\n").squeeze(' ').strip
  end
end

# Reformat repo name when appropriate
def repo_human(repo)
  repo.match('-') ? repo : repo.capitalize
end

# Generate headers and footers based on the template, with substitions for versions
def headfoot(template)
  template
    .gsub('VERSIONS', oxfordize(@releases))
    .gsub('ARE', @releases.count != 1 ? 'are' : 'is')
end

# Construct footer locations per repo, with version-specific URLs
def build_footer_locations(repo, version)
  @footer_dynamic
    .gsub('NAME', repo_human(repo))
    .gsub('VERSIONS', version.to_s)
    .gsub('REPO', repo)
    .strip
end

# Process release version, add locations boilerplate, and construct tags
# (Used once per repo)
def process_meta(repo, versions)
  @releases.push("#{repo_human(repo)} #{versions.last + @increment}")
  @footer_locations.push(build_footer_locations(repo, versions.last + @increment))
  @tags.push(repo.sub('cockpit-', ''))
end

# Main loop to process all the repos
def process_repos
  url_template = if @options.preview
                   'https://api.github.com/search/issues?q=is:pr+repo:cockpit-project/REPO+label:release-note'
                 else
                   'https://api.github.com/search/issues?q=is:pr+repo:cockpit-project/REPO+label:release-note+is%3Aclosed'
                 end
  tags_template = 'https://api.github.com/repos/cockpit-project/REPO/tags'

  @repos.map do |repo|
    # Grab relevant issues for the repo
    url = url_template.sub('REPO', repo)

    # Process versions
    url_tags = tags_template.sub('REPO', repo)
    versions = get_json(url_tags).map { |tag| tag['name'].to_i }.sort
    # Set the Cockpit version from the first repo (which is always Cockpit)
    @cockpit_version ||= versions.last + @increment

    notes = get_json(url)['items']
            .map { |issue| format_issue(issue, repo) }

    process_meta(repo, versions) unless notes.empty?

    notes
  end
end

# Main function, to build the release notes text
def construct_all_the_notes
  # All the release note text
  release_notes = process_repos

  build_frontmatter

  [
    @frontmatter, '---', "\n",
    headfoot(@header), "\n\n",
    release_notes.join("\n\n"),
    headfoot(@footer), "\n",
    @footer_locations.join("\n"), "\n\n",
    find_terms(release_notes).join("\n")
  ].join('').gsub("\r\n", "\n").gsub(/\n{4,}/m, "\n\n\n")
end

begin
  # Run the main function; store in a variable
  # (Running the release notes construction also generates the filename, so we
  # need to run it _before_ the File.write())
  release_notes = construct_all_the_notes

  File.write("_posts/#{markdown_filename}", release_notes)

  # Show the files that have been created
  puts "Generated release notes for Cockpit #{@cockpit_version}: _posts/#{markdown_filename}"
  puts "Downloaded images: #{@files_images.join(' ')}"
rescue StandardError => e
  puts "Error (#{e})"
end
