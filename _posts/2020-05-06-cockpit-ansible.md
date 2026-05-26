---
title: Scale Cockpit troubleshooting to your computing fleet
author: pitti
date: 2020-05-06
category: announcement
tags: cockpit selinux ansible scaling troubleshooting
comments: true
---

You might know Cockpit as a troubleshooting tool for individual machines. But once you discover and test a solution, wouldn't it be nice to apply it to all your other machines in your data center?

Of course, not every problem works this way. You wouldn't extend LVM with a new hard disk on a hundred machines at the same time. But there *are* situations where applying the same task across a multitude of computers makes sense.

In this example, we will adjust the [SELinux policy](https://www.redhat.com/en/topics/linux/what-is-selinux) to our needs and apply it elsewhere.

[Cockpit 210](./cockpit-210.html) introduced a new approach that we want to explore; asking the computer to "show me what I have done". It's now easy to look at SELinux policy changes, compared to the defaults on a machine, in a human-readable form, as a shell script, or an [Ansible](https://www.ansible.com/) [role](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse). The shell script and Ansible role are both suitable for automation across multiple machines.

![SElinux autoscript ansible](/images/selinux-autoscript-ansible.png)

To see SELinux debugging, fixing, and deploying in action, watch this short three-and-a-half minute demo covering the whole workflow. Follow along with steps from "_there's a problem I need to debug_" to "_I'll figure out a solution with Cockpit_" and finally to "_I'll apply this tested solution to my entire fleet of computers_".

<iframe width="960" height="720" src="https://youtube.com/embed/ChXoNofPIjw?rel=0" frameborder="0" allowfullscreen></iframe>

While this approach works for SELinux, not every part of Cockpit can be used in a similar manner. First and foremost, Cockpit always shows the server's current *state*, not its configuration. At a glance, the difference between static configuration, dynamic state (like the IP address of a DHCP network card), or even hardware properties (like the number, capacity, and serials of hard disks) are not necessarily obvious.

But there are certainly more configuration-related places and actions in Cockpit. For example:

 * Enabling or disabling [Simultaneous Multi-Threading](https://access.redhat.com/security/vulnerabilities/L1TF) to mitigate CPU vulnerabilities
 * Enabling or disabling PCP, firewall, kdump, or general systemd units
 * Setting up automatic package updates

Would copying the settings of these and applying them across other machines be useful to you? Do you have other ideas and uses for something like this? If so, please [give us your feedback](https://github.com/cockpit-project/cockpit/issues)!
