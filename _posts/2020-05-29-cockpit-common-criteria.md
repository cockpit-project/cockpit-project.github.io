---
title: Aligning Cockpit with Common Criteria
author: marusak
date: 2020-05-29
category: announcement
tags: cockpit common-criteria
slug: cockpit-common-criteria
comments: true
---

In the last few releases new features were delivered to make Cockpit meet the [Common Criteria](https://www.commoncriteriaportal.org/12gg) and thus making it possible to undergo the certification process in the near future.
This certification is often required for large organizations, particularly in the public sector and also gives more confidence in using the Web Console without risking their security.

This article provides a summary of these new changes with reference to the given CC norms.

### Cockpit session tracking

There is a multitude of tools to track logins. Cockpit sessions are now correctly registered in
`utmp`, `wtmp` and `btmp`, allowing them to be displayed in tools like `who`, `w`, `last` and `lastlog`.
Cockpit also works correctly with `pam_tally2` and `pam_faillock`.

```
[root@m1 ~]# who
root     pts/0        2019-12-13 08:09 (172.27.0.2)
admin    web console  2019-12-13 08:09
```

Delivered in version [209](https://cockpit-project.org/blog/cockpit-209.html) and [216](https://cockpit-project.org/blog/cockpit-216.html).

[AC-9 Previous Logon (Access) Notification](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-53r4.pdf)

### Support for banners on the login page

Companies or agencies may need to show warning which states that use of the computer is for lawful purposes, the user is subject to surveillance, and anyone trespassing will be prosecuted.
This must be stated before login so they had fair warning.
Like SSH, Cockpit can optionally show the content of a banner file on the login screen.

This needs to be configured in [/etc/cockpit/cockpit.conf](https://cockpit-project.org/guide/latest/cockpit.conf.5.html). For example to show content of `/etc/issue.cockpit` on the login page:
```
[Session]
Banner=/etc/issue.cockpit
```

![/etc/issue](/images/etc-issue.png)

Delivered in version [209](https://cockpit-project.org/blog/cockpit-209.html).

[FTA_TAB.1 Default TOE access banners](https://www.niap-ccevs.org/MMO/PP/-442-/)

### Session timeouts

To prevent abusing forgotten Cockpit sessions, Cockpit can be set up to automatically log users out of their current session after some time of inactivity.
The timeout can be configure, in minutes, in `/etc/cockpit/cockpit.conf`. For example, to logout user after 15 minutes of inactivity:

```
[Session]
IdleTimeout=15
```

![Automatic logout](/images/session-timeout.png)

Delivered in version [209](https://cockpit-project.org/blog/cockpit-209.html) (with default timeout
of 15 minutes, but since version [218](https://cockpit-project.org/blog/cockpit-218.html) the
default timeout is disabled).

[FMT_SMF_EXT.1.1 Enable/disable session timeout](https://www.niap-ccevs.org/MMO/PP/-442-/)

### Show "last login" information upon log in

Cockpit displays information about the last time the account was used and how many failed login attempts for this account have occurred since the last successful login.
This is an important and required security feature so that users are aware if their account has been logged into without their knowledge or if someone is trying to guess their password.

![Last login banner](/images/last-login-banner.png)

Delivered in version [216](https://cockpit-project.org/blog/cockpit-216.html).

[AU-14 Session Audit (2)](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-53r4.pdf)
