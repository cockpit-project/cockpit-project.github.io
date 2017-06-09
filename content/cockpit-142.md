---
title: Cockpit 142
author: Martin Pitt
date: 2017-06-09 16:00
tags: cockpit, linux
slug: cockpit-142
category: release
summary: Cockpit with Virtual Machine improvements
comments: true
---

Cockpit is the [modern Linux admin interface](http://cockpit-project.org/). We release regularly.
Here are the release notes from version 142.

### Virtual machines display an interactive console

The Virtual Machines page now offers easy access to graphical consoles in the new "Console" tab. If the VM has a VNC server
enabled, then there is now an inline [noVNC](https://github.com/novnc/noVNC) console:

![Machines inline console](images/machines-inline-console.png)

If the VM only has a SPICE server, or the inline console is not sufficient, you can use "Switch to Desktop Viewer" and with a
single button click open virt-viewer for that VM:

![Machines external console](images/machines-external-console.png)

### Try it out

Cockpit 142 is available now:

 * [For your Linux system](http://cockpit-project.org/running.html)
 * [Source Tarball](https://github.com/cockpit-project/cockpit/releases/tag/142)
 * [Fedora 26](https://bodhi.fedoraproject.org/updates/cockpit-142-1.fc26)
