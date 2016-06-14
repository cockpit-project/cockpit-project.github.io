Title: Cockpit 0.104
Date: 2016-04-28 15:21
Tags: cockpit, linux, technical, kubernetes
Slug: cockpit-0.104
Category: release
Summary: Cockpit releases every week. Here's highlights from 0.104

Cockpit is the [modern Linux admin interface](http://cockpit-project.org/). There's a new release every week. Here are the highlights from this weeks 0.104 release.


### Kubernetes iSCSI Volumes

Peter added support for iSCSI Kubernetes Volumes in the Cockpit Cluster dashboard. When you
have container pods that need to store data somewhere, it's now real easy to configure use
an iSCSI initiator. Take a look:

<iframe width="853" height="480" src="https://www.youtube.com/embed/ytNGsIDYNSQ" frameborder="0" allowfullscreen></iframe>


### Listing View Expansion

Andreas, Dominik, and I worked on a better listing view pattern. In Cockpit we like to give
admins the option to expand data inline, and compare it between multiple entries on the same
page. But after feedback from the [Patternfly folks](https://www.patternfly.org/) we added an
explicit expander to do this.

<iframe width="853" height="480" src="https://www.youtube.com/embed/myXr_hnr5Jg" frameborder="0" allowfullscreen></iframe>


### Tagging Docker Images in the Registry

The Atomic Registry and Openshift Registry support mirroring images from another image registry
such as the Docker Hub. When the images are mirrored, they are copied and available in your
own registry. Cockpit now has support for telling the registry which specific tags you'd like
to mirror. And Aaron is adding support for various mirroring options as well.

<iframe width="853" height="480" src="https://www.youtube.com/embed/MJzqob5AYI8" frameborder="0" allowfullscreen></iframe>


### From the Future

Marius has a working proof of concept that lets you configure where Docker stores container and image
data on its host. Take a look at the demo below. Marius adds disks to the container storage pool:

<iframe width="960" height="720" src="https://www.youtube.com/embed/9YiG4AY6HeY?rel=0" frameborder="0" allowfullscreen></iframe>


### Try it out

Cockpit 0.104 is available now:

 * [For your Linux system](http://cockpit-project.org/running.html)
 * [Source Tarball](https://github.com/cockpit-project/cockpit/releases/tag/0.104)
 * [Fedora 24](https://bodhi.fedoraproject.org/updates/cockpit-0.104-1.fc24)
 * [COPR for Fedora 23, CentOS and RHEL](https://copr.fedoraproject.org/coprs/g/cockpit/cockpit-preview/)

