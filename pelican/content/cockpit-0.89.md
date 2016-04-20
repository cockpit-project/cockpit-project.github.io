Title: Cockpit 0.89 Released
Date: 2015-12-22 13:04
Tags: cockpit, linux, technical
Slug: cockpit-0.89
Category: Cockpit
Summary: Cockpit releases every week. This week it was 0.89

Cockpit releases every week. Here's a summary of the 0.87, 0.88 and 0.89 releases.

### OSTree upgrades and rollbacks

Peter worked to finish the basic OSTree UI has been merged into Cockpit.
This lets the admin perform upgrades and rollbacks on Atomic Host.

Colin, Peter and the OSTree guys worked together to build a DBus
interface in rpm-ostree so that callers can interact with the update system.


Demo: https://youtu.be/Tmj0Nrkasmk

Before this is usable by users, the cockpit-ostree package will need to
(be included in Atomic Host, first on Fedora)[https://bugzilla.redhat.com/show_bug.cgi?id=1292826].


Custom login authentication scripts
-----------------------------------

The Cockpit WebService cockpit-ws component now supports custom
authenticators for various auth mechanisms. Some assembly required.

Peter has implemented this as part of containerizing the kubernetes and
docker registry admin dashboards.

https://github.com/cockpit-project/cockpit/blob/master/doc/authentication.md


Stubbed out bridge for non-local users
--------------------------------------

This means that the Cockpit parts can be customized to that we can allow
non-local users to log in and interact with certain Cockpit components
that don't interact with the local system. Again this is part of
containerizing the kubernetes and docker registry admin dashboards.



Specific dashboards can now be shown as default
-----------------------------------------------

A specific Cockpit dashboard can now be shown as the default when
logging in, by specifying a lower "order" than default dashboard.



https://github.com/cockpit-project/cockpit/pull/3317




Fix login on Windows
--------------------

Cockpit no longer prompts for a strange second login (which had to do
with SSO) on Windows. There are some remaining issues with how Cockpit
works on Internet Explorer, but most have been solved.

https://github.com/cockpit-project/cockpit/issues/2164


Host name in self-signed certificate
------------------------------------

In order to make life easier, when generating a self-signed certificate,
Cockpit now includes the local host name. Self-signed certificates
remain a stop gap. Real world deployments should replace them with
properly signed certificates from a certificate authority:

http://cockpit-project.org/guide/latest/https.html



Routine Debian testing
----------------------

The Cockpit Project has started routinely testing each Cockpit pull request on Debian Unstable using real Debian packaging. Marius did some great work here. This means we're are close to doing real continuous delivery to Debian. Next step, a repo, and a maintainer.

https://fedorapeople.org/groups/cockpit/status/debian-unstable.html

Case insensitive cockpit.conf
-----------------------------

The cockpit.conf file is now case insensitive for options and headings. This should make editing it less error prone.

http://cockpit-project.org/guide/latest/cockpit.conf.5.html


Reorder graphs on server summary page
-------------------------------------

Thijs reordered the resource graphs on the server summary page in the same order as GNOME, Windows, and elsewhere.


Syncing of users when adding a server
-------------------------------------

Cockpit no longer requires or suggests that the admin accounts be synced between servers when adding another server to the dashboard. This feature is still available when editing the server options on the dashboard.


Weak dependencies on Fedora 24+
-------------------------------

On Fedora 24 and later, one can have 'Suggests' and 'Recommends' dependencies between packages. Cockpit now takes advantage of these for its 'cockpit' meta package making certain parts removable without removing 'cockpit'.


Vagrantfile working again
-------------------------

The Vagrant file now pulls from the correct lastest binary builds of Cockpit. To use it:

$ git clone https://github.com/cockpit-project/cockpit
$ cd cockpit
$ sudo vagrant up



### SOS Reporting

Users can now prepare an SOS Report containing information about the system and send it to their support representative.

<iframe width="640" height="480" src="https://www.youtube.com/embed/-6rfWUoOQbs?rel=0" frameborder="0" allowfullscreen></iframe>

### From the future

Stef has done work to cleanup the Javascript dependencies of Cockpit. Broadly these fall into two categories:

* Development dependencies: only used while developing Cockpit, not even used while building the tarball. These are ```node_modules```

* Runtime dependencies: used while Cockpit is running and built
into the various Cockpit packages. These are ```bower_components```

The latter should be replaceable at build-time. The cleanup work moves in this direction, but it's not complete yet.

### From the future


Ryan Barry has posted a pull request adding tuned (system performance
profile) support to Cockpit:

https://github.com/cockpit-project/cockpit/pull/3279




### Try it out

Cockpit 0.86 is available now:

 * [Source Tarball](https://github.com/cockpit-project/cockpit/releases/tag/0.85)
 * [Fedora 23 and Fedora Rawhide](https://bodhi.fedoraproject.org/updates/FEDORA-2015-36d1df063f)
 * [COPR for Fedora 22, CentOS and RHEL](https://copr.fedoraproject.org/coprs/g/cockpit/cockpit-preview/)

