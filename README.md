# Cockpit Project Website

[The Cockpit project website](http://cockpit-project.org/) is based on Springboard, which is a MIT-licensed preconfigured build of Jekyll, used for starting up a site quickly.

This repository manages the content and presentation of the Cockpit project's website, including blog articles, release notes, the Cockpit guide, and screenshots.

For more details on Springboard, see [jekyll-springboard](https://github.com/garrett/jekyll-springboard).

## Get Started

In order to convert content into web pages, you will need to have Ruby, Bundler, and Jekyll installed.

1. Install Ruby & Bundler (as root):

   _Note: To become root, you must either run `su` or `sudo -s`_

   * **Fedora** / **RHEL** / **CentOS**:
     ```
     dnf install -y rubygem-bundler ruby-devel libffi-devel make gcc gcc-c++ \
     redhat-rpm-config zlib-devel libxml2-devel libxslt-devel tar
     ```

   * **openSUSE**:
     ```
     zypper install ruby2.1-rubygem-bundler ruby2.1-devel make gcc-c++ \
     libxml2-devel libxslt-devel tar
     ```
     
   * **Debian** / **Ubuntu**:
     ```
     apt update && apt install bundler zlib1g-dev
     ```

   * **macOS** / **OS X**:
   
     _Note: First, you must install Mac developer tools. Then, run the following:_
     
     ```
     gem update --system
     gem install bundler
     ```

2. Install gems (as user):
   ```
   bundle install
   ```

3. Run Jekyll:
   ```
   bundle exec jekyll server
   ```

## Work with the Site

As this site scaffolding is built on Jekyll, most all Jekyll documentation applies.

Useful references:
- [the official Jekyll documentation](http://jekyllrb.com/docs/home/)
- [CloudCannon Jekyll tutorials](https://learn.cloudcannon.com/)

### Release Notes

Release notes are in the form of a Markdown-formatted blog post, and are located in `_posts` with the date and URL slug as parts of the filename.

For more details, read [the section on blog posts](#blog-posts).

### Frontmatter

Frontmatter is embedded YAML, included in every document Jekyll processes. If the Frontmatter YAML is left out, Jekyll will not process the file, and will merely copy it out, unprocessed, to the output `_site` sub-directory.

Example Markdown file with Frontmatter (at the top):

```markdown
---
title: This is a blog post!
date: 2017-04-01
author: reedrichards
tags: foo bar baz
category: selfpost
---

Hi everyone! Welcome to my first blog post!
```

The author should be a nickname (ideally) and you should fill out information in the `_data/authors.yml` file.

Blog posts _need_ Frontmatter with most of the above fields. The fields for `tags` and `category` are optional. All other files that are to be processed by Jekyll should have at least the opening and closing Frontmatter lines (the two triple dashes `---`), and should _probably_ at least include the `title` as well.

### Markdown

Jekyll uses Markdown... specifically, GitHub-flavored Markdown via Kramdown.

You're able to use all Markdown conventions that GitHub adds on top (including tables, etc.) and also able to add in classes and IDs (among other things) thanks to Kramdown.

In addition, Jekyll uses what's called "Liquid" tags for simple logic and flow control. (Variables, if/then/else, loops, etc.) Liquid is supported not just in HTML and what Jekyll considers plaintext (JSON, XML, etc.), but also in Markdown.

If you would like to mix Markdown with a bit more advanced layout, you may want to consider capture blocks with Markdown rendering in Liquid tags. It looks like this (using a simple [Grlidlex](http://gridlex.devlint.fr/) grid):

```markdown
{% capture intro %}
## Intro title here

A list:

1. Item 1
2. Item 2
{% endcapture %}

{% capture details %}
Some other information to the side...
{% endcapture %}

<section class="grid">
  <div class="col">{{ intro | markdownify }}</div>
  <div class="col">{{ details | markdownify }}</div>
</section>
```

This allows you to mix-and-match content in pure Markdown with a bit of HTML for more advanced layout. Generally, you'll want to just keep eveything in pure Markdown and keep this technique for special pages (such as landing pages or anything that needs to be a little more complex).

### Liquid

[Liquid is a templating language](https://shopify.github.io/liquid/) originally made by Shopify and included in Jekyll by default.

There are basically two types of Liquid tags:
1. Objects, which look like `{{ objectname }}`
2. Tags look similar to objects, but instead of using double brackets, tags use percent signs. `{% tagname %}`

Both objects and tags take filters, which is written as a pipe followed by a directive. Filters can (sometimes optionally) take arguments as well, and can also be chained.

Simple example (the assignment is a bit silly here, but important to point out):

```liquid
{% if person %}
  {% assign role = person.job_title | capitalize %}

  Hello, {{ person.name }}!

  How long have you worked at {{ role }}?
{% endif %}
```

Please note that whitespace shows up in files. This usually doesn't matter much for HTML, but can matter a lot for XML or JSON (especially if the generated file loops and becomes large). Workarounds include breaking up Liquid tags over multiple lines and using throw-away capture groups for assignments.

Space-reducing example (mainly useful for loops):

```liquid
{%
  if foo
    %}{{
      foo.bar
      | split: "::"
      | join: ", "
      | strip
    }}{%
  endif
%}
```

- [Official Liquid documentation](https://shopify.github.io/liquid/basics/introduction/)
- [Jekyll Cheat Sheet](https://learn.cloudcannon.com/jekyll-cheat-sheet/) — Jekyll-specific liquid tags
- [Liquid for Designers](https://github.com/Shopify/liquid/wiki/Liquid-for-Designers) — an excellent overview on how to use Liquid tags in documents (both Markdown and HTML)

### Blog Posts

All blog posts belong in the `_posts` directory and must be formatted with the year, slug (usually a shortened title, used as part of the URL), and extension. This look like `2017-04-01-welcome-to-the-blog.md`

In addition, every blog post needs to have Frontmatter including the fields `title` and `date` (which should be the same as the filename's date) and should also include `author` to give the person credit (as well as to show up under the author on the authors page). In addition, a blog post may have `tags` and a `category`, but they're not necessary (only suggested).

#### Blog Authors

While not necessary, it is suggested to use nicknames for authors in the Frontmatter of blog posts.

There's a bit of logic in the blog post code that uses information from a `_data/authors.yml` file if it exists.

The format for an authors file looks like this:

```yaml
default:
  name: Site Admin

example:
  name: Ann Example
  twitter: example
  googleplus: somegoogleaccount
  facebook: somefacebookaccount
  gravatar: 5658ffccee7f0ebfda2b226238b1eb6e
  description: |
    This is an example author. To get a gravatar, do something like:
    echo -n email@example.com | md5sum

reedrichards:
  name: 'Reed "Fantastic" Richards'
  twitter: MrFantastic__
  description: |
    Along with a few of my friends, I was blasted by cosmic radiation,
    and now I'm super bendy and stretchy.

    We fight crime.
```

In the above snippet, `default`, `example`, and `reedrichards` are nicknames that are used in the blog posts. All fields are optional, but you'll probably at least want a `name`.

Note that some characters need to be escaped in quote marks. In the above snipped, the word __"Fantastic"__ has quotes around it, so it has single quotes around the string. In most cases, you can leave out the quote strings, but if in doubt, go ahead and wrap the string in quotes.

### Navigation

Navigation is controlled by a `_data/navigation.yml` file, if it exists.

Simply add navigation info in the correct format and your site will take care of all the navigation needs for you, including highlighting the current page.

```yaml
- title: Home
  url: "/"

- title: Events
  url: /events/

- title: Software
  url: /software/

- title: Standards
  url: /standards/

- title: Search
  url: /search/
```

Note that the URL to "/" is in quotes. This is necessary, due to YAML. The other `title`s and `url`s skip quoting and still work, however.

You can even get fancy and add sub-navigation if you want to (although you probably shouldn't, for usability reasons):

```yaml
- title: About
  url: /about/
  nav:
    - title: Things
      url: /about/things/
    - title: FAQ
      url: /about/faq/
      nav:
        - title: Test1
          url: /test1
        - title: Test2
          url: /test2
```

### Customization

Site customization happens mainly in two places: `_config.yml` and `assets/site.scss` (or `assets/site.sass`). By default, the site CSS file doesn't exist, so you'll need to create it.

#### Config YAML

The `_config.yaml` file is pretty straightforward. It has a configuration by default that makes things work locally in a similar manner to how GitHub Pages works.

For more details on the `_config.yaml` file, [read Jekyll's documentation](https://jekyllrb.com/docs/configuration/).

#### Custom CSS

Creating the custom site CSS is easy. Run one of the following commands:

- If you're using **SCSS**: `cp assets/default.scss assets/site.scss`
- If you'd rather use **SASS**: `sass-convert assets/default.scss assets/site.sass`

_**Note**: If you convert the default file to SASS, the comments about turning on and off imports will be in the wrong place. Thankfully, editing the comments is an easy one-time fix._

Next step is to edit the site scss/sass file.

Inside the file, you'll see a bunch of variables at the top and a whole lot of imports underneith. The variables are pretty self explanitory, and let you quickly tweak the look of your site without having to actually edit CSS. Imports are there to include special styling for your site. A good set of defaults are turned on, but you can turn on and off several by uncommenting to turn on or commenting (or deleting) to turn off various styles.

Add any custom style specific to your site below all the imports.

#### Custom Logo

Drop your logo, preferably in SVG format, in the images directory. Call it `logo.svg` (or `logo.png` if you don't have it available in SVG). That's it! Done!

### Directory structure

Exporting rule of thumb: Directories and files starting with an underscore are seen by Jekyll (and some are vital in most Jekyll codebases, such as `_layouts`), but are not included in the output.

- **`_data`** — [Data files](http://jekyllrb.com/docs/datafiles/), in YAML (`yml`) or JSON format. Referenced in Liquid tags as `site.data.`_`FILENAME`_`.`_`DATA…`_.
  - `navigation.yml` _(optional, but strongly recommended)_ — Navigation used across the site
  - `authors.yml` _(optional, but recommended)_ — Information about blog authors
  - `events` _(optional)_ — Directory (with subdirectories and conference files such as `year/conference.yml`) of in the [rh-events format](https://github.com/OSAS/rh-events/wiki/Formatting) for the optional events calendar.

- **`_includes`** — Partials used for inclusion in documents and layouts, useful for abstracting complex HTML & Liquid logic, especially when it may be reused across the site. Includes are invoked as `{% include FILENAME.html key=value %}` (key and value are optional, and can be anything — value itself can be a variable or a string enclosed in quotes).

- **`_layouts`** — Templates for pages, especially HTML — most noteworthy layouts are `essential`, which is "bare-bones" HTML, and leaving `layout:` in Frontmatter blank for no layout at all (which is useful for JSON, XML, plain text, etc.).

- **`_posts`** — Blog posts go here, in Markdown format. Posts should contain basic Frontmatter (YAML at the top of the file). The filename matters, too: `YYYY-MM-DD-your-post-short-title-in-lowercase.md`. For more information, please consult [the official Jekyll documentation on blog posts](http://jekyllrb.com/docs/posts/).

- **`_site`** — Output of the Jekyll compilation process. This should not be checked into git (and is already in the `.gitignore`). On a clean git checkout, this directory does not exist.

- **`assets`** — This is the place for CSS, JavaScript, and fonts. CoffeScript (`.coffee`) and SASS (`.sass`, `.scss`) are supported as Jekyll will process them to CSS and JavaScript, provided they have a Frontmatter directive (which can be empty, as in two immediate lines of three dashes `---`) for top-level processed files (files which are included via SASS includes need not — and even should not — have Frontmatter).
  - **`fonts`** — Any fonts served locally should go here.
  - **`lib`** — Custom CSS & JavaScript.
  - **`vendor`** — Included CSS & JavaScript from other projects (such as jQuery, etc.)

- **`blog`** — This is not the place for blog posts. It is, however, the place for files that make blogs work (the index file, author file, category files, feeds, etc.). In most cases, you don't need to touch what's here.

- **`events`** — This subdirectory is where the events calendar lives, if your site uses events. Events data is pulled in from `_data/events.yml`, if it exists.

- **`guide`** — Cockpit-specific guides, dumped as HTML and included in the website.
  - **`latest`** — The latest guide. This is what the other pages should link. Other guides are included for posterity under their version number.

- **`images`** — Images live here. These are the images blog posts and other pages usually link to.
  - **`site`** — Site-specific images (various icons, logos, etc.) should be placed here.
  - **`logo.svg`** — Logo file, in SVG. Using `logo.png` is also supported, but using an SVG is recommended.
  - **`favicon.png`** — Large 512px square version of the site icon.
  - **`favicon-small.png`** — Small 16px square version of the site icon.

## Deployment

### GitHub Pages

If you're deploying on GitHub using GitHub pages, all you need to do is:

1. Click the "Settings" tables
2. Scroll down to "GitHub Pages"
3. Select "Master branch" (if it's not already selected)
4. Click "Save"

_**Tip**: If your development model has others fork this repo into their own personal namespace, they can follow these same directions to have their very own staging version of the site to demonstrate their changes._

### Custom Deployment

The detailed process of deploying is outside of the scope of this document.

A quick overview, however, would be to do something such as:

1. Run `bundle exec jekyll build`
2. Sync the results of the `_site` directory to your webhost via some means (rsync, sftp, etc.)
