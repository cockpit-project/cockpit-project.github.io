---
title: Proxying Cockpit over Apache with LetsEncrypt
source: https://github.com/cockpit-project/cockpit/wiki/Proxying-Cockpit-over-Apache-with-LetsEncrypt
---

Cockpit works on a **web socket combined with http/https** interface, Web Socket is used to deliver active content back and forth between client and server. But when a proxy sits in between, it needs to be configured likely.

We will need to create a virtual host, give the virtual host a domain name, install TLS/SSL certificate and set up a reverse proxy. (instructions adapted from [here](https://www.linuxbabe.com/cloud-storage/integrate-collabora-online-server-nextcloud-ubuntu-16-04) and [here](https://stackoverflow.com/questions/27526281/websockets-and-apache-proxy-how-to-configure-mod-proxy-wstunnel))

## Set up Apache X-Frame-Options

Edit Apache X-Frame-Options policy by running:

`sudo nano /etc/apache2/conf-available/ssl-params.conf`

Find a line that says `Header always set X-Frame-Options DENY`
and change it to `Header always set X-Frame-Options SAMEORIGIN`

## Set up Apache Virtual Host

Install Apache web server with the following command:

`sudo apt install apache2`

Run the following command to create an Apache virtual host file. Replace the domain name with your actual domain name for Cockpit. Don’t forget to create an A record for this domain name.

`sudo nano /etc/apache2/sites-available/cockpit.your-domain.com.conf`

Put the following text into the file.

```apacheconf
<VirtualHost *:80>
 ServerName cockpit.your-domain.com
</VirtualHost>
```

Save and close the file. Enable this virtual host with the following command:

`sudo a2ensite cockpit.your-domain.com.conf`

Then restart Apache.

`sudo systemctl restart apache2`

## TLS/SSL certificate with Let's Encrypt

HTTPS helps us prevent man-in-the-middle attack and password sniffing. We can obtain a free TLS/SSL certificate from Let’s Encrypt CA. First Let’s install the certbot client. The client is still named letsnecrypt in Ubuntu repository. The following command will install the client and apache plugin.

`sudo apt install letsencrypt python-letsencrypt-apache`

Now issue the following command to obtain a free TLS/SSL certificate. Replace the text with your actual data.

`sudo letsencrypt --apache --agree-tos --email YOUR-EMAIL-ADDRESS -d COCKPIT.YOUR-DOMAIN.COM`

You will be asked to choose easy or secure. It’s recommended to choose secure so that all http requests will be redirected to https.

Once you hit the OK button, a free TLS/SSL certificate is obtained and installed on the Apache virtual host.

Now copy the certificates information into the cockpit certificate folder using the following commands

`cat /etc/letsencrypt/live/cockpit.your-domain.com/fullchain.pem >> /etc/cockpit/ws-certs.d/1-my-cert.cert`

`cat /etc/letsencrypt/live/cockpit.your-domain.com/privkey.pem >> /etc/cockpit/ws-certs.d/1-my-cert.cert`

You will need to do this every time the certificate gets renewed (every 3 months).

## Set up Apache Reverse Proxy in a Subdomain

To be able to proxy traffic using Apache, run the following commands to enable each of these Apache modules.

`sudo a2enmod proxy proxy_wstunnel proxy_http ssl rewrite`

Then run the following command to edit the new virtual host file created by Let’s Encrypt (certbot) client.

`sudo nano /etc/apache2/sites-enabled/cockpit.your-domain.com-le-ssl.conf`

Change this file so it looks like the following.

```apacheconf
<IfModule mod_ssl.c>
<VirtualHost *:443>
  ServerName cockpit.your-domain.com
  SSLCertificateFile /etc/letsencrypt/live/cockpit.your-domain.com/fullchain.pem
  SSLCertificateKeyFile /etc/letsencrypt/live/cockpit.your-domain.com/privkey.pem
  Include /etc/letsencrypt/options-ssl-apache.conf
  ProxyPreserveHost On
  ProxyRequests Off
  # allow for upgrading to websockets
  RewriteEngine On
  RewriteCond %{HTTP:Upgrade} =websocket [NC]
  RewriteRule /(.*)           ws://127.0.0.1:9090/$1 [P,L]
  RewriteCond %{HTTP:Upgrade} !=websocket [NC]
  RewriteRule /(.*)           http://127.0.0.1:9090/$1 [P,L]
  # Proxy to your local cockpit instance
  ProxyPass / http://127.0.0.1:9090/
  ProxyPassReverse / http://127.0.0.1:9090/
</VirtualHost>
</IfModule>
```

Save and close the file. Then restart Apache web server.

`sudo systemctl restart apache2`

Make sure you changed `/etc/cockpit/cockpit.conf` to include the following:

```ini
[WebService]
Origins = https://cockpit.your-domain.com http://127.0.0.1:9090
ProtocolHeader = X-Forwarded-Proto
AllowUnencrypted = true
```

Restart cockpit

`sudo systemctl restart cockpit.service`

You can now login to cockpit at the specified subdomain.

## Set up Apache Reverse Proxy in a Subdirectory

The following steps allow proxying traffic from a subdirectory of an existing Apache virtual host.  
Important: `/cockpit/` and `/cockpit+/` are reserved. Do not use any reserved names [listed here]({{ site.baseurl }}/guide/latest/cockpit.conf.5). This example will use /UrlRoot/.  

Run the following command to enable all the required Apache modules.  

`sudo a2enmod proxy proxy_wstunnel proxy_http ssl rewrite`  

Then run the following command to edit the new virtual host file created by Let’s Encrypt (certbot) client.  

`sudo nano /etc/apache2/sites-enabled/cockpit.your-domain.com-le-ssl.conf`  

If you are not using certbot, an example file normally exists at the following:  

`sudo nano /etc/apache2/sites-available/default-ssl.conf`  

Otherwise, consult your man pages/packager for the correct filepath, or follow the prior certbot tutorial, or create a site manually.

Assuming you followed the prior LetsEncrypt strategy, are using the common default file, or have an existing virtual host such that the file starts with `<IfModule mod_ssl.c> <VirtualHost *:443>` and has the appropriate directives for TLS/SSL, append the following to your virtual host, replacing `UrlRoot` with your desired subdirectory name.  

```apacheconf
                SSLProxyEngine          On
                # required module
                RewriteEngine           On
                # required module
                ProxyPreserveHost       On
                # required
                ProxyRequests           Off
                # RECOMMENDED, disables forwarding, see https://httpd.apache.org/docs/2.4/mod/mod_proxy.html#proxyrequests
                ProxyErrorOverride      Off
                # if possible, present cockpit's error pages instead of apache's
                SSLProxyVerify optional_no_ca
                # cockpit has a self-signed cert by default, therefore no CA
                SSLProxyCheckPeerCN Off
                # SSL error without this
                SSLProxyCheckPeerName Off
                # SSL error without this
                SSLProxyCheckPeerExpire Off
                # recommended since potential SSL error without this
                RequestHeader set "X-Forwarded-Proto" "https"
                # required by cockpit.conf
                # following is adapted from https://httpd.apache.org/docs/2.4/mod/mod_proxy_wstunnel.html
                RewriteCond %{HTTP:Upgrade} websocket [NC]
                RewriteCond %{HTTP:Connection} upgrade [NC]
                RewriteRule "^/UrlRoot/(.*)" "wss://127.0.0.1:9090/UrlRoot/$1" [P,L]
                # when websocket in upgrade AND
                # within UrlRoot, rewrite proxy with wss://
                RewriteCond ${HTTP:Upgrade} !=websocket [NC]
                RewriteRule "^/UrlRoot/(.*)" "https://127.0.0.1:9090/UrlRoot/$1" [P,L]
                # when no websocket upgrade AND
                # within UrlRoot, rewrite proxy with https://
        </VirtualHost>
</IfModule>
```

Save and close the file. Then restart Apache web server.

`sudo systemctl restart apache2`

Lastly, change the `/etc/cockpit/cockpit.conf` to include the following:

```ini
[WebService]
Origins = https://your-domain.com http://127.0.0.1:9090
ProtocolHeader = X-Forwarded-Proto
UrlRoot = /UrlRoot/
```
Replace `/UrlRoot/` with your choice of subdirectory, though keep the enclosing `/`.  
This method does not require you to disable encryption (`AllowUnencrypted = true`) since the self-signed certificate is allowed.  

Restart cockpit

`sudo systemctl restart cockpit.service`

You can now login to cockpit at `https://your-domain.com/UrlRoot/`.