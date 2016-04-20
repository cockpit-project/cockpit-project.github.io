Title: Cockpit 0.100 Released
Date: 2016-04-01 15:30
Tags: cockpit, linux, technical, kubernetes
Slug: cockpit-0.100
Category: Cockpit
Summary: Cockpit releases every week. Here's highlights from 0.100

Cockpit is the [modern Linux admin interface](http://cockpit-project.org/). There's a new release every week. Here are the highlights from this weeks 0.100 release. Even though 0.100 may seem to be a magical number ... it's really just the number after 0.99 :D

### SELinux Troubleshooting

Cockpit can now help you troubleshoot [SELinux](http://stopdisablingselinux.com/) problems, and show you fixes for repairing the various issues. This is pretty amazing for system admins who really would rather be secure, but keep bumping into stuff that SELinux is blocking. There's more to come on both SELinux and troubleshooting in the future. Take a look at what landed in this release:

<iframe width="960" height="720" src="https://www.youtube.com/embed/eBGK6qSmnng?rel=0" frameborder="0" allowfullscreen></iframe>

### Image Registry Interface

There's a new Image Registry user interface. It works with [Atomic Platform](http://www.projectatomic.io/) or [Openshift](https://www.openshift.org/) clusters. By default this shows up in the Cockpit "Cluster" admin dashboard.

But more importantly you can deploy this as a standalone image registry, complete with storage, authentication and an interface. See [www.projectatomic.io/registry](http://www.projectatomic.io/registry) for more info.

Here's a quick demo:

<iframe width="853" height="480" src="https://www.youtube.com/embed/VSOAASf1Usw?rel=0" frameborder="0" allowfullscreen></iframe>

### Storage sliders and more

Marius has been working on cleaning up the storage UI. One of the changes you'll notice is that you can now use a slider to choose a size for new volumes or file systems, and specify the size units you want to use:

![Storage number slider](images/cockpit-storage-slider.png)

Debian builds now also include the Storage page.


### From the future

Peter worked on adding Cluster storage configuration to the Kubernetes admin dashboard. Basic support will be in the next release. Here's a screenshot:

![Kubernetes persistent volume](images/cockpit-kubernetes-storage.png)

### Try it out

Cockpit 0.100 is available now:

 * [For your Linux system](http://cockpit-project.org/running.html)
 * [Source Tarball](https://github.com/cockpit-project/cockpit/releases/tag/0.100)
 * [Fedora 24](https://bodhi.fedoraproject.org/updates/cockpit-0.100-1.fc24)
 * [COPR for Fedora 23, CentOS and RHEL](https://copr.fedoraproject.org/coprs/g/cockpit/cockpit-preview/)

