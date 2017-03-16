---
title: Cockpit 135
author: Dominik Perpeet
date: 2017-03-15 22:00
tags: cockpit, linux
slug: cockpit-135
category: release
summary: Cockpit with authorization and authentication changes
comments: true
---

Cockpit is the [modern Linux admin interface](http://cockpit-project.org/). We release regularly.
Here are the release notes from version 135.

### Redesigned sidebar navigation

The existing page menu took some getting used to for some use cases. It's now easier to use when connected to multiple
hosts and provides the basis for future improvements that will reduce or remove the horizontal menu entries. On systems
where the top navigation bar doesn't have any useful information, such as when there is no Dashboard, the top
navigation bar is removed entirely. Check out the screenshot below for a peek at the new sidebar design.

![Sidebar navigation](http://cockpit-project.org/blog/images/cockpit-page-menu.png)

### Indicator in top bar shows privilege escalation

On the login page a user can allow Cockpit to use the password for privileged tasks. A new indicator in the top bar
shows an ```unlocked``` state when these privileges are available and a ```locked``` state if they aren't. The user
can click on the indicator in the ```unlocked``` state to drop privileges for the rest of the session. In some cases
privileges cannot be dropped - among others for root and no-password sudo users - and the indicator will disappear.
Check out the video below to see this in action.

<iframe width="560" height="315" src="https://www.youtube.com/embed/3eZSYW89zMI?ecver=1" frameborder="0" allowfullscreen></iframe>

### Disks are now shown for virtual machines

The expanded information for entries on the ```Virtual Machines``` page now contains information on a machine's disks,
such as the device, read only state and for disk images the local file path. Information on disk capacity is only
available with more recent versions of libvirt. Check out the screenshot below to see how this looks.

![Virtual machine disks](http://cockpit-project.org/blog/images/cockpit-vm-disks.png)

### New developer tool can close active Cockpit pages

Once pages in Cockpit, such as ```Networking``` or ```System```, are opened they usually stay open in the background,
even if they aren't visible. This is important on most pages to ensure the code can continue interacting with the
system in the background, user input isn't lost, and the page doesn't have to be reloaded when the user returns to it.
For the cases when a user wishes to actually close the page there is a new entry next to ```Display Language``` in
the user drop down menu, named ```Active Pages```. It only becomes visible when the ```ALT``` key is pressed while
clicking on the menu dropdown. On some drag enabled browsers it doesn't work to just use ```ALT```, but any combination
involving ```ALT```, such as ```CTRL+ALT```, also works. Check out the screenshot below for a peek.

![Active Pages](http://cockpit-project.org/blog/images/cockpit-active-pages.png)

### SSH connections established within the user session

When one Cockpit instance connects to other machines it does so via SSH. Previously
these connections were launched from cockpit-ws, the process listening on the network.

As part of making Cockpit mirror standard Linux practices better, SSH connections are
now made from within the logged in user session, launched from the cockpit-bridge
process. This allows Cockpit to use credentials from the logged in user session while
establishing those SSH connections, such as kerberos tickets, the ssh-agent or private keys.

### Try it out

Cockpit 135 is available now:

 * [For your Linux system](http://cockpit-project.org/running.html)
 * [Source Tarball](https://github.com/cockpit-project/cockpit/releases/tag/135)
 * [Fedora 25](https://bodhi.fedoraproject.org/updates/cockpit-135-1.fc25)
