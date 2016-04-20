Title: Cockpit's Kubernetes Dashboard
Date: 2015-06-09 23:51
Tags: cockpit, technical, kubernetes
Slug: cockpit-kubernetes-dashboard

Here's a video showing what I've been working on together with some help from a couple Cockpit folks. It's a [Cockpit](http://cockpit-project.org) dashboard for Kubernetes.

If you haven't heard about [Kubernetes](http://kubernetes.io/) ... it's a way to schedule docker containers across a cluster of machines, and take care of their networking, storage, name resolution etc. It's not completely baked, but pretty cool when it works.

<iframe src="http://www.youtube.com/embed/Fcfsu22RssU" html5=1 frameborder="0" height="450" width="800" type="text/html">
</iframe>

The Cockpit dashboard you see in the video isn't done by any means ... there's a lot missing. But I'm pretty happy with what we have so far. I'm using Cockpit 0.61 in the demo. There are some nagging details to make things work, but hopefully we can solve them later. The Nulecule support isn't merged yet, [Subin has been working on it](https://github.com/cockpit-project/cockpit/pull/2332).

The Cockpit dashboard actually mostly works with [Openshift v3](https://github.com/openshift/origin). Openshift v3 is based on Kubernetes underneath, which makes apps that are developed there really portable.
