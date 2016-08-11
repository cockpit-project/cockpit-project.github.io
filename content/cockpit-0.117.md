Title: Cockpit 0.117
Date: 2016-08-11 12:36
Tags: cockpit, linux, technical
Slug: cockpit-0.117
Category: release
Summary: Cockpit releases every week. Here's highlights from 0.115, 0.116 and 0.117.

Cockpit is the [modern Linux admin interface](http://cockpit-project.org/). There's a new release almost every week. Here are the highlights from this the 0.115, 0.116 and 0.117 releases.

### Configure volumes and environment for a Docker container

Vanlos Wang implemented support for configuring volumes and environment
variables when running a container in the Cockpit UI. This allows you
see what environment variables and volumes an image is pre-configured
to have. It then allows the user to define additional environment variables
and volumes for the new container, and then commit those changes to a
new image if desired.

Take a look:

<iframe width="1280" height="720" src="https://www.youtube.com/embed/l9E78Uevg00"
frameborder="0" allowfullscreen></iframe>


### Setup container and image storage

Marius worked with Dan Walsh and and others to implement a UI for configuring
the Docker container and image storage pool. It's now easy to add additional
disks or storage to that pool, or reset it to a clean state.

On some operating systems like [Atomic Host](http://www.projectatomic.io/download/),
this storage pool is present by default,
and elsewhere this container storage pool can be set up.

Relatedly on the command line, checkout the new
[```atomic storage```](https://raw.githubusercontent.com/projectatomic/atomic/master/docs/atomic-storage.1.md)
sub-command which does the same configuration tasks, that previously had to be configured
with arcane configuration files.

<iframe width="1280" height="720" src="https://www.youtube.com/embed/l9fmMa5WJMk?rel=0"
frameborder="0" allowfullscreen></iframe>


### Support for Network Teaming

Marius also added support for
[configuring network teaming](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Networking_Guide/ch-Configure_Network_Teaming.html)
to Cockpit. Network teams are
similar to network bonds, in that they combine two network interfaces into
one, and involve failover or load balancing modes. But teams have more robust
terminology and implementation.

Since teams are a server side feature, this will replace the functionality for
defining teams in Linux Desktop control center applications.

Support for configuring bonds in Cockpit will remain for the time being until
the team support can be relied upon to completely replace that functionality.
Both NetworkManager and Cockpit are involved in this.

Here's a video demoing the changes:

<iframe width="960" height="720" src="https://www.youtube.com/embed/-sob1W33Xus?rel=0"
frameborder="0" allowfullscreen></iframe>


### Pulling images without authentication from the Openshift Registry

The Openshift image registry now supports pulling images without first
logging in. It can be configured to allow this on a per-project basis.
This allows images to be shared from the registry with a broader audience
of developers or image consumers, such as scripts.

Aaron Weitekamp worked on adding support the Registry console to
configure projects to allow pulling images without authentication.
Here's a video of those changes:

<iframe width="1280" height="720" src="https://www.youtube.com/embed/fpsvtq5hENk" frameborder="0" allowfullscreen></iframe>

### Don't allow formatting extended partitions

Cockpit no longer erroneously allows formatting certain partitions, such as
extended partitions containing other logical partitions.


### Try it out

Cockpit 0.117 is available now:

 * [For your Linux system](http://cockpit-project.org/running.html)
 * [Source Tarball](https://github.com/cockpit-project/cockpit/releases/tag/0.117)
 * [Fedora 24](https://bodhi.fedoraproject.org/updates/cockpit-0.117-1.fc24)
 * [COPR for Fedora 23, CentOS and RHEL](https://copr.fedoraproject.org/coprs/g/cockpit/cockpit-preview/)

