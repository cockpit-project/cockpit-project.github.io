Title: Cockpit with Docker Restart Policy
Date: 2016-04-14 13:33
Tags: cockpit, linux, technical, kubernetes
Slug: cockpit-0.102
Category: Cockpit
Summary: Cockpit releases every week. Here's highlights from 0.102

Cockpit is the [modern Linux admin interface](http://cockpit-project.org/). There's a new release every week. Here are the highlights from this weeks 0.102 release.

### Docker Restart Policy

When running a Docker container in Cockpit, you can now set the restart policy, so when the docker daemon restarts the containers will be restarted too. Justin Robertson contributed this feature. Take a look.

<iframe width="853" height="480" src="https://www.youtube.com/embed/8YYHui-FQco?rel=0" frameborder="0" allowfullscreen></iframe>

### Single Dialog for Creating Logical Volumes

The storage interface in Cockpit now has a single combined dialog when creating logical volumes.
This is a first tiny step towards advanced LVM2 features such as RAID layouts and caches. The dialog will get more fields and more interesting behavior as we implement more of the features offered by LVM2, such as the various RAID levels, as indicated by the hidden options for the "Purpose" and "Layout" fields.

![Single dialog for logical volumes](images/cockpit-logical-volume-one-dialog.png)

### Storage interface now available on Debian

The storage interface in Cockpit has been enabled and built on Debian. The
[storaged API](https://github.com/storaged-project/storaged/) is now available on Debian too.

### Don't Distribute jshint due to License

We stopped distributing [jshint](http://jshint.com/) or requiring it as a build dependency due
to its [controversial license](https://github.com/jshint/jshint/issues/1234).

### Try it out

Cockpit 0.102 is available now:

 * [For your Linux system](http://cockpit-project.org/running.html)
 * [Source Tarball](https://github.com/cockpit-project/cockpit/releases/tag/0.102)
 * [Fedora 24](https://bodhi.fedoraproject.org/updates/cockpit-0.102-1.fc24)
 * [COPR for Fedora 23, CentOS and RHEL](https://copr.fedoraproject.org/coprs/g/cockpit/cockpit-preview/)

