---
title: The Ideals of Cockpit
---

[Cockpit]({{ site.baseurl }}) is an interactive server admin interface. For those helping contribute to Cockpit, these ideals help us remember what we’re trying to accomplish. For others, this page should answer the question: “Why Cockpit?”

These ideals are not a commentary about what is “right” and “wrong” in software in general. Other projects may have different guiding principles. These are ours.

These ideals also help define the scope of Cockpit. That scope is limited, and not meant to subsume all other configuration and/or management software.

### Cockpit is discoverable

It should be possible to discover how to perform tasks through Cockpit without reading a help file.

### Cockpit directly interacts with and reacts to the system

Cockpit does not store its own opinion of the state of the server anywhere. The UI always reflects the actual current state of the server. Cockpit reacts to system changes immediately, using the same system APIs that are used by command line tools.

Also, Cockpit does not make any security decisions. Once the user is authenticated they have exactly the same permissions as the user would have if they logged into the server via the console or SSH. Existing mechanisms are used to escalate privileges (e.g.: polkit or sudo).

Thus, Cockpit does not take over the server. It is always possible to move away from Cockpit to the command line and come back at will.

### Cockpit requires no configuration or infrastructure

The goal is that Cockpit comes with the default server install of a Linux server, except for really minimal installs. Cockpit comes “out of the box” ready for the admin to interact with the system immediately.

In cases where there is other infrastructure available we should allow the admin to configure the server to take advantage of it (e.g.: use single-sign-on against a domain controller). But such infrastructure is not a prerequisite.

### Cockpit is not configuration management

Cockpit itself does not have a predefined template or state for the server that it then imposes on the server. It is imperative configuration rather than declarative configuration.

Cockpit may expose UI elements that interact with configuration management style software installed on the server. Such software may have a declarative configuration, as one would expect. But Cockpit itself has no concept of configuration management, or a desired state for the server.

### Cockpit is only the project name

People using Cockpit should feel they are interacting with the underlying Server OS. Cockpit can look different on different operating systems, because it’s the UI for the OS, and not an external tool.

Thus the UI should never actually show the 'Cockpit' name, but call the server by its name or operating system.

### Cockpit has zero footprint

The tools to configure the server itself should not waste resources needed for that. As such, Cockpit has (as near as makes no difference) zero memory and process footprint on the server when not in use. Disk space usage of Cockpit is minimal and the required set of dependencies is scrutinized.

### Cockpit is designed first

When developing Cockpit we want to design first, with real-world use cases driving which features we work on.

### Cockpit helps the server evolve coherently

When developing Cockpit we run into situations where we notice the underlying server behavior is not coherent. We try to resolve that by contributing in the usual open source fashion, before implementing a hack or work around.

### Cockpit is tested

Every feature and change in Cockpit is covered by an automatic test. A proposed change only lands in the code base after it passes all tests. Tests run on all [Operating System](running.html) releases on which Cockpit is supported.

In addition, the design of new features and changes in existing features are tested in usability studies.

### Cockpit is backwards-compatible

Cockpit can connect to other instances of itself. These might be much older, because we support many operating systems with different release cadences. To achieve that, Cockpit's Javascript API may not change in an incompatible way. External Cockpit components that use this API should continue to function despite newer versions of Cockpit being released.

There is no forseen major incompatible version change for this Javascript API in Cockpit's future.
