---
title: Make your Cockpit page easily installable
author: mvo
date: 2018-04-09 10:00
tags: cockpit
slug: making-a-cockpit-application
category: tutorial
comments: 'true'
---

Since version 152, Cockpit can discover and install packages that add
pages to Cockpit.  We call them "Applications" and as of now, only two
of them exist: We have Fleet Commander and Cockpit's own Diagnostic
Reports in Fedora.  You might have seen them on the Applications page:

![Two Cockpit Applications](/images/cockpit-two-apps.png)

If you want your own page to appear there, you have to add suitable
[AppStream](https://www.freedesktop.org/wiki/Distributions/AppStream/)
data to your package in the right location.

When your package is included in a distribution repository, the
repository machinery will find the data in your package and make it
available to software managers, such as the Cockpit "Applications"
page.


For a Cockpit component, the AppStream data looks like this:
```xml
<component type="addon">
  <id>org.cockpit-project.demo-app</id>
  <metadata_license>CC0-1.0</metadata_license>
  <name>Demo Application</name>
  <summary>
    A demo add-on application for Cockpit
  </summary>
  <description>
    <p>This is a demo application</p>
  </description>
  <extends>cockpit.desktop</extends>
  <launchable type="cockpit-manifest">demo-app</launchable>
</component>
```

This would be placed at
`/usr/share/metainfo/org.cockpit-project.demo-app.metainfo.xml` in
your package.

The important bit is the `launchable` element with type
`cockpit-manifest`.  Any such AppStream component will be offered for
installation by Cockpit.  The value is the name of the [Cockpit
package](https://cockpit-project.org/guide/latest/packages.html) for
your page.

Use the component type `addon` and add an `extends` element for
`cockpit.desktop`.

You should of course come up with your own value for the `id` element,
in the usual reverse-DNS style, and adjust the filename accordingly.
