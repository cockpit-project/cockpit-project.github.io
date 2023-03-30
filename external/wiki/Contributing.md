---
title: Contributing
source: https://github.com/cockpit-project/cockpit/wiki/Contributing
---

### Prerequisite

Since you're considering contributing, you are likely already using Cockpit. If not, first install Cockpit on your local machine as described in:

https://cockpit-project.org/running.html

### Getting Started
 * Check out the [git repo](https://github.com/cockpit-project/cockpit), learn how to build it and run it. Change a string in the code somewhere and make sure you can see the change in the browser. See [HACKING.md]({{ site.baseurl }}/external/source/HACKING.html) for details.
 * Keep in mind the [project ideals]({{ site.baseurl }}/ideals.html)
 * If you are looking for someplace to start developing, issues are marked [with a good-first-issue label](https://github.com/cockpit-project/cockpit/issues?q=is%3Aopen+is%3Aissue+label%3Agood-first-issue) when they are a good introduction to Cockpit and of limited scope.
 * [Documentation]({{ site.baseurl }}/guide/latest/) (be aware: possible version differences)
 * [Set up integration tests](https://github.com/cockpit-project/cockpit/blob/master/test/README.md). Automated tests are an important part of Cockpit and every new feature should be accompanied by its tests. 

### Issue tracker

In-progress work and bugs are in the [issue tracker](https://github.com/cockpit-project/cockpit/issues). Use this for reporting bugs, filing feature requests, and proposing changes.

### Pull request

Modify the project in your own fork and issue a pull request once you want other developers to take a look at what you have done and discuss the proposed changes.

### Source code
Cockpit encompasses different languages and is developed by multiple developers. When contributing, please adhere to the [coding style guidelines](Cockpit-Coding-Guidelines).

Here is a detailed description of the [commit workflow](Workflow) (including [review criteria](/external/wiki/Workflow#review-criteria)) and as an example, [how @mvollmer merges pull requests](https://github.com/cockpit-project/cockpit/wiki/How-@mvollmer-merges-pull-requests).

### Contact us!

You can contact us on [Matrix or the mailing list](https://github.com/cockpit-project/cockpit/wiki/About) or by discussing issues in their respective GitHub thread. If an issue has a developer assigned, you may wish to check with that developer to see if they are already working on the issue.

### User interface & design
Cockpit's user interface is based on [PatternFly](https://patternfly.org/). Please be aware of this, especially of the design patterns (listed on the design tab of each component) when proposing changes to the user interface. Be sure to also read the general guidelines on the PatternFly website as well.

We work on designs inline in issues, pull requests, and on the discussions area. Additionally, there is the [Cockpit Design repository](https://github.com/cockpit-project/cockpit-design) as an archive for most design work.

Designs are made with open source software, including [Inkscape](https://inkscape.org/), [Penpot](https://penpot.app/), and [Excalidraw](https://excalidraw.com/). Please post the resulting mockups as PNGs in the issue tracker. Ideally, also share the source too (SVG, penpot file, embedded info in the Excalidraw PNG, etc.).

### Further reading
 * [Create plugins for the user interface]({{ site.baseurl }}/blog/creating-plugins-for-the-cockpit-user-interface.html)
 * [Starter Kit - the turn-key template for your own pages]({{ site.baseurl }}/blog/cockpit-starter-kit.html)
 * [Make your Cockpit page easily installable]({{ site.baseurl }}/blog/making-a-cockpit-application.html)
 * [Use DBUS from javascript in Cockpit]({{ site.baseurl }}/blog/using-dbus-from-javascript-in-cockpit.html)
 * [Protocol for web access to system APIs]({{ site.baseurl }}/blog/protocol-for-web-access-to-system-apis.html)