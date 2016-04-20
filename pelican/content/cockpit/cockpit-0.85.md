Title: Cockpit 0.85 Released
Date: 2015-11-27 11:24
Tags: cockpit, linux, technical
Slug: cockpit-0.85
Summary: Cockpit releases every week. This week it was 0.85

Cockpit releases every week. This week it was 0.85.

### Varying users on dashboard machines

Cockpit now supports adding machines to the dashboard with different
user logins for each one. This can be useful in cases where you're
adding cloud instances to your dashboard, and they require logging in
with a *cloud-user* and not the same user as your other servers.

<iframe width="853" height="480" src="https://www.youtube.com/embed/N93I0gzvj5c?rel=0" frameborder="0" allowfullscreen></iframe>


### Non standard SSH ports

When Cockpit connects to a machine that was added to the dashboard, it
does so over SSH. Cockpit can now connect on non-standard SSH ports.

See the video above.


### Troubleshooting machine connectivity

Cockpit now allows you to fix connectivity issues for servers that are
added to the dashboard. This includes adjusting authentication, checking
on host keys and more.

[![Machine Dialogs Wireframes](images/machine-dialogs.png)](https://raw.githubusercontent.com/cockpit-project/cockpit-design/master/add-system/machine-dialogs.png)


### Fix SELinux certificate file type bug

Cockpit 0.84 failed to start on certain distros because SELinux wasn't
available or couldn't be used to reset the certificate file context.
This [bug has been fixed](https://github.com/cockpit-project/cockpit/issues/3206).


### Work around bug in Firefox 42

A bug in Firefox 42 caused Cockpit to often load with a blank screen,
due to layout calculation issues. The layout code has been changed to
work around [this issue](https://bugzilla.redhat.com/show_bug.cgi?id=1185136).


### Docker restart container timeout

Previously Cockpit called the Docker API without a timeout when
restarting containers. This caused Docker to immediately kill the
container without waiting for it to shutdown cleanly. Cockpit now
[passes a timeout](https://github.com/cockpit-project/cockpit/issues/3230).


### From the future

Marius has [made progress](https://github.com/cockpit-project/cockpit/pull/3202)
getting the Cockpit integration test suite to run on Debian. Without the
integration tests running for a certain distro, there's no way to ensure Cockpit
actually works there.


### Try it out

Cockpit 0.85 is available now:

 * [Source Tarball](https://github.com/cockpit-project/cockpit/releases/tag/0.85)
 * [Fedora 23 and Fedora Rawhide](https://bodhi.fedoraproject.org/updates/FEDORA-2015-e368240084)
 * [COPR for Fedora 22, CentOS and RHEL](https://copr.fedoraproject.org/coprs/g/cockpit/cockpit-preview/)

