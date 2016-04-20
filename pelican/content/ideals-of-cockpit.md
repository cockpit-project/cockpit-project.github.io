Title: The Ideals of Cockpit
Date: 2014-12-18
Category: Cockpit, Linux
Tags: cockpit, linux
Slug: ideals-of-cockpit

[Cockpit](https://cockpit-project.org) is an interactive server admin interface. For those helping contribute to Cockpit, these ideals help us remember what we're trying to accomplish. For others, this page should answer the question: "Why Cockpit?"

These ideals are not a commentary about what is "right" and "wrong" in software in general. Other projects may have different guiding principles. These are ours.

These ideals also help define the scope of Cockpit. That scope is limited, and not meant to subsume all other configuration and/or management software.


Cockpit is discoverable
-----------------------

It should be possible to discover how to perform tasks through Cockpit without reading a help file. Astute readers may note that we have not completely acheived this yet, but this drives design decisions for Cockpit.


Cockpit is remotable
--------------------

Cockpit can be effectively used when you are not sitting next to the server. This may seem obvious. Well, it is obvious.


Cockpit requires no configuration or infrastructure
---------------------------------------------------

The goal is that Cockpit comes with the default server install of a Linux server. It obviously can't be in every minimal install, but we've worked hard to make sure it's suitable for a default install.

Cockpit come "out of the box" ready for the admin to interact with the system immediately, without installing stuff, configuring access controls, making choices, etc.

In cases where there is other infrastructure available we should allow the admin to configure the server to take advantage of it (eg: use single-sign-on against a domain controller). But such infrastructure is not a prerequisite.


Cockpit is zero footprint
-------------------------

Cockpit has (as near as makes no difference) zero memory and process footprint on the server when not in use. The job of a server is not to show a pretty UI to admins, but to serve stuff to others. Cockpit starts on demand via socket activation and exits when not in use.

The system software that Cockpit interacts with remains resident as configured. That's to be expected. But the Cockpit UI goes away.

Disk space usage of Cockpit is minimal and the required set of dependencies is scrutinized.


Cockpit does not own the server
-------------------------------

Cockpit does not take over your server in such a way that you can then only perform further configuration in Cockpit. The admin should be able to effectively move away from Cockpit to the command line (and come back) at will.


Cockpit does not store data or policy
-------------------------------------

As a general rule, Cockpit does not have a data store other than the server configuration itself. A good example of this that we don't have our own concept of users. We allow the server's system users to authenticate using their system credentials. The same users that authenticate over SSH.

Cockpit does not store its own opinion about the state of the server. The Cockpit UI reflects the actual current state of the server.

Cockpit does not make security decisions. Once the user is authenticated they have exactly the same permissions as the user would have if they logged into the server via the console or SSH. When escalating the user's permissions to perform a privileged action, we use the exact same mechanisms (eg: polkit or sudo) that a user would use at the command line.


Cockpit is not configuration management
---------------------------------------

Cockpit itself does not have a predefined template or state for the server that it then imposes on the server. It is imperative configuration rather than declarative configuration.

Cockpit may expose UI elements that interact with configuration management style software installed on the server. Such software may have a declarative configuration, as one would expect. But Cockpit itself has no concept of configuration management, or a desired state for the server.


Cockpit reacts to the server
----------------------------

Cockpit dynamically updates itself to reflect the current state of the server, within a time frame of a few seconds. This is important to the admin experience. An admin should feel that they are on the server itself, and not in some tool. The admin should be able to effectively use a terminal, Cockpit, and other management tools all concurrently.


Cockpit is firewall friendly
----------------------------

Cockpit opens one port for browser connections: by default that is 9090. We work well in cases where a bastion host runs Cockpit and connects out to the other servers via SSH.


Cockpit helps the server evolve coherently
------------------------------------------

When developing Cockpit we run into situations where we notice the underlying server behavior is not coherent. We try to resolve that by contributing in the usual open source fashion, before implementing a hack or work around.


Cockpit is designed first
-------------------------

When developing Cockpit we want to design first and let that drive the implementation. As one would expect, there are often concrete limitations here, but this is the ideal.


Cockpit is only the project name
--------------------------------

Users of Cockpit should feel they are interacting with the underlying Server OS, not with Cockpit.

Cockpit can look different on different operating systems, because it's the UI for the OS, and not a external tool.

When packaging a stable release of Cockpit for release with a given OS, most of the "Cockpit" branding should be removed, and OS specific branding is put in its place.


Cockpit is pluggable
--------------------

Cockpit allows others to add additional UI pieces. We do not allow arbitrary extension of the UI all over the place, but at distinct extension points.
