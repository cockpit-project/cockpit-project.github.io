---
title: "Cockpit Files: the first release"
author: jelle
date: 2024-06-10
category: release
tags: cockpit files manager browser
---

Last Friday, we released the first version of Cockpit Files: a plugin for Cockpit to manage files on your server through your web browser. Cockpit Files was initially started by Google Summer of Code (GSoC) student [Mahmoud Hamdy](https://github.com/MahmoudHamdy02) and is now under active development by the Cockpit team. The goal is to replace the functionality of the [cockpit-navigator](https://github.com/45drives/cockpit-navigator/) plugin from 45Drives and include automated testing per commit, a standard PatternFly-based interface, and consistency with the rest of Cockpit.

This initial release already contains several features, including:

- downloading files
- uploading files
- copy and paste
- renaming files and directories
- creating directories
- editing permissions
- icon view, with several filetypes
- details view
- sorting

## Screenshots

The default overview of Cockpit files is an icon based folder view of your home directory.

![Cockpit Files overview](/images/cockpit-files-1-overview.png)
{:.screenshot.left}

Alternatively you can view it as a list and sort on one of the columns.

![Cockpit Files list view](/images/cockpit-files-1-listview.png)
{:.screenshot.left}

Multiple files can be uploaded to your server at once.

![Cockpit Files upload](/images/cockpit-files-1-upload.png)
{:.screenshot.left}

## Try it out

Development builds to try out Cockpit Files are available for Fedora using [our 3rd party Copr repository for Cockpit Files](https://copr.fedorainfracloud.org/coprs/g/cockpit/main-builds/package/cockpit-files).

In the future we expect Cockpit Files to be available as an installable package in Arch Linux, Debian and Fedora.

While Cockpit Files is still relatively new, features that are currently shipped are expected to work. Please file bug reports and feature requests on our [issue tracker](https://github.com/cockpit-project/cockpit-files/issues).

## Looking to the future

We have a lot planned and already thinking about additional features such as:

- a basic file editor, intended for simple configuration files
- cut support, for moving files
- basic SELinux integration
- basic Access Control Lists (ACL) integration
- symbolic link creation
- ...and have several other ideas in store
