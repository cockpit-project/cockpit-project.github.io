Title: Cockpit 0.83 and 0.84 Released
Date: 2015-11-19 11:24
Tags: cockpit, linux, technical
Slug: cockpit-0.84
Summary: Cockpit releases every week. This week it was 0.84

Cockpit releases every week. This week it was 0.84. I'll also include notes from 0.83 here.

### Building Cockpit on Debian

At systemd.conf Dominik worked with Michael Biebl one of the Debian systemd maintainers on packaging Cockpit for Debian. We're still looking for a maintainer long term.

Here's a [blog post](http://dominik.perpeet.eu/cockpit-on-debian-8-2) with more details.


### Cross Distro Integration Tests

In Cockpit we run hundreds of tests on real operating systems for each pull request. Without running these tests on an OS it's impossible to know that the features of Cockpit actually works. So far we've been running these tests on Fedora, Atomic, and RHEL. But we'd really like to run them on Debian as well. That'll make Cockpit much more well rounded.

Marius worked on the first steps toward running the tests on Debian, by doing the Cockpit [build inside of our test VM images](https://github.com/cockpit-project/cockpit/pull/3138). Hopefully we'll see more progress on this.


### SELinux certificate file type

The ```cockpit.service``` helpfully sets the appropriate user and group [on the certificates](http://cockpit-project.org/guide/latest/https.html) that cockpit-ws will use for TLS. Now it also sets the SELinux file context type properly, so this is one less things to break for an admin.


### Cockpit manual page

There is now a ```man cockpit``` overview manual page that links to the guide and elsewhere.


### From the future

Marius has done work on an SOS reporting view. Needs some further backend work, but should be ready soon:

<iframe width="640" height="480" src="https://www.youtube.com/embed/-6rfWUoOQbs?rel=0" frameborder="0" allowfullscreen></iframe>

Peter has mostly completed the work to add machines with alternate users, and non-standard SSH ports. Among other things, this is useful for cloud instances. I'm looking forward to seeing this in Cockpit 0.85.


[![Machine Dialogs Wireframes](images/machine-dialogs.png)](https://raw.githubusercontent.com/cockpit-project/cockpit-design/master/add-system/machine-dialogs.png)


### Try it out

Cockpit 0.84 is available now:

 * [Source Tarball](https://github.com/cockpit-project/cockpit/releases/tag/0.84)
 * [Fedora 23 and Fedora Rawhide](https://bodhi.fedoraproject.org/updates/FEDORA-2015-96b41c5190)
 * [COPR for Fedora 22, CentOS and RHEL](https://copr.fedoraproject.org/coprs/g/cockpit/cockpit-preview/)

