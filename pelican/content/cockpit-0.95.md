Title: Cockpit 0.95 Released
Date: 2016-02-12 20:32
Tags: cockpit, linux, technical
Slug: cockpit-0.95
Category: Cockpit
Summary: Cockpit releases every week. Here's highlights from 0.90 through 0.95

Cockpit releases every week. Here are the highlights from 0.90 through 0.95.


Set CPU performance profile via tuned
-------------------------------------

Cockpit can now talk to tuned and set the CPU performance profile of the
system. Thanks to Ryan Barry for doing the initial prototype, and
Jaroslav Škarvada for fixing up tuned to include profile descriptions.

<iframe width="640" height="480" src="https://www.youtube.com/embed/u1ba4aQkueA?rel=0" frameborder="0" allowfullscreen></iframe>


iSCSI initiator support
-----------------------

The iSCSI support that Marius worked on with the storaged folks has
finally landed in a Cockpit release. It was waiting on fixes in some
dependencies. Have a look:

<iframe width="640" height="480" src="https://www.youtube.com/embed/N1Lw2OVLDoo?rel=0" frameborder="0" allowfullscreen></iframe>


Support for WebSocket client in cockpit-bridge
----------------------------------------------

In order to better talk to services like Kubernetes or the Atomic Docker
Registry we've added WebSocket support to the cockpit-bridge. It can now
connect to local WebSockets on the system.

But here's an example of what you can do with that: The demo below shows
GTK+ 3 apps running inside of Cockpit. GTK+ 3 supports HTML5 as a
display mode, and Cockpit can wrap that in authentication and a real
Linux login session:

<iframe width="640" height="480" src="https://www.youtube.com/embed/6ZbTYj3xzzg?rel=0" frameborder="0" allowfullscreen></iframe>


Debian Source Packages
----------------------

As a step towards working getting Cockpit into Debian we now create
Debian source packages during our continuous delivery process. These end
up here for now:

<pre>
deb-src https://fedorapeople.org/groups/cockpit/debian-unstable ./
</pre>


Content Security Policy
-----------------------

Because the Cockpit javascript code has as much access to the system as
the logged in user, Cockpit needs to make sure that attackers cannot
sneak in javascript code into the browser session.

Obviously we do this by escaping HTML output carefully and other best
practices. But in addition to that we've started to deploy Content
Security Policy.

If you're unfamiliar with [Content Security Policy](https://en.wikipedia.org/wiki/Content_Security_Policy)
 it's a bit like SELinux for a browser session. It tells the browser we explicitly don't
want to execute any code, styling or other resources that get loaded
from Cockpit itself.

We haven't turned on the strict policy for all of Cockpit yet, and we're
doing it component by component.


Fix cockpit-ws start while reading from /dev/urandom
----------------------------------------------------

Previously when there were interruptions during reading from
/dev/urandom while starting cockpit-ws, then initialization would fail.
This has now been fixed.


OAuth login support
-------------------

Cockpit now has OAuth login support. It doesn't exactly work out of the
box for logging into a local Linux system, but it can be used to create
custom dashboards or containers based on Cockpit components that use
OAuth to authenticate.

See [the documentation](https://rawgit.com/cockpit-project/cockpit/master/doc/authentication.md)
for more info.


Running RHEL QE Tests
---------------------

When you open a Cockpit pull request, take a look at the test suites
that are run against it.

This week we finished work to run the Cockpit RHEL QE tests upstream git
pull request. Rather than catching issues on the backend of things,
we'll be ahead of the game.


Vagrant without NFS
-------------------

Cockpit's Vagrantfile used to use NFS to keep the git checkout in sync
with the image. This caused many folks to have a hard time using Vagrant
to hack on Cockpit, so the NFS stuff is now dropped. You can still bring
up the vagrant VM as before:

    $ sudo vagrant up

And then access Cockpit on https://localhost:9090

However if you make changes to the stuff in the git repo, you need to
run an extra vagrant command before the running VM will pick it up:

    $ sudo vagrant rsync

See [HACKING.md in the git](https://rawgit.com/cockpit-project/cockpit/master/HACKING.md)
repo for more details.


### Try it out

Cockpit 0.95 is available now:

 * [Source Tarball](https://github.com/cockpit-project/cockpit/releases/tag/0.95)
 * [Fedora 23 and Fedora Rawhide](https://bodhi.fedoraproject.org/updates/cockpit-0.95-1.fc23)
 * [COPR for Fedora 22, CentOS and RHEL](https://copr.fedoraproject.org/coprs/g/cockpit/cockpit-preview/)

