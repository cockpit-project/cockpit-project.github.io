Title: Cockpit 0.82 Released
Date: 2015-10-28 19:05
Tags: cockpit, linux, technical
Slug: cockpit-0.82
Summary: Cockpit releases every week. This week it was 0.82

Cockpit releases every week. This week it was 0.82

### Distributed Tests

In Cockpit we run thousands of integration tests per day against pull requests and git master. Each test brings up up Cockpit in a full operating system VM, and hammers on it in some way. Without these tests it's impossible to validate that Cockpit actually works.

Last week, the server doing this testing work broke down. I've been working over the last week to fix that, along with others.

But we've done more, instead of just putting this on another server, we've worked to make these integration tests run in a distributed manner across several machines each doing a part of the tests.

The tests are staged via privileged containers, and run in libvirt VMs.

Here's [some documentation](https://github.com/cockpit-project/cockpit/blob/master/test/README) on how to use the new tests.


### Certificate Chains

Cockpit has supported using certificate chains for its cockpit-ws component, but only when the underying GLib (2.44+) supported it. In this release we start to support running TLS with proper certificate chains even on older GLib versions. The [documentation](http://cockpit-project.org/guide/0.82/https.html#https-certificates) and appropriate tests were updated.

### Try it out

Cockpit 0.82 is available now:

 * [Source Tarball](https://github.com/cockpit-project/cockpit/releases/tag/0.82)
 * [Fedora 23 and Fedora Rawhide](https://bodhi.fedoraproject.org/updates/FEDORA-2015-273bc74c11)
 * [COPR for Fedora 21, 22, CentOS and RHEL](https://copr.fedoraproject.org/coprs/sgallagh/cockpit-preview/)

