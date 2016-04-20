Title: Protocol for Web access to System APIs
Date: 2014-12-16
Category: Cockpit, Linux
Tags: cockpit, linux
Slug: protocol-for-web-access-to-system-apis

*Note: This post has been updated for changes in Cockpit 0.48 and later.*

A Linux system today has a lot of local system configuration APIs. I'm not talking about library APIs here, but things like DBus services, command/scripts to be executed, or files placed in various locations. All of these constitute the API by which we configure a Linux system. In [Cockpit](http://cockpit-project.org) we access these APIs from a web browser (after authentication of course).

How do we access the system APIs? The answer is the `cockpit-bridge` tool. It proxies requests from the Cockpit user interface, running in a web browser, to the system. Typically the `cockpit-bridge` runs as the logged in user, in a user session. It has similar permissions and capabilities as if you had used `ssh` to log into the system.

Lets look at an example DBus API that we call from Cockpit. systemd has an API to set the system host name, called [SetStaticHostname](http://www.freedesktop.org/wiki/Software/systemd/hostnamed/). In Cockpit we can invoke that API using simple JSON like this:

    :::text
    {
      "call": [
        "/org/freedesktop/hostname1",
        "org.freedesktop.hostname1",
        "SetStaticHostname", [ "mypinkpony.local", true ]
      ]
    }

The protocol that the web browser uses is a [message based protocol](https://github.com/cockpit-project/cockpit/blob/master/doc/protocol.md), and runs over a [WebSocket](http://en.wikipedia.org/wiki/WebSocket). This is a "post-HTTP" protocol, and isn't limited by the request/response semantics inherent to HTTP. Our protocol has a lot of JSON, and has a number of interesting characteristics, which you'll see below. In general we've tried to keep this protocol readable and debuggable.

The `cockpit-bridge` tool speaks this protocol on its standard in and standard output. The `cockpit-ws` process hosts the WebSocket and passes the messages to `cockpit-bridge` for processing.

**Following along:** In order to follow along with the stuff below, you'll need at least Cockpit 0.48. The protocol is not yet frozen, and we merged some cleanup recently. You can install it on [Fedora 21 using a COPR](https://lists.fedorahosted.org/pipermail/cockpit-devel/2014-November/000196.html) or [build it from git](https://github.com/cockpit-project/cockpit/blob/master/HACKING.md).

Channels
--------

Cockpit can be doing lots of things at the same time and we don't want to have to open a new WebSocket each time. So we allow the protocol to be shared by multiple concurrent tasks. Each of these is assigned a *channel*. Channels have a string identifier. The data transferred in a channel is called the payload. To combine these into a message I simply concatenate the identifier, a new line, and the payload. Lets say I wanted to send the message `Oh marmalade!` over the channel called `scruffy` the message would look like this:

    :::text
    scruffy
    Oh marmalade!

How do we know what channel to send messages on? We send *control messages* on a *control channel* to open other channels, and indicate what they should do. The identifier for the control channel is an empty string. More on that below.

Framing
-------

In order to pass a message based protocol over a plain stream, such the standard in and standard out of `cockpit-bridge`, one needs some form of framing. This framing is not used when the messages are passed over a WebSocket, since WebSockets inherently have a message concept.

The framing the `cockpit-bridge` uses is simply the byte length of the message, encoded as a string, and followed by a new line. So Scruffy's 21 byte message above, when sent over a stream, would like this:

    :::text
    21
    scruffy
    Oh marmalade!

Alternatively, when debugging or testing `cockpit-bridge` you can run in an interactive mode, where we frame our messages by using boundaries. That way we don't have to count the byte length of all of our messages meticulously, if we're writing them by hand. We specify the boundary when invoking `cockpit-bridge` like so:

    :::text
    $ cockpit-bridge --interact=----

And then we can send a message by using the `----` boundary on a line by itself:

    :::text
    scruffy
    Oh marmalade!
    ----


Control channels
----------------

Before we can use a channel, we need to tell `cockpit-bridge` about the channel and what that channel is meant to do. We do this with a *control message* sent on the *control channel*. The *control channel* is a channel with an empty string as an identifier. Each control message is a JSON object, or dict. Each control message has a `"command"` field, which determines what kind of control message it is.

The `"open"` control message opens a new channel. The `"payload"` field indicates the type of the channel, so that `cockpit-bridge` knows what to do with the messages. The various [channel types are documented](https://github.com/cockpit-project/cockpit/blob/master/doc/protocol.md). Some channels connect talk to a DBus service, others spawn a process, etc.

When you send an `"open"` you also choose a new channel identifier and place it in the `"channel"` field. This channel identifier must not already be in use.

The `"echo"` channel type just sends the messages you send to the `cockpit-bridge` back to you. Here's the control message that is used to open an echo channel. Note the empty channel identifier on the first line:

<pre>

{
  "command": "open",
  "channel": "mychannel",
  "payload": "echo"
}
</pre>

Now we're ready to play ... Well almost.

The very first control message sent to and from `cockpit-bridge` shuld be an `"init"` message containing a version number. That version number is `1` for the forseeable future.

<pre>

{
  "command": "init",
  "version": 1
}
</pre>

Try it out
----------

So combining our knowledge so far, we can run the following:

    :::text
    $ cockpit-bridge --interact=----

In this debugging mode sent by `cockpit-bridge` will be bold in your terminal. Now paste the following in:

<pre>

{ "command": "open", "channel": "mychannel", "payload": "echo" }
----
mychannel
This is a test
----
</pre>

You'll notice that `cockpit-bridge` sends your message back. You can use this tecnique to experiment. Unfortunately
`cockpit-bridge` exits immediately when it's stdin closes, so you [can't yet use shell redirection from a file effectively](https://github.com/cockpit-project/cockpit/issues/1594).

Making a DBus method call
-------------------------

To make a DBus method call, we open a channel with the payload type `"dbus-json3"`. Then we send JSON messages as payloads inside that channel. An additional field in the `"open"` control message is required. The `"name"` field is the bus name of the DBus service we want to talk to:

<pre>

{
  "command": "open",
  "channel": "mydbus",
  "payload": "dbus-json3",
  "name": "org.freedesktop.systemd1"
}
</pre>

Once the channel is open we send a JSON object as a payload in the channel with a `"call"` field. It is set to an array with the DBus interface, DBus object path, method name, and an array of arguments.

<pre>
mydbus
{
  "call": [ "/org/freedesktop/hostname1", "org.freedesktop.hostname1",
            "SetStaticHostname", [ "mypinkpony.local", true ] ],
  "id": "cookie"
}
</pre>

If we want a reply from the service we specify an `"id"` field. The resulting `"reply"` will have a matching `"id"` and would look something like this:

<pre>
mydbus
{
  "reply": [ null ],
  "id": "cookie"
}
</pre>

If an error occured you would see a reply like this:

<pre>
mydbus
{
  "error": [
    "org.freedesktop.DBus.Error.UnknownMethod",
    [ "MyMethodName not available"]
  ],
  "id":"cookie"
}
</pre>

This is just the basics. You can do much more than this with DBus, including watching for signals, lookup up properties, tracking when they change, introspecting services, watching for new objects to show up, and so on.

Spawning a process
------------------

Spawning a process is easier than calling a DBus method. You open the channel with the payload type `"stream"` and you specify the process you would like to spawn in the `"open"` control message:

<pre>

{
  "command": "open",
  "channel": "myproc",
  "payload": "stream",
  "spawn": [ "ip", "addr", "show" ]
}
</pre>

The process will send its output in the payload of one or more messages of the `"myproc"` channel, and at the end you'll encounter the `"close"` control message. We haven't looked at until now. A `"close"` control message is sent when a channel closes. Either the `cockpit-bridge` or its caller can send this message to close a channel. Often the `"close"` message contains additional information, such as a problem encountered, or in this case the exit status of the process:

<pre>

{
  "command": "close",
  "channel": "myproc",
  "exit-status": 0
}
</pre>

Doing it over a WebSocket
-------------------------

Obviously in Cockpit we send all of these messages from the browser through a WebSocket hosted by `cockpit-ws`. `cockpit-ws` then passes them on to `cockpit-bridge`. You can communicate this way too, if you [configure Cockpit to accept different Websocket Origins](http://files.cockpit-project.org/guide/cockpit.conf.5.html).

And on it goes
--------------

There are payload types for reading files, replacing them, connecting to unix sockets, accessing system resource metrics, doing local HTTP requests, and more. Once the protocol is stable, solid documentation is in order.

I hope that this has given some insight into how Cockpit works under the hood. If you're interested in using this same protocol, I'd love to get feedback ... especially while the basics of the protocol are not yet frozen.
