# cockpit-project.org
**Website for the cockpit-project**

[cockpit-project.org](http://cockpit-project.org/)

This repository manages the content and presentation of the Cockpit project's website, including blog articles,
release notes, the Cockpit guide and screenshots.

Content is converted into html pages using pelican.

### Dependencies

In order to convert content into web pages, you need to have the `pelican` utility installed. On Fedora:

    $ dnf -y install python-pip
    $ pip install pelican typogrify Markdown

### Adding release notes

Add a markdown page to the `content` directory and run make to update the website:

    $ make html

It is advisable to use separate commits for the content and all generated files.
