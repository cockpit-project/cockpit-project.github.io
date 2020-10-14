---
title: Cockpit 226 and Cockpit Podman 22
author: mvo
date: 2020-08-19
tags: cockpit linux
slug: cockpit-226
category: release
summary: Cockpit and Cockpit Podman news
---

Cockpit is the [modern Linux admin interface](https://cockpit-project.org/).
We release regularly. Here are the release notes from Cockpit version 226 and Cockpit Podman version 22.

### Storage: Better support for "noauto" LUKS devices

Cockpit better respects the LUKS "noauto" option for encrypted filesystems.

Previously, Cockpit would force a encrypted filesystem to mount at next boot when it was simply mounted within Cockpit. Now, encrypted filesystems set with "noauto" will remain unmounted during boot.

Please [refer to issue 14467](https://github.com/cockpit-project/cockpit/issues/14467) for more details.

### Podman: Support for pod group deletion

The cockpit-podman plugin gained the ability to delete pod groups.

![Pod group deletion](/images/podman-pod-deletion.png)

### Try it out

Cockpit 226 and Cockpit-podman 22 are available now:

 * [For your Linux system](https://cockpit-project.org/running.html)
 * [Cockpit Source Tarball](https://github.com/cockpit-project/cockpit/releases/tag/226)
 * [Cockpit-podman Source Tarball](https://github.com/cockpit-project/cockpit-podman/releases/tag/22)
 * [Cockpit Fedora 31](https://bodhi.fedoraproject.org/updates/FEDORA-2020-635cfe8993)
 * [Cockpit-podman Fedora 31](https://bodhi.fedoraproject.org/updates/FEDORA-2020-f9f6691e27)
 * [Cockpit Fedora 32](https://bodhi.fedoraproject.org/updates/FEDORA-2020-90dcc0629f)
 * [Cockpit-podman Fedora 32](https://bodhi.fedoraproject.org/updates/FEDORA-2020-2b6de47fe5)
