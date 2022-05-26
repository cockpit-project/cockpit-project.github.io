---
title: Proxying Cockpit over NGINX
source: https://github.com/cockpit-project/cockpit/wiki/Proxying-Cockpit-over-NGINX
---

## Preamble

Cockpit uses web sockets to deliver active content back and forth between the client and the server in real time. One of the challenges of placing Cockpit behind a proxy server such as [nginx](https://nginx.org) is that additional configuration is required to ensure that web socket connections are proxied as well.

For the purposes of this example we will assume:
* Cockpit is listening on port 9090
* Nginx is listening on on port 80 (http) and port 443 (https)
* You have a subdomain of cockpit.domain.tld pointed to your nginx instance
* You can access your nginx instance by connecting to http://cockpit.domain.tld, even if you just get the default page

## Make Cockpit proxy aware

For security Cockpit will be unable to serve requests from origins it is unfamiliar with due to [cross domain limitations](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing). In our example, Cockpit will see the origin as cockpit.domain.tld however it will believe it's running on 127.0.0.1 and therefore be unable to serve the request.

To make Cockpit proxy aware, you will need to modify the [Cockpit config file]({{ site.baseurl }}/guide/latest/cockpit.conf.5.html) located at /etc/cockpit/cockpit.conf. This file may not exist and if it doesn't you should create it.

```
[WebService]
Origins = https://cockpit.domain.tld wss://cockpit.domain.tld
ProtocolHeader = X-Forwarded-Proto
```

These changes will let Cockpit know that connections will come through for https (secure http) and wss (secure websockets) on the subdomain cockpit.domain.tld, and that it should look for the `X-Forwarded-Proto` header to determine if the connection is secure or not, this is important as Cockpit will [redirect any non-local connection from http to https automatically]({{ site.baseurl }}/guide/149/https.html) and sees cockpit.domain.tld is non-local.

Once these changes are made you will need to restart cockpit.

## Virtual host file

To create a proxy you will first need to create a [virtual server block](https://www.nginx.com/resources/wiki/start/topics/examples/server_blocks/) so nginx is aware of what to do when it receives a request for your subdomain. If this block doesn't exist, nginx will just serve the default page.

This server block will allow you to access Cockpit via http://cockpit.domain.tld:

```
server {
    listen         80;
    listen         443 ssl;
    server_name    cockpit.domain.tld;

    location / {
        # Required to proxy the connection to Cockpit
        proxy_pass https://127.0.0.1:9090;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;

        # Required for web sockets to function
        proxy_http_version 1.1;
        proxy_buffering off;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";

        # Pass ETag header from Cockpit to clients.
        # See: https://github.com/cockpit-project/cockpit/issues/5239
        gzip off;
    }
}
```

> **_NOTE:_** Since Cockpit automatically handles the http to https redirect you can have one server block which covers both http and https connections.

Once you have added the new virtual host block you will need to restart nginx.

## Security

It is recommended you generate a valid, signed certificate for your server, you can do this for free by using [Certbot](https://certbot.eff.org) and [Let's Encrypt](https://letsencrypt.org).

> **_NOTE:_** Once you have a certificate you will need to update the certificate and keys paths in the virtual server block.

Alternatively if you don't require a valid certificate you can [generate your own certificate](https://www.digitalocean.com/community/tutorials/openssl-essentials-working-with-ssl-certificates-private-keys-and-csrs#generating-ssl-certificates). This approach is only recommended for testing as you will get browser security warnings notifying you the connection is not secure.

If all else fails you can use cockpits self signed certificates which are stored in `/etc/cockpit/ws-certs.d/`. To do this you will need to split the `0-self-signed.cert` into two files, one containing the key and one containing the certificate.

### 502 Bad Gateway & SELinux 
If SELinux is enabled, change boolean setting (solves 502 gateway error):

`setsebool -P httpd_can_network_connect on`


## Other configurations

There are other common ways you can configure your proxy.

### Serving via a subdirectory rather than subdomain

You may want to serve cockpit from a subdirectory rather than a subdomain. 

For this example we will assume:
* Cockpit is listening on port 9090
* Nginx is listening on on port 80 (http) and port 443 (https)
* You have a domain of domain.tld pointed to your nginx instance
* You can access your nginx instance by connecting to http://domain.tld, even if you just get the default page
* You want to access Cockpit via http://domain.tld/secret/
* You already have a virtual server block for this domain with existing content in it

```
server {
    ...

    location /secret/ {
        # Required to proxy the connection to Cockpit
        proxy_pass https://127.0.0.1:9090/secret/;

        ...
    }
}
```

The /secret/ location block here contains the exact same information as the location block in the [original example](#virtual-host-file), the /secret/ location block should be placed at the end of the virtual server block.

You will also need to let Cockpit know that you are serving the requests from a subdirectory by modifying the cockpit.conf file:

```
[WebService]
Origins = https://domain.tld wss://domain.tld
ProtocolHeader = X-Forwarded-Proto
UrlRoot=/secret
```

### Using an external proxy

If you're not running nginx locally alongside Cockpit you will need to adjust the configuration so it works across a network IP address. This may be an instance where nginx is on another server or running in a docker container or otherwise doesn't have access to 127.0.0.1. 

For this example we will assume:
* Cockpit is listening on port 9090 on system 192.168.10.15
* Nginx is listening on on port 80 (http) and port 443 (https) on system 192.168.10.29
* You have a domain of domain.tld pointed to your nginx instance
* You can access your nginx instance by connecting to http://domain.tld, even if you just get the default page

```
server {
    ...

    location / {
        # Required to proxy the connection to Cockpit
        proxy_pass https://192.168.10.15:9090;

        ...
    }
}
```

For nginx to proxy the connection successfully you'll need to ensure the proxy pass is also using https. By default nginx doesn't check the validity of the SSL certificates for proxied connections, this means you can proxy directly to cockpit using https without needing to tell nginx it's using a self signed certificate. 

### Insecure connections

If you really want to disable the secure connection requirement in Cockpit and instead proxy to http this is possible by disabling the secure connection requirement in the cockpit.conf file:

```
[WebService]
AllowUnencrypted=true
```

Disabling the secure connection requirement doesn't provide any real advantage since nginx doesn't check the certificate for validity. Since you are transmitting sensitive information to Cockpit it is recommended to leave this setting intact unless you are troubleshooting or have no other option but to serve requests over http. 