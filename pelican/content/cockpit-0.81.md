Title: Cockpit 0.81 Released
Date: 2015-10-21 22:19
Tags: cockpit, linux, technical
Slug: cockpit-0.81
Summary: Cockpit releases every week. This week it was 0.81

Cockpit releases every week. This week it was 0.81


### NTP servers

Cockpit now allows configuration of which NTP servers are used for time syncing.  This configuration is possible when [timesyncd](http://www.freedesktop.org/software/systemd/man/systemd-timesyncd.service.html) is being used as the NTP service.

<iframe width="640" height="480" src="https://www.youtube.com/embed/Rmzt1L4ANgo?rel=0" frameborder="0" allowfullscreen></iframe>

### Network switch regression

There was a regression in Cockpit 0.78 where certain on/off switches in the networking configuration stopped working. This has now been fixed.


### Delete Openshift routes and deployment configs

In the Kubernetes cluster dashboard, it's now possible to delete Openshift style routes and deployment configs.

### From the future

I've refactored the Cockpit Kubernetes [container terminal widget](https://github.com/kubernetes-ui/container-terminal/) for use by other projects. It's been integrated into the Openshift Web Console for starters. This widget will be used by Cockpit soon.

<iframe width="853" height="480" src="https://www.youtube.com/embed/SMxVQBD3Kho?rel=0" frameborder="0" allowfullscreen></iframe>

### Try it out

Cockpit 0.81 is available now:

 * [Source Tarball](https://github.com/cockpit-project/cockpit/releases/tag/0.81)
 * [Fedora 23 and Fedora Rawhide](https://bodhi.fedoraproject.org/updates/FEDORA-2015-c3b74dffee)
 * [COPR for Fedora 21, 22, CentOS and RHEL](https://copr.fedoraproject.org/coprs/sgallagh/cockpit-preview/)

