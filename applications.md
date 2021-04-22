---
title: Applications
---

{% comment %}
###
### NOTE: Application data is located in _data/applications.yml
###
{% endcomment %}

The Cockpit Web Console is extendable. The Cockpit team and others have built applications that are easy to install.

Often, these applications are available to install with a click of a button on the "Applications" page, but command-line installation is also possible using the package name.

Help us [expand this list](https://github.com/cockpit-project/cockpit-project.github.io/edit/main/_data/applications.yml)! Also consider [developing]({{ site.baseurl }}/external/wiki/Contributing.html) [your own application with the Starter Kit]({{ site.baseurl }}/blog/cockpit-starter-kit.html).

{% assign apps = site.data.applications %}
{% assign grouped = apps | group_by_exp: 'item', 'item[1].official' %}

### Official Cockpit-developed applications
{% assign official = grouped[1].items %}
{% include apps.html apps=official %}

### Red Hat developed applications
{% assign unofficial = grouped[0].items %}
{% include apps.html apps=unofficial %}

### Third party
{% assign thirdparty = grouped[2].items %}
{% include apps.html apps=thirdparty %}