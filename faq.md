---
title: Frequently Asked Questions (FAQ)
---

- this list will be replaced by the Table of Contents
{:toc}

## General

### How do I contact the Cockpit team?

- If you're filing an issue, use our issue tracker.
   - For general Cockpit bugs and feature requests, use [Cockpit's issue tracker](https://github.com/cockpit-project/cockpit/issues).
   - For other parts of Cockpit use specific issues:
      - [Website issues](https://github.com/cockpit-project/cockpit-project.github.io/issues)
      - [Virtual machine related issues](https://github.com/cockpit-project/cockpit-machines/issues)
      - [Podman UI related issues](https://github.com/cockpit-project/cockpit-podman/issues)
      - [OStree related issues](https://github.com/cockpit-project/cockpit-ostree/issues)
    - If you're not sure where to file the issue, [use the general issue tracker](https://github.com/cockpit-project/cockpit/issues). (We can move it if necessary.)
    - If it's not an issue, ask us in the forum or Matrix.
- There's [a discussion forum for Cockpit on GitHub](https://github.com/cockpit-project/cockpit/discussions).
- The Cockpit team is on Matrix, usually during European business hours, from Monday through Friday, at [#cockpit:fedoraproject.org](https://matrix.to/#/#cockpit:fedoraproject.org).
- [Cockpit has a mailing list](https://lists.fedorahosted.org/admin/lists/cockpit-devel.lists.fedorahosted.org/).

### How do I create an application for Cockpit?

All development-focused documentation is located on the [Contribute page](https://cockpit-project.org/external/wiki/Contributing.html) of the website. This includes creating your own [app page with the starter kit](blog/cockpit-starter-kit.html) and other related topics.

## Installation

### How do I install a recent version of Cockpit on Debian or Ubuntu?

While Debian and Ubuntu both ship with access to Cockpit in their main repositories, the version in each might be older than the latest available. This is due to the nature of "stable" and "long term support" distributions.

There's often a newer version of Cockpit available in the "backports" repositories, for both [Debian](https://backports.debian.org/) and [Ubuntu](https://wiki.ubuntu.com/UbuntuBackports). We recommend using this newer version, if you're able to do so.

Please read the installation instructions for the appropriate distribution:
- [Debian installation instructions](running.html#debian)
- [Ubuntu installation instructions](running.html#ubuntu)

### How do I use Cockpit on another port?

Cockpit runs on port 9090 by default. If you'd like to change the port to something else, please [consult the Cockpit guide's section on TCP port and address](https://cockpit-project.org/guide/latest/listen).

### How do I avoid opening a port on my production machines?

It's possible to not run the Cockpit socket systemd service and log into your target machines with SSH.

If you use a Linux-based desktop, use the [Cockpit Client desktop application, available on Flathub](https://flathub.org/apps/details/org.cockpit_project.CockpitClient).

If you cannot use Cockpit Client, we provide Cockpit's web server in the [cockpit/ws container image](https://quay.io/repository/cockpit/ws). You can run that on any other host with SSH access to the target machine. This includes running the container on Kubernetes.

### How do I use Cockpit with a reverse proxy?

Cockpit can be used from behind a proxy.

Read one of the following documents:

- [Proxying Cockpit over NGINX](external/wiki/Proxying-Cockpit-over-NGINX.html)
- [Proxying Cockpit over Apache with LetsEncrypt](external/wiki/Proxying-Cockpit-over-Apache-with-LetsEncrypt.html)
- [Proxying Cockpit with Pomerium](https://www.pomerium.com/docs/guides/cockpit)

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

2. If you run on Ubuntu with arm64 (e.g.: on a Raspberry Pi), install extra Linux kernel modules for networking:

    ```
    sudo apt install linux-modules-extra-raspi
    ```

3. Set up a "dummy" network interface:

    ```
    nmcli con add type dummy con-name fake ifname fake0 ip4 192.0.2.2/24 gw4 192.0.2.1
    ```

4. Reboot

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

### Virtual machines

#### Virtual machines don't boot

If a VM hangs during boot or you see an error message such as "No bootable device", it may be due to a configuration option in your computer's BIOS / EFI settings.

On many servers, desktops, and laptops, the setting is turned off by default.

##### Solution
{:.no_toc}

1. Turn off the computer that is running Cockpit. Then, turn it back on and immediately press the appropriate key to enter the BIOS / EFI settings (e.g. Delete, F1, F12, etc.).
2. In the BIOS / EFI settings, look for the option to enable virtualization and ensure it is enabled.
3. Save the changes and exit the BIOS / EFI settings.
4. Wait for the computer to finish booting and try starting a VM in Cockpit again.

{:.note}
Note: You may need to consult your computer's manual or the manufacturer's website to determine the correct key to press to enter the BIOS/EFI settings. The exact steps for enabling virtualization vary depending on your computer's make and model.

*[VM]: Virtual Machine
