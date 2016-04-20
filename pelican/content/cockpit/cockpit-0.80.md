Title: Cockpit 0.80 Released
Date: 2015-10-14 22:19
Tags: cockpit, linux, technical
Slug: cockpit-0.80
Summary: Cockpit releases every week. This week it was 0.80

Cockpit releases every week. This week it was 0.80

### SSH private keys

You can now use Cockpit to load SSH private keys into the ssh-agent that's
running in the Cockpit login session. These keys are used to authenticate
against other systems when they are added to the dashboard. Cockpit also
supports inspecting and changing the passwords for SSH private keys.

<iframe width="853" height="480" src="https://www.youtube.com/embed/RZ_N2iCPm_U" frameborder="0" allowfullscreen></iframe>

### Always start an SSH agent

Cockpit now always starts an SSH agent in the Cockpit login session. Previously
this would happen if the correct PAM modules were loaded.

### From the future

Peter has done work to build an OSTree UI, useful for upgrading and rolling back
the operating system on Atomic Host:

[![OSTree Design Work](images/cockpit-ostree-design.png)](https://raw.githubusercontent.com/cockpit-project/cockpit-design/master/software-updates/software-updates-ostree-alt.png)

Subin has done work to get Nulecule Kubernetes applications working with Atomic
and larger Kubernetes clusters.

### Try it out

Cockpit 0.80 is available now:

 * [Source Tarball](https://github.com/cockpit-project/cockpit/releases/tag/0.80)
 * [Fedora 23 and Fedora Rawhide](https://bodhi.fedoraproject.org/updates/FEDORA-2015-28a7f2b07f)
 * [COPR for Fedora 21, 22, CentOS and RHEL](https://copr.fedoraproject.org/coprs/sgallagh/cockpit-preview/)

