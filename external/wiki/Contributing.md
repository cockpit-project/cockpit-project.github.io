---
title: Contributing
source: https://github.com/cockpit-project/cockpit/wiki/Contributing
---

### General
Cockpit is a meritocracy: prove you are reliable and you'll earn commit privileges.

Work currently in progress and bugs are in the [issue tracker](https://github.com/cockpit-project/cockpit/issues). There is no separate bug tracker, so use this liberally for bugs, feature requests and proposed changes. Modify the project in your own fork and issue a pull request once you want other developers to take a look at what you have done and discuss the proposed changes.

In order to avoid duplicate work, it is advisable to show others what you are working on. You can do this on [irc or the mailing list](https://github.com/cockpit-project/cockpit/wiki/About) or by discussing issues in their respective github thread. If an issue has a developer assigned, you may wish to check with that developer to see if they are already working on the issue.

### Getting Started
 * Guide: [Set up a system and start hacking]({{ site.baseurl }}/external/source/HACKING.html)
 * Guide: [Set up integration tests](https://github.com/cockpit-project/cockpit/blob/master/test/README.md). Automated tests are an important part of Cockpit and every new feature should be accompanied by its tests.
 * Keep in mind the [project ideals]({{ site.baseurl }}/ideals.html)
 * If you are looking for someplace to start developing, issues are marked [with a good-first-issue label](https://github.com/cockpit-project/cockpit/issues?q=is%3Aopen+is%3Aissue+label%3Agood-first-issue) when they are a good introduction to Cockpit and of limited scope.
 * For broader inspiration and ideas you may want to look at the [Ideas page](https://github.com/cockpit-project/cockpit/wiki/Ideas).
 * [Documentation]({{ site.baseurl }}/guide/latest/) (be aware: possible version differences)

### Source Code
Cockpit encompasses different languages and is developed by multiple developers. When contributing, please adhere to the [coding style guidelines](Cockpit-Coding-Guidelines).

Here is a detailed description of the [commit workflow](Workflow) (including [review criteria](/external/wiki/Workflow#review-criteria)) and as an example, [how @mvollmer merges pull requests](https://github.com/cockpit-project/cockpit/wiki/How-@mvollmer-merges-pull-requests).

### User Interface / Design
Cockpit's user interface is based on [PatternFly](https://www.patternfly.org/). Please be aware of this, especially of the [design patterns](https://www.patternfly.org/pattern-library/) when proposing changes to the user interface.

An overview of things currently in design can be found [here](https://github.com/cockpit-project/cockpit/wiki/Design).

### Further reading
 * [Create plugins for the user interface]({{ site.baseurl }}/blog/creating-plugins-for-the-cockpit-user-interface.html)
 * [Starter Kit - the turn-key template for your own pages]({{ site.baseurl }}/blog/cockpit-starter-kit.html)
 * [Make your Cockpit page easily installable]({{ site.baseurl }}/blog/making-a-cockpit-application.html)
 * [Use DBUS from javascript in Cockpit]({{ site.baseurl }}/blog/using-dbus-from-javascript-in-cockpit.html)
 * [Protocol for web access to system APIs]({{ site.baseurl }}/blog/protocol-for-web-access-to-system-apis.html)