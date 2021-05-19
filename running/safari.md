---
title: Use Cockpit with Safari on an iPhone or iPad
---

Safari's default WebSocket framework on [iOS, iPadOS,](#ios-and-ipados) and [ARM-based Macs](#macos-on-arm-m1) does not support the WebSocket Secure sessions which Cockpit needs to function when using a self-signed or otherwise invalid certificate, even when they are manually marked as trusted. [Installing a valid certificate]({{ site.baseurl }}/guide/latest/https.html) should resolve this issue.

As an alternative workaround, you can enable Apple's future/experimental WebSocket framework which does work as expected.

## iOS and iPadOS

1. Open the Settings app
   
   ![iPhone settings]({{ site.baseurl }}/images/safari/1.png)

2. Scroll down and tap on "**Safari**"
   
   ![iPhone settings, scrolled mid-way down]({{ site.baseurl }}/images/safari/2.png)
   ![Safari settings highlighted]({{ site.baseurl }}/images/safari/2-2.png)

3. Scroll down to the bottom and tap on "**Advanced**"
   
   ![Safari settings]({{ site.baseurl }}/images/safari/3.png)
   ![Advanced highlighted]({{ site.baseurl }}/images/safari/3-2.png)

4. Tap on "**Experimental Features**" at the bottom
   
   !["Experimental Features" highlighted]({{ site.baseurl }}/images/safari/4.png)

5. Scroll down until you see "**NSURLSession WebSocket**"
   
   ![Experimental Features]({{ site.baseurl }}/images/safari/5.png)
   !["NSURLSession Websocket" highlighted]({{ site.baseurl }}/images/safari/5-2.png)

6. Enable "**NSURLSession WebSocket**"

   !["NSURLSession Websocket" off by default]({{ site.baseurl }}/images/safari/6.png)
   !["NSURLSession Websocket" turned on manually]({{ site.baseurl }}/images/safari/6-2.png)

7. You're done! Navigate to Cockpit with Safari and sign in normally.

   ![Safari icon]({{ site.baseurl }}/images/site/browser-safari.svg){:.safari-icon}


## macOS on ARM (M1)

1. Open Safari's settings, select "**Advanced**", and enable "**Show Develop menu in menu bar**"

   ![Safari's settings]({{ site.baseurl }}/images/safari/macos-safari-advanced.png){:.full-width}

2. Go to Safari's "**Develop**" menu, select "**Experimental Features**", and enable "**NSURLSession WebSocket**"

   ![Safari's settings]({{ site.baseurl }}/images/safari/macos-safari-experimental.png){:.full-width}

3. You're done! Navigate to Cockpit with Safari and sign in normally.

   ![Safari icon]({{ site.baseurl }}/images/site/browser-safari.svg){:.safari-icon}
