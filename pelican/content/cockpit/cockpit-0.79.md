Title: Cockpit 0.79 Released
Date: 2015-10-07 22:23
Tags: cockpit, linux, technical
Slug: cockpit-0.79
Summary: Cockpit releases every week. This week it was 0.79

Cockpit releases every week. This week it was 0.79

### Vagrant File

Cockpit now has a vagrant file. If you want to checkout the latest
Cockpit, test pull requests, or hack on Cockpit, you can:

    :::text
    $ sudo vagrant up

... in a Cockpit git repo. There's a
[tutorial with more information](http://stef.thewalter.net/cockpit-vagrantfile.html)


### Testing with libvirt

Dominik migrated the Cockpit integration tests to run on libvirt, rather
than using Qemu directly. This makes the tests more portable, and is an
important step towards running them distributed.


### From the future

Marius has done some work on configuring NTP servers. Hopefully this will
be in a release soon:

<iframe width="640" height="480" src="https://www.youtube.com/embed/aZ1Nm2ZkW3Q?rel=0" frameborder="0" allowfullscreen></iframe>


### Try it out

Cockpit 0.79 is available now:

 * [Source Tarball](https://github.com/cockpit-project/cockpit/releases/tag/0.79)
 * [Fedora 23 and Fedora Rawhide](https://bodhi.fedoraproject.org/updates/FEDORA-2015-7e1880ba02)
 * [COPR for Fedora 21, 22, CentOS and RHEL](https://copr.fedoraproject.org/coprs/sgallagh/cockpit-preview/)

