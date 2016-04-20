Title: DBus is powerful IPC
Date: 2014-11-04
Category: Linux
Tags: dbus, linux
Slug: d-bus-is-powerful-ipc

D-Bus is powerful IPC Cockpit is heavily built around DBus. We send DBus over our
[WebSocket transport](https://github.com/cockpit-project/cockpit/blob/master/doc/protocol.md),
and marshal them in JSON.

DBus is powerful, with lots of capabilities. Not all projects use all of these, but so many of
these capabilities are what allow Cockpit to implement its UI.

 * Method Call Transactions
 * Object Oriented
 * Efficient Signalling
 * Properties and notifications
 * Race free watching of entire Object trees for changes
 * Broadcasting
 * Discovery
 * Introspection
 * Policy
 * Activation
 * Synchronization
 * Type-safe Marshalling
 * Caller Credentials
 * Security
 * Debug Monitoring
 * File Descriptor Passing
 * Language agnostic
 * Network transparency
 * No trust required
 * High-level error concept
 * Adhoc type definitions

Lennart goes into these further [in a kdbus talk](http://youtu.be/HPbQzm_iz_k?t=2m6s), as well as some of the weaknesses of DBus.
