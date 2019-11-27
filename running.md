---
title: Running Cockpit
class: running-cockpit body-cockpit
---

{% capture newline %}
{% endcapture %}

If you already have Cockpit on your server, point your web browser to:
**https://**_ip-address-of-machine_**:9090**

Use your system user account and password to log in. See [the guide](guide/latest/guide.html) for more info.

## Recommended client browsers

{% capture icon %}{:.browser-0}![](/images/site/browser-0.svg){% endcapture %}

Cockpit is developed for and routinely tested with:

{:.browser-support}
- {{icon | replace: "0", "firefox"}} Mozilla Firefox
- {{icon | replace: "0", "chrome"}} Google Chrome
- {{icon | replace: "0", "edge"}} Microsoft Edge

<div id="browser-support">
  <div class="is-supported">
    <img src="/images/site/icon-ok.svg">
    Your current browser should work with Cockpit.
  </div>

  <div class="is-not-supported">
    <img src="/images/site/icon-warning.svg">
    Sorry! Your current browser appears to lack necessary features.
  </div>
</div>

### Minimum client browser versions

The following browsers (and up) _may_ also work with Cockpit:

{% comment %}
## Data for the browser table comes from `_data/browsers.yml`
## Browser versions come from `_data/browser_support.yml` (generated)
## Browser features are defined in `_scripts/update-browser-data.rb`
{% endcomment %}

{:.browser-support}
{% for browser in site.data.browsers %}{%
  assign slug = browser.name | downcase
%}
- {{
  browser.vendor
  }} {{
  browser.name
  }} {%
  assign ver_caniuse = site.data.browser_support["browsers"][slug]
  %}{%
  assign ver_caniuse_float = ver_caniuse | plus: 0
  %}{%
    if (browser.version > ver_caniuse_float)
  %}{{
    browser.version
  }}{% else %}{{
    ver_caniuse
  }}{%
    endif
  %}{% endfor %}

However, we __strongly__ encurage you to use the latest version of your browser for security reasons.

## Installation & Setup

{% comment %}
## Data for the distros table comes from `_data/distros.yml` ##
{% endcomment %}
{% assign check = '<span aria-label="#">✓</span>' %}

| |Supported|Tested|Included||
|-|-|-|-|-|-|{%
  for distro in site.data.distros
%}
|[![{{ distro.name }}](/images/site/os-{{ distro.first}}.svg)](#{{ distro.first }})|{%
  if distro.supported %}{{ check | replace: "#", "supported" }}{% endif
  %}|{%
  if distro.tested %}{{ check | replace: "#", "tested" }}{% endif
  %}|{%
  if distro.included %}{{ check | replace: "#", "included" }}{% endif
  %}|[View instructions](#{{ distro.first }})|{% endfor %}
{:.support-table}

### Fedora

Cockpit comes **installed by default in Fedora Server**.

To install Cockpit on other variants of Fedora use the following commands. For the latest versions [use COPR](https://copr.fedoraproject.org/coprs/g/cockpit/cockpit-preview/).

1. Install cockpit: 
```
sudo dnf install cockpit
```
2. Enable cockpit: 
```
sudo systemctl enable --now cockpit.socket
```
3. Open the firewall if necessary:
```
sudo firewall-cmd --add-service=cockpit
sudo firewall-cmd --add-service=cockpit --permanent
```


### Red Hat Enterprise Linux
{:#rhel}

Cockpit is included in Red Hat Enterprise Linux 7 and later.

1. On RHEL 7, enable the _Extras_ repository.
```
sudo subscription-manager repos --enable rhel-7-server-extras-rpms
```
RHEL 8 does not need any non-default repositories.

2. Install cockpit: 
```
sudo yum install cockpit
```
3. Enable cockpit: 
```
sudo systemctl enable --now cockpit.socket
```
4. On RHEL 7, or if you use non-default zones on RHEL 8, open the firewall:
```
sudo firewall-cmd --add-service=cockpit
sudo firewall-cmd --add-service=cockpit --permanent
```

### Fedora CoreOS
{:#coreos}

The standard Fedora CoreOS image does not contain Cockpit packages.

1. Install Cockpit packages as overlay RPMs:
   ```
   rpm-ostree install cockpit-system cockpit-ostree cockpit-podman
   ```

   Depending on your configuration, you may want to use [other extensions](https://apps.fedoraproject.org/packages/s/cockpit-) as well, such as `cockpit-kdump` or `cockpit-networkmanager`.

   If you have a custom-built OSTree, simply include the same packages in your build.

2. Reboot

3. Run the Cockpit web service with this privileged container (as root):
   ```
   podman container runlabel --name cockpit-ws RUN cockpit/ws
   ```

4. Make Cockpit start on boot:
   ```
   podman container runlabel INSTALL cockpit/ws
   systemctl enable cockpit.service
   ```

_Steps 3 and 4 are optional if the CoreOS machine will only be connected to from another host running Cockpit._

Afterward, use a web browser to log into port `9090` on your host IP address as usual.


### Project Atomic
{:#atomic}

**Connect to an Atomic Host from another instance of Cockpit** with the _Add Server_ dashboard UI.

Alternatively you can access Cockpit directly on the Atomic Host if SSH password authentication is enabled:

1. Run the Cockpit web service container: 
```
sudo atomic install cockpit/ws
sudo atomic run cockpit/ws
```


### CentOS

Cockpit is included in CentOS 7.x:

1. Install cockpit: 
```
sudo yum install cockpit
```
2. Enable cockpit: 
```
sudo systemctl enable --now cockpit.socket
```
3. Open the firewall if necessary:
```
sudo firewall-cmd --permanent --zone=public --add-service=cockpit
sudo firewall-cmd --reload
```


### Debian

Cockpit is included in Debian unstable and in backports for 9 (Stretch).

1. For Debian 9 you have to enable the [backports repository](https://backports.debian.org):
```
echo 'deb http://deb.debian.org/debian stretch-backports main' > \
    /etc/apt/sources.list.d/backports.list
apt-get update
```

2. Install the package:
```
sudo apt-get install cockpit
```


### Ubuntu

Cockpit is included in Ubuntu 17.04 and later, and available [as an official backport](https://help.ubuntu.com/community/UbuntuBackports) for 16.04 LTS and later. Backports are enabled by default, but if you customized apt sources you might need to [enable them manually](https://help.ubuntu.com/community/UbuntuBackports#Enabling_Backports).

1. Install the package:

   ```
   sudo apt-get install cockpit
   ```

### Clear Linux
{:#clearlinux}

Cockpit is in [Clear Linux](https://clearlinux.org/) OS and can be installed using `swupd`:

```
sudo swupd bundle-add sysadmin-remote
sudo systemctl enable --now cockpit.socket
```


### Arch Linux
{:#archlinux}

Cockpit can be found in the [Arch Community Repository](https://www.archlinux.org/packages/) as package [cockpit](https://www.archlinux.org/packages/community/x86_64/cockpit/).


