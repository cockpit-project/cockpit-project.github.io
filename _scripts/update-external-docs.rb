#!/usr/bin/ruby

### Editable variables ###

# Pages to fetch from the Cockpit wiki
wiki_pages = [
  "Cockpit-Coding-Guidelines",
  "Contributing",
  "Workflow",
]

# Pages to fetch from the Cockpit git repo
source_pages = [
  "HACKING.md",
  "test/README.md",
]

# URLs to rewrite
@url_rewrites = {
  "https://github.com/cockpit-project/cockpit/blob/master/HACKING.md" =>
  "{{ site.baseurl }}/external/source/HACKING.html",

  "https://github.com/cockpit-project/cockpit/blob/master/test/README" =>
  "{{ site.baseurl }}/external/source/test/README.html",

  "http://cockpit-project.org/ideals.html" =>
  "{{ site.baseurl }}/ideals.html",

  "About#project-ideals" =>
  "{{ site.baseurl }}/ideals.html",

  "About#contact-developers--stay-up-to-date" =>
  "https://github.com/cockpit-project/cockpit/wiki/About",

  "http://files.cockpit-project.org/guide/latest/" =>
  "{{ site.baseurl }}/guide/latest/",

  "Ideas" =>
  "https://github.com/cockpit-project/cockpit/wiki/Ideas",

  "https://github.com/cockpit-project/cockpit/wiki/Workflow#review-criteria" =>
  "/external/wiki/Workflow#review-criteria",

  "How-@mvollmer-merges-pull-requests" =>
  "https://github.com/cockpit-project/cockpit/wiki/How-@mvollmer-merges-pull-requests",

  "Design" =>
  "https://github.com/cockpit-project/cockpit/wiki/Design",
}

### Code below ###

require 'bundler'
require 'open-uri'
require 'yaml'
require 'fileutils'

@prefix = {
  source: 'https://github.com/cockpit-project/cockpit/blob/master/',
  source_raw: 'https://raw.githubusercontent.com/cockpit-project/cockpit/master/',
  wiki: 'https://github.com/cockpit-project/cockpit/wiki/',
  wiki_raw: 'https://raw.githubusercontent.com/wiki/cockpit-project/cockpit/',
  issues: 'https://github.com/cockpit-project/cockpit/issues',
}

@external_dir = File.expand_path "#{__dir__}/../external/"

def fetch_and_add(pages, type=:source)
  pages.each do |page|
    suffix = (type == :wiki) ? '.md' : ''
    url = @prefix[type] + page
    url_raw = @prefix["#{type}_raw".to_sym] + page + suffix
    file = "#{type}/#{page}"
    file += ".md" unless page.match(/\.md$/)

    doc = open(url_raw).read

    if (type == :source)
      # Extract the title for git source, as filenames are often "README"
      title = doc.match(/^#[^\n]*\n/m)[0].gsub(/#/, '').strip

      # Strip the title, as it's added in our Jekyll codebase
      doc = doc.sub(/^#* #{title}/m, '')
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
    end

    # Fix issue link URLs
    doc = doc.gsub(/\]\(..\/issues/m, "](#{@prefix[:issues]}")

    frontmatter = {
      'title' => title,
      'source' => url
    }.to_yaml

    FileUtils.mkdir_p "#{@external_dir}/#{File.dirname file}"
    File.write "#{@external_dir}/#{file}", frontmatter + "---\n\n" + doc
  end
end

fetch_and_add(wiki_pages, :wiki)
fetch_and_add(source_pages, :source)
