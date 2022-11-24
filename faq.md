---
title: Frequently Asked Questions (FAQ)
---

- this list will be replaced by the Table of Contents
{:toc}

## Installation

### How do I install a recent version of Cockpit on Debian or Ubuntu?

While Debian and Ubuntu both ship with access to Cockpit in their main repositories, the version in each might be older than the latest available. This is due to the nature of "stable" and "long term support" distributions.

There's often a newer version of Cockpit available in the "backports" repositories, for both [Debian](https://backports.debian.org/) and [Ubuntu](https://wiki.ubuntu.com/UbuntuBackports). We recommend using this newer version, if you're able to do so.

Please read the installation instructions for the appropriate distribution:
- [Debian installation instructions](running.html#debian)
- [Ubuntu installation instructions](running.html#ubuntu)

### How do I use Cockpit with a reverse proxy?

Cockpit can be used from behind a proxy.

Read one of the following documents:

- [Proxying Cockpit over NGINX](external/wiki/Proxying-Cockpit-over-NGINX.html)
- [Proxying Cockpit over Apache with LetsEncrypt](external/wiki/Proxying-Cockpit-over-Apache-with-LetsEncrypt.html)

## Development

### How do I build an app for Cockpit?

- [Starter Kit](blog/cockpit-starter-kit.html)
- [Make your Cockpit page easily installable](blog/making-a-cockpit-application.html)
- [Additional developer-related resources are on the Contributing page](external/wiki/Contributing.html)

## Troubleshooting

### Login

#### Blank white page after login

If you see a blank page after logging in, it's a good first step to check the browser console (`Ctrl`+`Shift`+`J` in most browsers) and system logs (using `sudo journalctl --since "5 minutes ago"` on your system running Cockpit) for related error messages.

##### Blank page with a Proxy

You may be using Cockpit with an improperly set up proxy.

###### Solutions
{:.no_toc}

- [Proxying Cockpit over NGINX](external/wiki/Proxying-Cockpit-over-NGINX.html)
- [Proxying Cockpit over Apache with LetsEncrypt](external/wiki/Proxying-Cockpit-over-Apache-with-LetsEncrypt.html)

##### Blank page using Safari

Older versions of Safari on iPhones, iPads, and Safari on macOS on M1 (ARM) machines have a problem with encrypted WebSocket.

###### Solution
{:.no_toc}

Newer updates of Safari no longer have this issue, but some older [devices may need to use a workaround](running/safari.html).

### Software update

#### Error message about "OSTree"

You're seeing "OSTree is not available on this system" or "Unable to communicate with OSTree" instead of a software update page.

In all likelihood, this means you have `cockpit-ostree` installed on a system that does not use `rpm-ostree` to manage its packages. You should be using Cockpit's PackageKit-based software updater in `cockpit-packagekit`, not `cockpit-ostree`.

##### Solution
{:.no_toc}

Remove the ostree package:

```
dnf remove cockpit-ostree
```

`cockpit-ostree` is only intended for use on distributions that use `rpm-ostree`, such as Fedora Silverblue, Fedora Kinoite, Fedora IoT, Fedora CoreOS, and a small subset of Red Hat Enterprise Linux that uses `rpm-ostree`.

#### Error message about being offline

The software update page shows "packagekit cannot refresh cache whilst offline" on a Debian or Ubuntu system.

##### Solution
{:.no_toc}

Create a placeholder file and network interface.

1. Create `/etc/NetworkManager/conf.d/10-globally-managed-devices.conf` with the contents:

    ```ini
    [keyfile]
    unmanaged-devices=none
    ```

2. Set up a "dummy" network interface:

    ```
    nmcli con add type dummy con-name fake ifname fake0 ip4 1.2.3.4/24 gw4 1.2.3.1
    ```

3. Reboot

##### Explanation
{:.no_toc}

Ubuntu uses two different network stacks which don't play so well together.

Cockpit's software update page uses PackageKit, which checks NetworkManager. However, as the network interfaces are primarily managed by netplan and systemd-networkd in Ubuntu, NetworkManager reports back to PackageKit that the network is offline as a critical error message and stops further actions.

Unfortunately, this means in many Ubuntu configurations, Cockpit's software update page might fail with a message about not being able to "refresh cache whilst offline". Other software that relies on PackageKit, such as KDE's Discover, can also hit this bug.

Additionally, there's nothing Cockpit itself can do to fix this problem. It's an "emergent bug" that happens much lower in the software stack. It's up to Ubuntu to patch the way they're using netplan and networkd... or, alternatively, PackageKit could provide a workaround. Unfortunately, none of these fixes have been implemented yet.

Meanwhile, to be able to update your server using Cockpit when you get this error, you have to do a workaround similar to the one suggested above.

#### Excludes in dnf.conf are ignored

When there are specific package excludes, the Software update page may still show packages are available to update.

##### Solution
{:.no_toc}

Add excludes to the .repo files with a space-separated list. Wildcards `*` and `?` are supported.

```ini
exclude=emacs-* jed xeyes
```

##### Explanation
{:.no_toc}

Cockpit uses PackageKit for the Software updates page. PackageKit does not currently support excludes, except in `.repo` files.

More details at:
- [Red Hat bug 1237014: PackageKit ignores exclude in /etc/dnf/dnf.conf](https://bugzilla.redhat.com/show_bug.cgi?id=1237014#c6)
- [Cockpit bug #17955: Cockpit update is ignoring excludes in yum/dnf configurations](https://github.com/cockpit-project/cockpit/issues/17955)
- [SysTutorials: How to exclude a package from a specific repository only in yum?](https://www.systutorials.com/how-to-exclude-a-package-from-a-specific-repository-only-in-yum/)