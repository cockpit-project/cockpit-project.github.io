Title: Cockpit 0.105
Date: 2016-05-04 14:27
Tags: cockpit, linux, technical, kubernetes
Slug: cockpit-0.105
Category: release
Summary: Cockpit releases every week. Here's highlights from 0.105

Cockpit is the [modern Linux admin interface](http://cockpit-project.org/). There's a new release every week. Here are the highlights from this weeks 0.105 release.


### Strict Content-Security-Policy enforced everywhere

All of the Cockpit components now ship strict Content-Security-Policy. This is like
SELinux in your browser, where you declare the kind of things the application is
permitted to do and anything else is blocked.

Cockpit now only allows talking to and loading code from the server(s) that it's
running on. Everything else is blocked, including inline scripts, evaluating
javascript code, and using inline styles.


### Timeout for Cockpit Authentication

Cockpit uses PAM for authenticating local users. It now expects that authentication
process to complete within a certain timeout.

More details [in this document](https://github.com/cockpit-project/cockpit/blob/master/doc/authentication.md).


### Cluster Users can be Added and Removed from Groups

In the Cluster admin interface, users can be added to groups and remove
them with a few clicks. Here's a short video:

<iframe width="853" height="480" src="https://www.youtube.com/embed/TzvqNj9VywM"frameborder="0" allowfullscreen></iframe>

### Registry Mirroring from Insecure Registries

In [the Registry user interface](http://www.projectatomic.io/registry/) there's now a
checkbox that allows you to choose whether the registry from which you're mirroring
container images is insecure or not.

![Insecure Registry option](images/cockpit-insecure-registry.png)

### Deletion of Kubernetes Nodes

In the Cluster admin interface you can now delete Nodes from the cluster, and select
which ones to delete. Andreas has also done design work to allow upgrading the
node operating system as well as cordoning nodes, which makes them unavailable for
scheduling containers.

![Deleting Nodes](images/cockpit-delete-nodes.png)

### Try it out

Cockpit 0.105 is available now:

 * [For your Linux system](http://cockpit-project.org/running.html)
 * [Source Tarball](https://github.com/cockpit-project/cockpit/releases/tag/0.105)
 * [Fedora 24](https://bodhi.fedoraproject.org/updates/cockpit-0.105-1.fc24)
 * [COPR for Fedora 23, CentOS and RHEL](https://copr.fedoraproject.org/coprs/g/cockpit/cockpit-preview/)

