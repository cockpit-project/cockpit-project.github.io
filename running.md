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
- {:.col}[![](/images/site/os-clearlinux.svg)](#clearlinux)
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
sudo atomic install cockpit/ws
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


{% capture debian-official %}
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

{% capture clearlinux %}
Cockpit is in [Clear Linux](https://clearlinux.org/) OS and can be installed using `swupd`:

```
sudo swupd bundle-add sysadmin-remote
sudo systemctl enable --now cockpit.socket
```
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
  <div class="os-block">{{ debian-official | markdownify }}</div>
</section>
<section id="ubuntu" class="os-instructions os-block">{{ ubuntu | markdownify }}</section>

<div class="browser-header"><h2>Less tested and irregularly updated</h2></div>

{{ unstable1 | markdownify }}
<section id="arch" class="os-instructions os-block">{{ arch | markdownify }}</section>
<section id="clearlinux" class="os-instructions os-block">{{ clearlinux | markdownify }}</section>


<div class="browser-header"><h2>Minimum client browser versions</h2></div>

{:.browser-support.grid-3.grid_sm-2.grid_xs-1}
- {:.col}![](/images/site/browser-firefox.svg) Mozilla Firefox 11+
- {:.col}![](/images/site/browser-chrome.svg) Google Chrome 16+
- {:.col}![](/images/site/browser-edge.svg) Microsoft Edge
- {:.col}![](/images/site/browser-explorer.svg) Microsoft Internet Explorer 10+
- {:.col}![](/images/site/browser-ios.svg) Apple iOS Safari 6.1+
- {:.col}![](/images/site/browser-opera.svg) Opera 21.1+

<script>
$(function(){
  var windowOffset = window.pageYOffset;

  var switchActive = function(location) {
    if (history.pushState) {
      $('html').addClass('pushState');
      $('a.active,section.active').removeClass('active');

      if (location.startsWith('#')) {
        $('a[href="' + location + '"]').addClass('active');
        $(location).addClass('active');
      }
    }
  };

  $('.os-list').on('click', 'a', function(ev){
    var hash = '',
        location = '';

    if (history.pushState) {
      hash = $(this).attr('href');

      if ($(hash).hasClass('active')) {
        location = window.location.pathname;
      } else {
        location = hash;
      };

      history.pushState(null, null, location);
      switchActive(location);
      ev.preventDefault();
    } else {
      windowOffset = window.pageYOffset;
    }
  });

  $(window).on('popstate', function(ev){
    switchActive(window.location.hash);
  });

  $(window).on('hashchange', function(ev){
    window.scroll(0, windowOffset);
    ev.preventDefault();
  });
});
</script>
