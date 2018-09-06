---
title: Running Cockpit
class: running-cockpit body-cockpit
---

{% capture newline %}
{% endcapture %}

If you already have Cockpit on your server, point your web browser to:
**https://**_ip-address-of-machine_**:9090**

Use your system user account and password to log in. See [the guide](guide/latest/guide.html) for more info.

### Minimum client browser versions

{% comment %}
## Data for the browser table comes from `_data/browsers.yml` ##
{% endcomment %}
{:.browser-support}
{% for browser in site.data.browsers %}
- {:.browser-{{ browser.first }}} ![](/images/site/browser-{{ browser.first }}.svg) {{
  browser.vendor
  }} {{
  browser.name
  }} {{
  browser.version
}}{% endfor %}

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

Cockpit is included in the Red Hat Enterprise Linux _Extras_ repository in versions 7.1 and later:

1. Enable the _Extras_ repository: 
```
sudo subscription-manager repos --enable rhel-7-server-extras-rpms
```
2. Install cockpit: 
```
sudo yum install cockpit
```
3. Enable cockpit: 
```
sudo systemctl enable --now cockpit.socket
```
4. Open the firewall if necessary:
```
sudo firewall-cmd --add-service=cockpit
sudo firewall-cmd --add-service=cockpit --permanent
```


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

Cockpit is included in Debian unstable and in backports for Debian 8 (Jessie) and 9 (Stretch).

1. For Debian 9 you have to enable the [backports repository](https://backports.debian.org):
```
echo 'deb http://deb.debian.org/debian stretch-backports main' > \
    /etc/apt/sources.list.d/backports.list
apt-get update
```

2. For Debian 8 you have to enable the [backports-sloppy repository](https://backports.debian.org):
```
echo 'deb http://deb.debian.org/debian jessie-backports-sloppy main' > \
    /etc/apt/sources.list.d/backports.list
apt-get update
```

3. Install the package:
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

Cockpit can be found in the [Arch User Repository](https://wiki.archlinux.org/index.php/Arch_User_Repository) as package [cockpit](https://aur.archlinux.org/packages/cockpit/).


