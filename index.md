---
title: Cockpit Project
layout: essential
class: front-page
---
{% capture newline %}
{% endcapture %}

{% capture screenshots %}
login-opt.png: Cockpit's log in prompt (on Fedora 34)
debian-in-windows-edge.jpg: Cockpit works where you are (Pictured: Connecting to Debian server from Microsoft Edge on Windows 10)
journal.png: View, filter, and search system logs
accounts.png: Edit accounts
firewall-rhel.png: Edit the firewall with ease (Pictured: Cockpit Web Console on Red Hat Enterprise Linux, connected from Fedora 34 Workstation)
network-overview.png: Manage your network
overview-f33.png: Have a high-level overview of a server
software-updates-cve-auto.png: Examine and apply software updates (with changelogs and links to CVEs)
storage-overview.png: Look at and manage your storage
system-services-ssh.png: See system services
system-service-details.png: Manage an individual system service
vm-create.png: Create and manage virtual machines
{% endcapture %}
{% assign screenshots = screenshots | split: newline %}

{% capture screenshots_html %}
<div class="screenshots">{%
for screenshot in screenshots
  %}{%
  assign filename = screenshot | split: ":" | first | strip
    | prepend: "/images/screenshot/"
    | prepend: site.baseurl
  %}{%
  assign text = screenshot | replace_first: ":", "©"
    | split: "©" | last | strip
  %}{%
  unless text == ""
    %}<a class="screenshot zoom"
    href="{{ filename }}"><img src="{{ filename }}" 
    title="{{ text }}" alt="{{ text }}"></a>{% 
  endunless
  %}{%
endfor
%}</div>
{% endcapture %}


{% comment %}
##### Content #####
First we set up & capture the content, then we render it in the scaffolding below.
{% endcomment %}

{% capture intro-lede %}
The easy-to-use, integrated, glanceable, and open web-based interface for your servers
{% endcapture %}

{% capture intro-text %}
## Introducing Cockpit

Cockpit is a web-based graphical interface for servers, intended for everyone, especially those who are:

{:.audience-list}
- **new to Linux** (including Windows admins)
- **familiar with Linux** and want an easy, graphical way to administer servers
- **expert admins** who mainly use other tools but want an overview on individual systems

Thanks to Cockpit intentionally using system APIs and commands, a whole team of admins can manage a system in the way they prefer, including the command line and utilities right alongside Cockpit.

### Take a look

A picture is worth a thousand words. Click a thumbnail to see screenshots of Cockpit in action.

{{ screenshots_html }}


### Simple to use

Cockpit makes Linux discoverable. You don't *have to* remember commands at a command-line.

See your server in a web browser and perform system tasks with a mouse. It's easy to start containers, administer storage, configure networks, and inspect logs.  Basically, you can think of Cockpit like a graphical "desktop interface", but for individual servers.

### Compatible with your existing workflows

Have a favorite app or command line tool that you use on your servers? 
Keep using the command line, Ansible, and your other favorite tools and add Cockpit to the mix with no issues.

Cockpit uses the same system tooling you would use from the command line. You can switch back and forth between Cockpit and whatever else you like. Cockpit even has a built-in terminal, which is useful when you connect from a non-Linux device.

### Integrated

Cockpit uses APIs that already exist on the system. It doesn't reinvent subsystems or add a layer of its own tooling.

By default, Cockpit uses [your system's normal user logins and privileges]({{ site.baseurl }}/guide/latest/privileges). Network-wide logins are also supported through [single-sign-on]({{ site.baseurl }}/guide/latest/sso) and other [authentication]({{ site.baseurl }}/guide/latest/authentication) techniques.

Cockpit itself doesn't eat resources or even run in the background when you're not using it. It runs on demand, thanks to systemd socket activation.

### Extendable

Cockpit also supports [a large list of optional and third-party applications](applications.html).

## Using Cockpit

Here's a subset of tasks you can perform on each host running Cockpit:

{:.using-cockpit}
- Inspect and change network settings
- Configure a firewall
- Manage storage (including RAID and LUKS partitions)
- Create and manage virtual machines
- Download and run containers
- Browse and search system logs
- Inspect a system's hardware
- Upgrade software
- Keep tabs on performance
- Manage user accounts
- Inspect and interact with systemd-based services
- Use a terminal on a remote server in your local web browser
- Switch between [multiple Cockpit servers]({{ site.baseurl }}/guide/latest/feature-machines.html)
- Extend Cockpit's functionality by installing [a growing list of apps and add-ons](applications.html)
- [Write your own custom modules]({{ site.baseurl }}/blog/cockpit-starter-kit.html) to make Cockpit do anything you want

*[RAID]: Redundant Array of Inexpensive Disks
*[LUKS]: Linux Unified Key Setup (encryption)

Also troubleshoot and fix pesky problems with ease:

{:.using-cockpit}
- Diagnose network issues
- Spot and react to misbehaving virtual machines
- Examine SELinux logs and fix common violations in a click
- Inspect detailed metrics that correlate CPU load, memory usage, network activity, and storage performance with the system's journal

More features appear in Cockpit every release.

### Designed & tested

Cockpit's design keeps your goals in mind.  We test Cockpit with usability studies to make it work the way you'd expect and adjust accordingly. As a result, Cockpit gets easier to use all the time.

All code changes have tests which must pass before merging, to ensure stability.

### Free & free

Cockpit is free to use and [available under the GNU LGPL](https://github.com/cockpit-project/cockpit/blob/master/COPYING).

### Cockpit works (nearly) everywhere

You can install Cockpit on the major distributions, including:

{:.distro-logos}
{%
  for distro in site.data.distros
%}- [![{{ distro.name }}](/images/site/os-{{ distro.first}}.svg)]({{ site.baseurl }}/running.html#{{ distro.first }})
{% endfor %}

Once Cockpit is up and running, you can access systems from all major web browsers on any operating system (including Windows, MacOS, and Android).

## Release schedule

Cockpit has a time-based release cadence, with new versions appearing every two weeks.

## Get started

{:style="text-decoration-skip-ink:none"}
After [installing and enabling Cockpit]({{ site.baseurl }}/running.html), visit port 9090 on your server (for example: <https://localhost:9090/> in a browser on the same machine as Cockpit).
{% endcapture %}

{% capture footer_links %}
About Cockpit
: [Project Ideals and Goals](ideals.html)
: [Cockpit Blog](blog)
: [Blog Feeds](blog/feeds/)
: [Release Notes and Videos](blog/category/release.html)
: [Search this site](search.html)
{:.col.footer-links-1}

Running Cockpit
: [Installation](running.html)
: [Documentation](documentation.html)
: [Deployment guide](guide/latest/guide.html)
: [Feature internals](guide/latest/features.html)
: [File a bug in the issue tracker](https://github.com/cockpit-project/cockpit/issues)
{:.col.footer-links-2}

Contributing
: [Contribution overview](https://github.com/cockpit-project/cockpit/wiki/Contributing)
: [Get the source](https://github.com/cockpit-project/cockpit)
: [Join the mailing list](https://lists.fedorahosted.org/archives/list/cockpit-devel@lists.fedorahosted.org/)
: [IRC #cockpit on libera.chat](ircs://irc.libera.chat:6697)
: [Developer tutorials](blog/category/tutorial.html)
: [Developer API reference](guide/latest/development.html)
{:.col.footer-links-3}

*[Feeds]: Atom (similar to RSS), for use in feed readers
{% endcapture %}


{% capture badge %}
{% assign release = site.posts | where: "category", "release" | first %}
{% assign version = release.title | split: "and" | first | split: " " | last %}
<a href="{{ site.baseurl }}{{ release.url }}" title="{{ release.summary }}">
  <span class="badge-new">
    Released
    <span class="badge-date">{{ release.date | date: "%-d %b %Y" }}</span>:
  </span>
  <span class="badge-version">Version {{ version }}</span>
</a>
{% endcapture %}

{% capture screenshots %}
[![Storage screenshot]({{ site.baseurl }}/images/site/screenshot-storage.png)]({{ site.baseurl}}/images/site/screenshot-storage.png)
{:.screenshot.zoom}

[![Network screenshot]({{ site.baseurl }}/images/site/screenshot-network.png)]({{ site.baseurl }}/images/site/screenshot-network.png)
{:.screenshot.zoom}

[![Dashboard screenshot]({{ site.baseurl }}/images/site/screenshot-dashboard.png)]({{ site.baseurl }}/images/site/screenshot-dashboard.png)
{:.screenshot.zoom}
{% endcapture %}

{% comment %}
##### Scaffolding #####
{% endcomment %}

{% capture output %}

<div class="frontpage-background">
  {% include page_header.html %}
  <section class="intro intro-background">
    <div class="intro-lede">
      {{ intro-lede | markdownify }}
    </div>
    <div class="planes"></div>
    <div class="badge">
      {{ badge }}
    </div>
  </section>
</div>


<div id="page-wrap" class="page-content" role="main">
  <section class="intro-text wrapper">{{ intro-text | markdownify }}</section>
</div>

<footer class="footerlinks">
  {{ footer_links | markdownify }}
</footer>
{% include page_footer.html %}

<script src="{{ site.baseurl }}/assets/lib/screenshot-gallery.js"></script>
{% endcapture %}{{ output }}
