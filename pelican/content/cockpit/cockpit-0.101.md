Title: Cockpit does Kubernetes Data Volumes
Date: 2016-04-08 12:35
Tags: cockpit, linux, technical, kubernetes
Slug: cockpit-0.101
Category: Cockpit
Summary: Cockpit releases every week. Here's highlights from 0.101

Cockpit is the [modern Linux admin interface](http://cockpit-project.org/). There's a new release every week. Here are the highlights from this weeks 0.101 release.

### Kubernetes Volumes

You can now set up Kubernetes [persistent volume claims](http://kubernetes.io/docs/user-guide/persistent-volumes/) through the Cockpit cluster admin interface. These volumes are used to store persistent container data and possibly share them between containers. Each container pod declares the volumes it needs, and when deploying such an application admins configure the locations to store the data in those volumes.

Take a look:

<iframe width="960" height="720" src="https://www.youtube.com/embed/rlWeO_MsJOA?rel=0" frameborder="0" allowfullscreen></iframe>

### Show SELinux failure messages properly

As a follow up from last week, several bug fixes landed in the new SELinux troubleshooting support.

### Try it out

Cockpit 0.101 is available now:

 * [For your Linux system](http://cockpit-project.org/running.html)
 * [Source Tarball](https://github.com/cockpit-project/cockpit/releases/tag/0.101)
 * [Fedora 24](https://bodhi.fedoraproject.org/updates/cockpit-0.101-1.fc24)
 * [COPR for Fedora 23, CentOS and RHEL](https://copr.fedoraproject.org/coprs/g/cockpit/cockpit-preview/)

