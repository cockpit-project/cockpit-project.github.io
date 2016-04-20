Title: Cockpit 0.99 Released
Date: 2016-03-24 18:35
Tags: cockpit, linux, technical
Slug: cockpit-0.99
Category: Cockpit
Summary: Cockpit releases every week. Here's highlights from 0.96 through 0.99

Cockpit is the [modern Linux admin interface](http://cockpit-project.org/). There's a new release every week. Here are the highlights from 0.96 through 0.99.

### Kubernetes Cockpit Pod

The Kubernetes cluster admin interface is now deployable as a [Kubernetes](http://kubernetes.io) pod. Peter did a lot of work to make this happen. It's a good example of taking just one part Cockpit, containerizing it and running it in a completely different environment.

You can use the [commands listed in the documentation](http://cockpit-project.org/guide/latest/feature-kubernetes.html) to run the pod. Here's a demo:

<iframe width="853" height="480" src="https://www.youtube.com/embed/OCbuzBe7Ems?rel=0" frameborder="0" allowfullscreen></iframe>


### Locking down Cockpit with Content-Security-Policy

[Content-Security-Policy](http://content-security-policy.com/) is like SELinux in your browser. You declare
what your application is allowed to do, and the browser prevents other things from happening, like cross site scripting attacks.  Because the Cockpit javascript code has as much access to the system as the logged in user, Cockpit needs to make sure that attackers cannot sneak in javascript code into the browser session.

In the last few releases, a strict policy was applied to the network, Kubernetes, Docker, storage, and accounts parts of the interface, just a few more remaining before all of Cockpit is locked down in this way.


### Debian packages

Cockpit has been testing each change and release against Debian during continuous integration for a while. Lars recently added installable Debian binary packages for each release. We're still looking for a [DD maintainer](https://wiki.debian.org/DebianDeveloper) to help take those tested packages and include them in Debian proper.

See the [documentation for how to use the Cockpit Debian packages](http://cockpit-project.org/running.html).


### From the future

The ability to troubleshoot [SELinux](http://stopdisablingselinux.com/) in Cockpit is pretty exciting. Dominik has lots of the work in this area and it's nearly ready. Watch the video below. Once it's finished you'll be able to just click a button to resolve many (most?) SELinux issues found on a server.

<iframe width="960" height="720" src="https://www.youtube.com/embed/s6C29f8dSRQ?rel=0" frameborder="0" allowfullscreen></iframe>

Garret designed a UI for using Docker with an LVM pool as you would on [Atomic Host](http://www.projectatomic.io/download/). That is: A UI for [docker-storage-setup](https://github.com/projectatomic/docker-storage-setup). I'm looking forward to this in Cockpit. Sneak peak here:

![Container Storage Designs](https://raw.githubusercontent.com/cockpit-project/cockpit-design/9bd7086a4a8492b72269c58272d063b3372116c3/containers/container-storage.png)

### Try it out

Cockpit 0.99 is available now:

 * [For your Linux system](http://cockpit-project.org/running.html)
 * [Source Tarball](https://github.com/cockpit-project/cockpit/releases/tag/0.95)
 * [Fedora 24](https://bodhi.fedoraproject.org/updates/cockpit-0.99-1.fc24)
 * [COPR for Fedora 23, CentOS and RHEL](https://copr.fedoraproject.org/coprs/g/cockpit/cockpit-preview/)

