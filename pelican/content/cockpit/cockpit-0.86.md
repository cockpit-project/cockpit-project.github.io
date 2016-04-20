Title: Cockpit 0.86 Released
Date: 2015-12-04 13:04
Tags: cockpit, linux, technical
Slug: cockpit-0.86
Category: Cockpit
Summary: Cockpit releases every week. This week it was 0.86

Cockpit releases every week. This week it was 0.86.

### SOS Reporting

Users can now prepare an SOS Report containing information about the system and send it to their support representative.

<iframe width="640" height="480" src="https://www.youtube.com/embed/-6rfWUoOQbs?rel=0" frameborder="0" allowfullscreen></iframe>

### From the future

Stef has done work to cleanup the Javascript dependencies of Cockpit. Broadly these fall into two categories:

* Development dependencies: only used while developing Cockpit, not even used while building the tarball. These are ```node_modules```

* Runtime dependencies: used while Cockpit is running and built
into the various Cockpit packages. These are ```bower_components```

The latter should be replaceable at build-time. The cleanup work moves in this direction, but it's not complete yet.

### Try it out

Cockpit 0.86 is available now:

 * [Source Tarball](https://github.com/cockpit-project/cockpit/releases/tag/0.85)
 * [Fedora 23 and Fedora Rawhide](https://bodhi.fedoraproject.org/updates/FEDORA-2015-36d1df063f)
 * [COPR for Fedora 22, CentOS and RHEL](https://copr.fedoraproject.org/coprs/g/cockpit/cockpit-preview/)

