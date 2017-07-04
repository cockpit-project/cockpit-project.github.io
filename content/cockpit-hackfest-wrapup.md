---
title: Cockpit Virtual Hackfest Wrapup
author: Stef Walter
date: 2017-07-03 16:25
tags: cockpit, linux
slug: cockpit-virtual-hackfest-wrapup
category: release
summary: Here's what happened at the Cockpit Hackfest last week in Karlsruhe, Germany. We've were working on virtual machine functionality in Cockpit.
---

Last week a bunch of us met up in Karlsruhe in Germany to work on virtual
machines support in Cockpit. We had some specialists there who helped us
get up to speed with VMs. Tons of pull requests opened, designs put together.
Some of the changes are already merged and
[released in Cockpit 144](https://github.com/cockpit-project/cockpit/releases/tag/144).

Marek helped all of us understand how
[Redux](http://redux.js.org/)
stores
and models data. The oVirt folks are using Redux a lot in front end code
and want to be able to share code. Marius
[managed to reconcile](https://github.com/cockpit-project/cockpit/pull/7121)
Redux with our dialog and
[promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise)
code.

Creating virtual machines is hard. There's a surprising amount of strange
little details and corner cases. Andreas, Garrett, Pavel, Dominik and Michal were
involved in long discussions about how to make this work. And Dominik opened a
[pull request](https://github.com/cockpit-project/cockpit/pull/7128).

![Create dialog](https://raw.githubusercontent.com/cockpit-project/cockpit-design/master/virtual-machines/create-new-vm.png)

![Create dialog details](https://raw.githubusercontent.com/cockpit-project/cockpit-design/master/virtual-machines/create-vm-dialog.png)

Stef and Marek worked on
[sharing](https://github.com/cockpit-project/cockpit/pull/7139)
[code](https://github.com/cockpit-project/cockpit/pull/7133)
[between](https://github.com/cockpit-project/cockpit/pull/7128)
the oVirt javascript code based on Cockpit and the more general
virtual machines code in Cockpit. Since most of the code is shared, we decided we
didn't want to create any further API here that we had to keep stable, but rather
build and develop the two in tandem. In the future some of the specific UI widgets
will be factored out into reusable stable javascript NPM components.

Martin
[refactored Cockpit's access to libvirt](https://github.com/cockpit-project/cockpit/pull/7131)
to be more efficient and scalable with the number of VMs.
It currently uses [virsh](https://libvirt.org/sources/virshcmdref/html-single/).

At the same time Lars and Pavel started a
[DBus based wrapper for libvirt](https://github.com/larskarlitski/libvirt-dbus). This
wrapper should be maintained near other libvirt bindings, such as
[libvirt-python](https://libvirt.org/python.html).

Marius added functionality to
[Delete virtual machines](https://github.com/cockpit-project/cockpit/pull/7113) from the
Cockpit UI.

Stef wrote code to
[boot real virtual machines](https://github.com/cockpit-project/cockpit/pull/7117) during
CI testing. We're using the same [Cirros](http://cirros-cloud.net/) Linux that oVirt and
Openstack use during testing.

And there were more pull requests and discussions, but I'm running out of space.
