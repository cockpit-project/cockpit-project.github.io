---
title: Cockpit 148
author: Martin Pitt
date: 2017-08-04 12:00
tags: cockpit, linux
slug: cockpit-148
category: release
summary: Cockpit with Internet Explorer support
comments: true
---

Cockpit is the [modern Linux admin interface](http://cockpit-project.org/). We release regularly.
Here are the release notes from version 148.

### Support Cockpit in Internet Explorer

When using Microsoft Windows Internet Explorer, navigating between pages and
various other operations caused lost state changes, flickering, and lots of
JavaScript errors. These have been corrected, and automatic tests now run with
Internet Explorer as well.

### Update Cluster/Registry design for image streams

The design of the image streams on the Cluster and Registry pages has been
updated to match the design of the current OpenShift Web Console.

![Image Stream Tag Design](images/registry-imagestreams-design.png)

### Delete Kubernetes session tokens on logout

In situations where the Registry Console or the Dashboard is being used on a
public computer with multiple untrusted users, this could have allowed
subsequent browser users to operate on the previous Kubernetes/OpenShift
session. Now logging out properly cleans the session tokens.

### Detect unregistered RHEL systems on Software Updates page

On RHEL systems which have not yet been registered or whose registration
expired, the Software Page would previously have claimed that "the system is up
to date". Now it detects if the system is unregistered and thus cannot receive
updates:

![Software Updates on unregistered RHEL system](images/updates-unregistered.png)

### Try it out

Cockpit 148 is available now:

 * [For your Linux system](http://cockpit-project.org/running.html)
 * [Source Tarball](https://github.com/cockpit-project/cockpit/releases/tag/148)
 * [Fedora 26](https://bodhi.fedoraproject.org/updates/cockpit-148-1.fc26)
