---
title: Is Cockpit Secure?
date: 2018-09-13 10:00
category: blog
tags: cockpit
slug: is-cockpit-secure
---

Security is vital to your Linux systems. It's not a binary thing though.
Depending on your requirements you end up choosing a level of security that
still allows you and your systems to accomplish what they need to do.

Here's info about [Cockpit's](http://cockpit-project.org/) security, to help
you make those choices. You'll find not only has Cockpit got a solid security
story, but you can use it in all sorts of different ways depending on what
kind of security your systems need.

## Cockpit is a Linux session in your browser

Let's start by stacking the deck against Cockpit. First off it's important to
remember that Cockpit is actually an alternative Linux session ... along side X11,
SSH and VT logins. It's a session in the [PAM](http://www.linux-pam.org/),
[logind](https://www.freedesktop.org/wiki/Software/systemd/logind/), TTY,
[SELinux](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security-Enhanced_Linux/sect-Security-Enhanced_Linux-Confining_Users-Confining_Existing_Linux_Users_semanage_login.html)
 and other senses.
The logged in browser and the javascript code it is running can interact directly
with the system as part of that session.

Try this out if you want. [Log into Cockpit](http://cockpit-project.org/running.html),
and pop up the Javascript console by pressing *Ctrl-Shift-J* in your browser. Now type
commands like the following:

    > zz = cockpit.spawn(["id"])
    > proxy = cockpit.dbus("org.freedesktop.hostname1").proxy()
    > proxy.KernelName

Pretty cool, huh. And that's why Cockpit can be such a powerful and quick way to build
Linux system admin interfaces.

## But are browsers secure?

But can we trust browsers with your security? Firefox is about
[15 million lines of code](https://www.openhub.net/p/firefox/analyses/latest/languages_summary)
that all have to work together, and after looking at the list of
[security updates](https://www.mozilla.org/en-US/security/known-vulnerabilities/firefox/)
you gotta think about what that means for your security.

Any management system with a browser interface requires a secure browser.
That includes
[Satellite](https://www.redhat.com/en/technologies/management/satellite),
[Tower](https://www.ansible.com/tower),
[Foreman](https://www.theforeman.org/),
[Landscape](https://landscape.canonical.com/),
[CloudForms](https://www.redhat.com/en/technologies/management/cloudforms),
[cPanel](https://cpanel.com/) and more. If anything like this interacts with
your systems, then security bugs in browsers have a direct effect on your
system security.

Secondly take a look at any browser based tools that were involved in the
creation or curation of the software installed on your system, including
tools used by your Linux distribution.

If your security requirements are strict and you must avoid browsers at all
costs, then be sure to audit all possible places that browsers were involved
in what's running on your systems. It's harder than you think.

Unless your system is extremely isolated and hand crafted, it turns out that
browsers are already highly involved in many security paths for your systems.
Cockpit does not change this situation significantly.

## Cockpit has no special privileges

Back to Cockpit. What does that session look like? Cockpit itself has no
special privileges. The credentials of the logged in user start a login
session, and Cockpit can perform exactly the tasks that the logged in user
has access to. It has no more or less permissions.

You can examine anything about Cockpit security. Log into Cockpit, open the
*Terminal* page and run commands like the following:

    $ id
    uid=1000(stef) gid=1000(stef) groups=1000(stef),10(wheel)
    $ cat /etc/shadow
    cat: /etc/shadow: Permission denied

If you logged in as a non-root user, you'll find that Cockpit has no
elevated privileges on the system. Try this out via Javascript by
pressing *Ctrl-Shift-J* in Cockpit. Now type commands like
the following:

    > zz = cockpit.spawn(["id"])
    > zz = cockpit.spawn(["cat", "/etc/shadow"])

## Escalating privileges

So if Cockpit only has the privileges of the authenticated user, how does
it perform admin tasks? Well obviously one could log in as root, and the logged
in session would have all capabilities and access to the system.

But logging in directly as root is a poor security practice. Cockpit supports
escalating privileges via [sudo](https://www.sudo.ws/) and/or
[polkit](https://www.freedesktop.org/software/polkit/docs/latest/polkit.8.html).
If, and only if, the logged in user has permission to use sudo or polkit to
escalate privileges.

On the login screen you'll see a checkbox to enable privilege escalation:

![Reuse my password for privileged tasks](/images/cockpit-reuse-password.png)

This checkbox allows Cockpit to use your login password to escalate
privileges via sudo and/or polkit when necessary to perform admin
tasks. This is as if you log in with SSH and then used ```sudo -s```
or similar to perform some admin tasks. Try the following command once
you've logged in with the checkbox:

    $ pkexec bash
    # id
    # uid=0(root) gid=0(root) groups=0(root)

You can track the state of this privilege escalation in the upper right
corner of Cockpit:

![Unlocked option](/images/cockpit-unlocked.png)

## Principle of Least Privilege

A good security practice is to run services, processes or tools with
the least amount of security privilege necessary to perform their task.
To accomplish this, Cockpit is split up in multiple components, each of
which runs with as little access to the system as possible.

On RHEL, Fedora, Ubuntu, Debian and any other distro that we distribute
Cockpit for ... we test and make sure that this privilege separation is
in effect: Including correct SELinux policies, and unprivileged unix users.

Here's some of the privilege separation described:

    stef        9690  ...  Sl  06:08  0:00 cockpit-bridge

The ```cockpit-bridge``` is the part of Cockpit that runs in the login session.
It is similar to a login shell, in that it runs with the privileges and security
context of the logged in user. In the above case I logged in as the ```stef``` user.
If you checked the *Reuse my password for privileged tasks* option on the login
screen, you might also see this process running as ```root``` in which case
```pkexec``` or ```sudo``` was used (see above) to escalate privileges.

    root        9947  ...  S   06:10  0:00 /usr/libexec/cockpit-session

The ```cockpit-session``` part of Cockpit is a small binary that performs
authentication for the logged in user. It uses [PAM](http://www.linux-pam.org/)
or [GSSAPI](https://web.mit.edu/kerberos/krb5-devel/doc/appdev/gssapi.html)
to perform that authentication.  ```cockpit-session``` is installed setuid,
in such a way that it can be launched by the unprivileged ```cockpit-ws``` user
(see below) during user login. This process performs limited tasks, and has a
restrictive SELinux ```cockpit_session_t``` context. Lastly is a reasonably short
program written in plain C so it is easier to audit.

    cockpit-ws 11295  ...  Ssl 06:14  0:00 /usr/libexec/cockpit-ws

This is the component that listens on the network. It hands off
authentication information to the ```cockpit-session``` to perform a login
and launch cockpit-bridge. The ```cockpit-ws``` binary runs as an
unprivileged unix ```cockpit-ws``` user, with a restrictive
SELinux ```cockpit_ws_t``` policy.

## Security Policy within the browser

Cockpit runs javascript code from the system it's logged into. Obviously that
code is protected by the standard
[Same Origin Policy](https://developer.mozilla.org/en-US/docs/Web/Security/Same-origin_policy)
that web browsers adhere to.

But how does Cockpit protect against bugs in the code. How can we be sure that
only the javascript code installed on the system is run, and bugs are not
exploited to run code trojaned into logs or other data loaded by Cockpit?

Browsers have a security technology called
[Content Security Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)
which is sorta like SELinux or Apparmor in your browser. The policy describes
exactly where code can be loaded, what can be run, and what sorts of connections
can be made by the browser.

In Cockpit's case we send a strict ```Content-Security-Policy``` header that
only allows code installed in Cockpit packages on the logged into system to be run.
Although individual parts of Cockpit can
[override this default](http://cockpit-project.org/guide/latest/packages.html#package-manifest),
it's rarely done. The default security policy looks like this:

     Content-Security-Policy: default-src 'self' connect-src 'self' ws: wss:

A failure of *Content Security Policy* will look something like this in your browser's
javascript console:

![Content Security Policy denial](/images/csp-denied.png)

## Security of the network facing TCP port

Cockpit typically listens on TCP port 9090 on a host. This is the
[websm or "Web Systems Manager" network port](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.txt).
Opening a network facing port has security risks. Both the exposed surface
area and stuff listening on that port, in this case ```cockpit-ws```, are risky.

If this is an issue for your systems, you can use Cockpit over the SSH port
already have open. But wait, how does that work? Browsers don't natively speak
the SSH protocol, and getting a browser to do so would be an impressive party trick.

To use Cockpit over SSH, use a *bastion host model*: Start ```cockpit-ws``` on port 9090
on a single host, perhaps even your localhost. Connect to that with your
browser and use that first Cockpit instance to log into to Cockpit on other machines
others over SSH. If you draw it up, it looks something like this:

![Multi-host Transport](/images/transport-multi-small.png)

[Atomic Host includes Cockpit by default](http://www.projectatomic.io/docs/cockpit/),
in this way. Atomic Host doesn't include ```cockpit-ws``` or open port 9090 by default,
but expects you to connect from another running Cockpit instance over port 22. There's
also the possibility to run ```cockpit-ws``` as a container to accomplish this.

When you're trying this out in real life, specify an alternate server on the Cockpit
login screen. The SSH protocol will be used to connect to it:

![Login Alternate Server](/images/cockpit-login-alternate.png)

Or you can add other machines to a local dashboard, and Cockpit will connect to
them via SSH. Even usage of SSH key based authentication works great:

<iframe width="853" height="480" src="https://www.youtube.com/embed/Ye5YlVNXC9w" frameborder="0" allowfullscreen></iframe>

Obviously, when you use Cockpit over SSH, it's not just a real Linux session,
it's also an SSH session in every way. Try it out.

## But what about the Web Server

Cockpit doesn't use a web server like Apache, NGINX or Lightttp. It doesn't use an
application server like Tomcat. So by and large the security concerns related to
deploying those projects do not apply here. Cockpit implements just enough of an HTTP
server to serve the Cockpit application to your browser.

This tiny HTTP server is included in the ```cockpit-ws``` process, and protected
via strong SELinux and unix privilege separation.

But if you're environment is uncomfortable with use of the Cockpit built-in HTTP server,
environments use Cockpit over SSH as seen in the section above.

## In conclusion

I could go further about how Cockpit uses
[Kerberos to do single sign on](http://cockpit-project.org/guide/latest/sso.html)
or [how it works with certificates](http://cockpit-project.org/guide/latest/https.html)
or how you can even bring
[your own authentication tool](https://raw.githubusercontent.com/cockpit-project/cockpit/master/doc/authentication.md)
to replace ```cockpit-session```. and much, much more.

But suffice it to say, that Cockpit's security is well thought out, layered and
matches that of Linux in general.
