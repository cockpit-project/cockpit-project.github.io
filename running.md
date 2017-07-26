---
title: Running Cockpit
class: running-cockpit body-cockpit
---

{% capture intro %}
If you already have Cockpit on your server, point your web browser to:
**https://**_ip-address-of-machine_**:9090**

Use your system user account and password to log in. See [the guide](guide/latest/guide.html) for more info.
{% endcapture %}


{% capture stable1 %}
{:.os-list.grid-4.grid_xs-2}
- {:.col}[![](/images/site/os-fedora.svg)](#fedora)
- {:.col}[![](/images/site/os-rhel.svg)](#rhel)
- {:.col}[![](/images/site/os-atomic.svg)](#atomic)
- {:.col}[![](/images/site/os-centos.svg)](#centos)
{% endcapture %}
{% capture stable2 %}
{:.os-list.grid-4.grid_xs-2}
- {:.col}[![](/images/site/os-debian.svg)](#debian)
- {:.col}[![](/images/site/os-ubuntu.svg)](#ubuntu)
{% endcapture %}
{% capture unstable1 %}
{:.os-list.grid-4.grid_xs-2}
- {:.col}[![](/images/site/os-archlinux.svg)](#arch)
{% endcapture %}


{% capture fedora %}
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
{% endcapture %}


{% capture rhel %}
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
{% endcapture %}


{% capture atomic %}
**Connect to an Atomic Host from another instance of Cockpit** with the _Add Server_ dashboard UI.

Alternatively you can access Cockpit directly on the Atomic Host if SSH password authentication is enabled:

1. Run the Cockpit web service container: 
```
sudo atomic run cockpit/ws
```
{% endcapture %}


{% capture centos %}
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
{% endcapture %}


{% capture debian-unstable %}
Cockpit is included in Debian unstable.

1. Install the package:
```
sudo apt-get install cockpit
```
{% endcapture %}


{% capture debian-jessie %}
For Debian Jessie (8.x) you can add a repository which always has the latest Cockpit release:

1. Add the following line to . 
```
deb http://repo-cockpitproject.rhcloud.com/debian/ jessie main
```
2. Import Cockpit's signing key to the apt sources keyring: 
```
sudo apt-key adv --keyserver sks-keyservers.net --recv-keys 0D2A45C3F1BAA57C
```
3. Verify fingerprint: 
```
sudo apt-key finger F1BAA57C
```
Compare the output: <tt>Key fingerprint = FD9A 5764 17F7 B1D8 63C4 7A5A 0D2A 45C3 F1BA A57C</tt>
4. Update package information with that source: 
```
sudo apt-get update
```
5. Install cockpit: 
```
sudo apt-get install cockpit
```
{% endcapture %}


{% capture ubuntu %}
Cockpit is included in Ubuntu 17.04 and later, and available [as an official backport](https://help.ubuntu.com/community/UbuntuBackports) for 16.04 LTS and later. Backports are enabled by default, but if you customized apt sources you might need to [enable them manually](https://help.ubuntu.com/community/UbuntuBackports#Enabling_Backports).

1. Install the package:

```
sudo apt-get install cockpit
```
{% endcapture %}


{% capture arch %}
Cockpit can be found in the [Arch User Repository](https://wiki.archlinux.org/index.php/Arch_User_Repository) as package [cockpit](https://aur.archlinux.org/packages/cockpit/). 
{% endcapture %}


{{ intro | markdownify }}

<div class="browser-header"><h2>Stable, tested, and included in</h2></div>

{{ stable1 | markdownify }}
<section id="fedora" class="os-instructions os-block stable">{{ fedora | markdownify }}</section>
<section id="rhel" class="os-instructions os-block stable">{{ rhel | markdownify }}</section>
<section id="atomic" class="os-instructions os-block stable">{{ atomic | markdownify }}</section>
<section id="centos" class="os-instructions os-block stable">{{ centos | markdownify }}</section>

{{ stable2 | markdownify }}
<section id="debian" class="os-instructions">
  <div class="os-block">{{ debian-unstable | markdownify }}</div>
  <div class="os-block">{{ debian-jessie | markdownify }}</div>
</section>
<section id="ubuntu" class="os-instructions os-block">{{ ubuntu | markdownify }}</section>

<div class="browser-header"><h2>Less tested and irregularly updated</h2></div>

{{ unstable1 | markdownify }}
<section id="arch" class="os-instructions">{{ arch | markdownify }}</section>


<div class="browser-header"><h2>Minimum client browser versions</h2></div>

{:.browser-support.grid-3.grid_sm-2.grid_xs-1}
- {:.col}![](/images/site/browser-firefox.svg) Mozilla Firefox 11+
- {:.col}![](/images/site/browser-explorer.svg) Internet Explorer 10+
- {:.col}![](/images/site/browser-ios.svg) Apple iOS Safari 6.1+
- {:.col}![](/images/site/browser-chrome.svg) Google Chrome 16+
- {:.col}![](/images/site/browser-opera.svg) Opera 21.1+
- {:.col}![](/images/site/browser-android.svg) Android Browser 4.4+

<script>
$(function(){
  var windowOffset = window.pageYOffset;

  $('.os-list').on('click', 'a', function(ev){
    windowOffset = window.pageYOffset;
  });
  $(window).on('hashchange', function(ev){
    window.scroll(0, windowOffset);
    ev.preventDefault();
  });
});
</script>
