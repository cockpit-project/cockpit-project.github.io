Title: Cockpit on RHEL Atomic Beta
Date: 2014-11-20
Category: Cockpit
Tags: cockpit, linux, rhel, atomic
Slug: cockpit-on-rhel-atomic-beta

If you've tried out the [RHEL Atomic Host Beta](http://developerblog.redhat.com/2014/11/11/red-hat-enterprise-linux-7-atomic-host-beta-now-available/) you might notice that Cockpit is not included by default, like it is in the Fedora Atomic or CentOS Atomic. But there's an easy work around:

    ::::text
    $ sudo docker run --privileged -v /:/host -d stefwalter/cockpit-atomic:wip

This is an interim solution, and has some drawbacks:

 * Only really allows Cockpit to be used as root.
 * The Storage and user accounts UIs don't work.

And in general privileged containers are a mixed bag. They're not portable, and really not containers at all, in the sense that they're not contained.  But this is an easy way to get Cockpit going on RHEL Atomic for the time being.
