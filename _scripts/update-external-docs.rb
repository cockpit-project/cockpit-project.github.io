#!/usr/bin/ruby
# frozen_string_literal: true

# Run using toolbox-ruby:
# _scripts/toolbox-ruby _scripts/update-external-docs.rb

### Editable variables ###

# Pages to fetch from the Cockpit wiki
wiki_pages = %w[
  Cockpit-Coding-Guidelines
  Contributing
  Workflow
]

# Pages to fetch from the Cockpit git repo
source_pages = %w[
  HACKING.md
  test/README.md
]

# Pages to fetch from the Cockpit bots repo
bots_pages = %w[
  README.md
]

# URLs to rewrite
@url_rewrites = {
  'https://github.com/cockpit-project/cockpit/blob/main/HACKING.md' =>
  '{{ site.baseurl }}/external/source/HACKING.html',

  'https://github.com/cockpit-project/cockpit/blob/main/test/README' =>
  '{{ site.baseurl }}/external/source/test/README.html',

  'https://github.com/cockpit-project/bots/blob/main/README.md' =>
  '{{ site.baseurl }}/external/bots/README.html',

  'https://github.com/cockpit-project/cockpit/blob/master/HACKING.md' =>
  '{{ site.baseurl }}/external/source/HACKING.html',

  'https://github.com/cockpit-project/cockpit/blob/master/test/README' =>
  '{{ site.baseurl }}/external/source/test/README.html',

  'https://github.com/cockpit-project/bots/blob/master/README.md' =>
  '{{ site.baseurl }}/external/bots/README.html',

  'http://cockpit-project.org/ideals.html' =>
  '{{ site.baseurl }}/ideals.html',

  'About#project-ideals' =>
  '{{ site.baseurl }}/ideals.html',

  'About#contact-developers--stay-up-to-date' =>
  'https://github.com/cockpit-project/cockpit/wiki/About',

  'http://files.cockpit-project.org/guide/latest/' =>
  '{{ site.baseurl }}/guide/latest/',

  'Ideas' =>
  'https://github.com/cockpit-project/cockpit/wiki/Ideas',

  'https://github.com/cockpit-project/cockpit/wiki/Workflow#review-criteria' =>
  '/external/wiki/Workflow#review-criteria',

  'How-@mvollmer-merges-pull-requests' =>
  'https://github.com/cockpit-project/cockpit/wiki/How-@mvollmer-merges-pull-requests',

  'Design' =>
  'https://github.com/cockpit-project/cockpit/wiki/Design'
}

### Code below ###

require 'bundler'
require 'net/http'
require 'yaml'
require 'fileutils'

@prefix = {
  source: 'https://github.com/cockpit-project/cockpit/blob/master/',
  source_raw: 'https://raw.githubusercontent.com/cockpit-project/cockpit/master/',
  bots: 'https://github.com/cockpit-project/bots/blob/master/',
  bots_raw: 'https://raw.githubusercontent.com/cockpit-project/bots/master/',
  wiki: 'https://github.com/cockpit-project/cockpit/wiki/',
  wiki_raw: 'https://raw.githubusercontent.com/wiki/cockpit-project/cockpit/',
  issues: 'https://github.com/cockpit-project/cockpit/issues'
}

@external_dir = File.expand_path "#{__dir__}/../external/"

def fetch_and_add(pages, type = :source)
  pages.each do |page|
    suffix = type == :wiki ? '.md' : ''
    url = @prefix[type] + page
    url_raw = @prefix["#{type}_raw".to_sym] + page + suffix
    file = "#{type}/#{page}"
    file += '.md' unless page.match(/\.md$/)

    doc = Net::HTTP.get(URI(url_raw))

    if %i[source bots].include?(type)
      # Extract the title for git source, as filenames are often "README"
      title = doc.match(/^#[^\n]*\n/m)[0].gsub(/#/, '').strip

      # Strip the title, as it's added in our Jekyll codebase
      doc = doc.sub(/^#* #{title}/m, '').strip
    else
      # Show the path as title for wiki pages,
      # as wiki pages need to have relevant names
      title = page.gsub('/', ' / ').gsub('-', ' ').sub(/\.md$/i, '')

      # Indent pages 1 level if there's a matching H1 already
      # (similar to what GitHub does on wiki pages)
      doc = doc.gsub(/^#/m, '##') if doc.match(/^# /m)
    end

    # Rewrite URLs
    @url_rewrites.each do |before, after|
      doc = doc.gsub("](#{before})", "](#{after})")
      doc = doc.gsub(%r{]\(http(s)?://cockpit-project\.org/}, ']({{ site.baseurl }}/')
    end

    # Fix issue link URLs
    doc = doc.gsub(%r{\]\(../issues}m, "](#{@prefix[:issues]}")

    frontmatter = {
      'title' => title,
      'source' => url
    }.to_yaml

    FileUtils.mkdir_p "#{@external_dir}/#{File.dirname file}"
    File.write "#{@external_dir}/#{file}", "#{frontmatter}---\n\n#{doc}"
  end
end

puts 'Updating source pages'
fetch_and_add(source_pages, :source)
puts 'Updating wiki pages'
fetch_and_add(wiki_pages, :wiki)
puts 'Updating bots pages'
fetch_and_add(bots_pages, :bots)
puts 'All pages updated'
