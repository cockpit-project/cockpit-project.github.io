---
title: Cockpit Virtual Hackfest
author: Stef Walter
date: 2017-06-27 10:25
tags: cockpit, linux
slug: cockpit-virtual-hackfest
category: release
summary: There's a Cockpit Hackfest underway in Karlsruhe, Germany. We're working
  on virtual machine functionality in Cockpit.
---

There's a Cockpit Hackfest underway in Karlsruhe, Germany. We're working on the
virtual machine functionality in Cockpit.

![Hackfest](/images/hackfest-1.jpg)

That means interacting with libvirt. Although libvirt has remoting functionality
it has no API that's actually remotable and callable from Cockpit javascript code.
So Lars and Pavel started working on a DBus wrapper for the API.

At the same time, Martin is working on making the current
[virsh](http://libvirt.org/virshcmdref.html) based access to libvirt more
performant, so we don't block on waiting until the DBus wrapper is done.

Lots of work was done understanding [redux](http://redux.js.org/). The initial
machines code in Cockpit was written using redux, and we needed to map it's
concept of models and state to the Cockpit way of storing state on the server
and UI concepts like dialogs. Everyone was involved.

Andreas, Garrett have been working on designs for creating a virtual machine
and editing virtual machines. Dominik started work on implementing that code.

Marius worked on deletion of virtual machines, and already has a
[pull request](https://github.com/cockpit-project/cockpit/pull/7113) open.

Stef worked on the integration tests for the virtual machine stuff
and is booting nested VMs [using nested images](https://github.com/cockpit-project/cockpit/pull/7117).

![Hackfest](/images/hackfest-2.jpg)

Wheeee.
