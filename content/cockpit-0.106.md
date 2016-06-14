Title: Cockpit 0.106
Date: 2016-05-12 15:40
Tags: cockpit, linux, technical, kubernetes
Slug: cockpit-0.106
Category: release
Summary: Cockpit releases every week. Here's highlights from 0.106

Cockpit is the [modern Linux admin interface](http://cockpit-project.org/). There's a new release every week. Here are the highlights from this weeks 0.106 release.


### Stable Cockpit Styles

One of the annoying things about CSS is that when you bring in stylesheets from
multiple projects, they can conflict. You have to choose a nomen-clature to
namespace your CSS, or nest it appropriately.

We're stabilizing the internals of Cockpit in the browser, so when folks write
plugins, they can count on them working. To make that happen we had to namespace
all our own Cockpit specific CSS classes. Most of the styling used in Cockpit
come from [Patternfly](https://www.patternfly.org/) and this change doesn't affect
those styles at all.

[Documentation is on the wiki](https://github.com/cockpit-project/cockpit/wiki/Cockpit-CSS-Styling)


### Container Image Layers

Docker container image layers are now shown much more clearly. It should be clearer to tell
which is the base layer, and how the others are layered on top:

![Image Layers](images/cockpit-image-layers.png)

### Try it out

Cockpit 0.106 is available now:

 * [For your Linux system](http://cockpit-project.org/running.html)
 * [Source Tarball](https://github.com/cockpit-project/cockpit/releases/tag/0.106)
 * [Fedora 24](https://bodhi.fedoraproject.org/updates/cockpit-0.106-1.fc24)
 * [COPR for Fedora 23, CentOS and RHEL](https://copr.fedoraproject.org/coprs/g/cockpit/cockpit-preview/)

