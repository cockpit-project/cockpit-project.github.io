---
title: Cockpit Project
layout: essential
class: front-page
---
{% include page_header.html %}

{% comment %}
##### Content #####
First we set up & capture the content, then we render it in the scaffolding below.
{% endcomment %}


{% capture intro-left %}
The [easy-to-use](#easy-to-use),
[integrated](#integrated),
[glanceable](#glanceable),
and [open](#open-ended)
web-based interface for your servers
{% endcapture %}

{% capture intro-right %}
[![Docker screenshot]({{ site.baseurl }}/images/site/screenshot-docker.png)]({{ site.baseurl }}/images/site/screenshot-docker.png){:.screenshot.zoom}
{% endcapture %}


{% assign blurbs_highlight = 6 %}

{% capture blurbs %}

## Easy to use

### Discoverable
Cockpit makes GNU/Linux discoverable. See your server in a web browser and perform system tasks with a mouse. It's easy to start containers, administer storage, configure networks, and inspect logs.

[![Storage screenshot]({{ site.baseurl }}/images/site/screenshot-storage.png)]({{ site.baseurl}}/images/site/screenshot-storage.png)
{:.screenshot.zoom}

### Designed & tested
Cockpit is designed with your goals in mind. We also routinely test Cockpit with usability studies to make it work the way you'd expect. As a result, Cockpit gets easier to use all the time.

### Team-friendly
Cockpit is friendly enough for those new to Linux and useful for seasoned admins too.

### Packages included
[Installing and running Cockpit]({{ site.baseurl }}/running.html) is simple. It's already included in most of the major distributions.

---

## Integrated

### Plays well with others
You can jump between a terminal and the web interface at any time. There's even an embedded terminal in Cockpit.

Keep using the command line, Ansible, and your other favorite tools and add Cockpit to the mix with no issues.

A service started via Cockpit can be stopped in a terminal. Likewise, if an error occurs in a terminal, it's also in Cockpit's journal.

[![Network screenshot]({{ site.baseurl }}/images/site/screenshot-network.png)]({{ site.baseurl }}/images/site/screenshot-network.png)
{:.screenshot.zoom}

### Sign in like normal
By default, Cockpit uses [your system's normal user logins and privileges]({{ site.baseurl }}/guide/latest/privileges). You don't need to set up any special accounts. Network-wide logins are also supported through [single-sign-on]({{ site.baseurl }}/guide/latest/sso) and other [authentication]({{ site.baseurl }}/guide/latest/authentication) techniques.

### Self-contained
You don't have to worry about setting up a webserver just to use Cockpit.

### Uses existing APIs
Cockpit uses APIs that already exist on the system. It doesn't reinvent subsystems or add a layer of its own tooling.

### Efficient

Cockpit only uses memory and CPU when active. When inactive, there is no extra load on your server.

---

## Glanceable

### System overview
Immediately understand the health of your server. Cockpit's overview page shows current statistics and the status of your system.

### Multi-server
Monitor and administer [several servers]({{ site.baseurl }}/guide/latest/feature-machines.html) at the same time. Add new hosts and your main server will look after its buddies.

[![Dashboard screenshot]({{ site.baseurl }}/images/site/screenshot-dashboard.png)]({{ site.baseurl }}/images/site/screenshot-dashboard.png)
{:.screenshot.zoom}

### Troubleshoot
Fix pesky problems with ease.

- Diagnose network issues
- Spot and react to misbehaving virtual machines
- Inspect SELinux logs and fix common violations in a click

---

## Open-ended

### Pocket-sized
Around the office or on the road? Use your phone's browser to check and manage systems.

### Learn with Cockpit
Not sure what you can do with your servers? Explore Cockpit's friendly interface and use features you might not even realized existed!

### Extendable
Have custom tasks? You can [write your own modules]({{ site.baseurl }}/blog/cockpit-starter-kit.html) to plug into Cockpit.

### Free & free
Cockpit's completely free to use and [available under the GNU LGPL](https://github.com/cockpit-project/cockpit/blob/master/COPYING).

{% endcapture %}


{% capture footer_links %}
About Cockpit
: [Project Ideals and Goals](ideals.html)
: [Cockpit Blog](blog)
: [Blog Feeds](blog/feeds/)
: [Search this site](search.html)
{:.col.footer-links-1}

[Running Cockpit](running.html)
: [Deployment guide](guide/latest/guide.html)
: [Feature internals](guide/latest/features.html)
: [Release Notes and Videos](blog/category/release.html)
: [File a bug in the issue tracker](https://github.com/cockpit-project/cockpit/issues)
{:.col.footer-links-2}

[Contributing](https://github.com/cockpit-project/cockpit/wiki/Contributing)
: [Get the source](https://github.com/cockpit-project/cockpit)
: [Join the mailing list](https://lists.fedorahosted.org/archives/list/cockpit-devel@lists.fedorahosted.org/)
: [IRC #cockpit on Freenode.net](irc://irc.freenode.net:6667/cockpit)
: [Developer tutorials](blog/category/tutorial.html)
: [Developer API reference](guide/latest/development.html)
{:.col.footer-links-3}

*[Feeds]: Atom (similar to RSS), for use in feed readers
{% endcapture %}


{% comment %}
##### Scaffolding #####
{% endcomment %}
{% capture newline %}
{% endcapture %}

{% capture badge %}
{% assign release = site.posts | where: "category", "release" | first %}
{% assign version = release.title | split: " " | last %}
<a href="{{ site.baseurl }}{{ release.url }}" title="{{ release.summary }}">
  <span class="badge-new">Just released:</span>
  <span class="badge-version">Version {{ version }}</span>
  <span class="badge-date">{{ release.date | date: "%-d %b %Y" }}</span>
</a>
{% endcapture %}

<div class="intro-background"></div>

<section class="intro">
  <div class="wrapper"><div class="grid-center-noBottom lede">
    <div class="side-left col-7_md-11-middle">{{ intro-left  | markdownify }}</div>
    <div class="side-right col-5_md-11-bottom"><div class="intro-image">{{ intro-right | markdownify }}</div></div>
  </div></div>
</section>

<div id="page-wrap" class="page-content" role="main">
  <section class="wrapper">
    <div class="badge">{{ badge }}</div>

    <section class="blurbs">
      {% assign blurbs_rendered = blurbs | split: '---' %}
      {% for blurb in blurbs_rendered %}
        {% if blurbs_highlight > forloop.index0 %}
          {% assign highlight = "highlight" %}
        {% else %}
          {% assign highlight = "" %}
        {% endif %}

        {% assign headline = blurb
        | markdownify
        | split: newline
        | where_exp: "line", "line contains 'h2'"
        | first
        | strip_html
        %}
        <section class="blurb {{ highlight }} section--{{ headline | slugify }}">{{ blurb | markdownify }}</section>
      {% endfor %}
    </section>
  </section>
</div>

<footer class="footerlinks">
  <div class="wrapper"><div class="grid-wrap-3_md-2_xs-1">
    {{ footer_links | markdownify }}
  </div></div>
</footer>
{% include page_footer.html %}

<script>
<!--
$(function(){
  $(document).on('click', 'a.screenshot.zoom, .screenshot.zoom a', function(ev){
    desc = $('img', this).attr('alt');
    code = $('<div id="imagePreview" class="image-container zoom-out"><img src="' + this.href + '" alt="' + desc + '"><p>' + desc + "<\/p><\/div>");
    $('body').append(code);
    ev.preventDefault();
  }).on('click', '#imagePreview', function(ev){
    $(this).fadeOut(200, function(){
      $(this).remove();
    });
  });
});
//-->
</script>
