Title: Cockpit 0.77 Released
Date: 2015-09-23 21:23
Tags: cockpit, linux, technical
Slug: cockpit-0.77
Summary: Cockpit releases every week. This week it was 0.77

Cockpit releases every week. This week it was 0.77

### Componentizing Cockpit

Marius and Stef completed a long running refactoring task of splitting
Cockpit into components.

In an age long gone Cockpit used to be one monolithic piece of HTML and
javascript. Over the last year we've steadily refactored to split this
out so various components can be loaded optionally and/or from different
servers depending on capabilities and operating system versions.

Marius also removed a cockpitd DBus service that we've also been moving
away from. Cockpit wants to talk to system APIs and not install its own
API wrappers like cockpitd.


### The URLs changed

Because of the above, we unfortunately had to change the URLs. But we've
taken the opportunity to make them a lot simpler and cleaner.

<iframe width="640" height="480" src="https://www.youtube.com/embed/xLa4uRyGVrA?rel=0" frameborder="0" allowfullscreen></iframe>

### Authentication when Embedding Cockpit

Stef worked on partitioning the cockpit authentication so that embedders
of Cockpit components don't need to share authentication state with a
normal instance of Cockpit loaded in a browser.

<iframe width="640" height="480" src="https://www.youtube.com/embed/xbxvEFXaIGw?rel=0" frameborder="0" allowfullscreen></iframe>

### Deleting and Adjusting Kubernetes Objects

Subin implemented deletion kubernetes objects, and adjust things like
the number of replicas in Replication Controllers.

<iframe width="640" height="480" src="https://www.youtube.com/embed/tiv9tIs4qkw?rel=0" frameborder="0" allowfullscreen></iframe>


### Warning when too many machines

Cockpit now gives a warning when adding "too many" machines to the
dashboard. We've set the warning to 20 machines, but various operating
systems can set this warning to be lower.

![Screenshot](https://trello-attachments.s3.amazonaws.com/55d623eddcb5795e8b5cff13/968x790/0e77b8ce653b79d29a2cc9de75b86b03/dc0c74d8-5e2f-11e5-91fc-901b633a059d.png)


### From the Future

Andreas did designs for managing the SSH keys loaded for use when connecting to machines:

![Wireframes](https://trello-attachments.s3.amazonaws.com/55f14b769262e42e89775936/3555x3301/0c0166255eaf092025c8a5c95f84f15f/ssh-keys-v2.png)


### Try it out

Cockpit 0.77 is available now here:

 * [Source Tarball](https://github.com/cockpit-project/cockpit/releases/tag/0.77)
 * [Fedora 23 and Fedora Rawhide](https://bodhi.fedoraproject.org/updates/FEDORA-2015-16557)
 * [COPR for Fedora 21, 22, CentOS and RHEL](https://copr.fedoraproject.org/coprs/sgallagh/cockpit-preview/)

