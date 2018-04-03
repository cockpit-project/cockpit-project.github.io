---
title: Using Cockpit test VMs with your own test framework
author: pitti
date: 2018-03-28
category: tutorial
tags: cockpit starter-kit tests puppeteer
slug: cockpit-custom-test-framework
comments: true
---

The [Cockpit Starter Kit](https://github.com/cockpit-project/starter-kit/) provides the scaffolding for your own Cockpit
extensions: a simple page (in React), build system (webpack, babel, eslint, etc.), and an integration test using
Cockpit's own Python test API on top of the
[Chromium DevTools Protocol](https://chromedevtools.github.io/devtools-protocol/).  See the recent
[introduction](http://cockpit-project.org/blog/cockpit-starter-kit.html) for details.

But in some cases you want to use a different testing framework; perhaps you have an already existing project and tests.
Then it is convenient and recommended to still using Cockpit's test VM images: they provide an easy way to test your
project on various Fedora/Red Hat/Debian/Ubuntu flavors; and they take quite a lot of effort to maintain! Quite
fortunately, using the test images is not tightly bound to using Cockpit's test API, and not even to tests being written
Python. They can be built and used entirely through command line tools from Cockpit's [bots/
directory](https://github.com/cockpit-project/cockpit/tree/master/bots/), so you can use those with any programming
language and test framework.

## Building and interacting with a test VM

To illustrate this, let's check out the Starter Kit and build a CentOS 7 based VM with cockpit and the starter kit
installed:

```sh
$ git clone https://github.com/cockpit-project/starter-kit.git
$ cd starter-kit
$ make vm
```

Ordinarily, the generated `test/images/centos-7.qcow2` would be used by
[test/check-starter-kit](https://github.com/cockpit-project/starter-kit/blob/master/test/check-starter-kit). But let's
tinker around with the VM image manually. Cockpit's
[testvm.py](https://github.com/cockpit-project/cockpit/blob/master/bots/machine/testvm.py) module for using these VMs
can be used as a command line program:

```sh
$ bots/machine/testvm.py centos-7
ssh -o ControlPath=/tmp/ssh-%h-%p-%r-23253 -p 2201 root@127.0.0.2
http://127.0.0.2:9091
RUNNING
```

It takes a few seconds to boot the VM, then it prints three lines:

 * The SSH command to run something inside the VM
 * The URL for the forwarded Cockpit port 9090
 * A constant `RUNNING` flag that test suites can poll for to know when to proceed.

You can now open that URL in your browser to log into Cockpit (user "admin", password "foobar") and see the installed
Starter Kit page, or run a command in the VM through the given SSH command:

```sh
$ ssh -o ControlPath=/tmp/ssh-%h-%p-%r-23253 -p 2202 root@127.0.0.2 head -n2 /etc/os-release
NAME="CentOS Linux"
VERSION="7 (Core)"
```

The VM gets shut down once the `testvm.py` process gets a `SIGTERM` (useful for test suites) or `SIGINT` (useful for
just pressing Control-C when interactively starting this in a shell).

## Using testvm.py in your test suite

Let's use the above in a [Puppeteer](https://github.com/GoogleChrome/puppeteer) test.
[check-puppeteer.js](../files/starter-kit/check-puppeteer.js) is a straight port of
[check-starter-kit](https://github.com/cockpit-project/starter-kit/blob/master/test/check-starter-kit); of course it is
a little longer than the original as we don't have the convenience functions of
[testlib.py](https://github.com/cockpit-project/cockpit/blob/master/test/common/testlib.py) to automatically start and
tear down VMs or do actions like "log into Cockpit", but it is still fairly comprehensible. Download it into the tests/ directory of
your starter-kit checkout, then install puppeteer:

```sh
$ PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1 npm install puppeteer@0.12.0
```

This will avoid downloading an entire private copy of chromium-browser and use the system-installed one. (Of course you
can also just call `npm install puppeteer` if you don't care about the overhead). Now run the tests:

```sh
$ DEBUG="puppeteer:page,puppeteer:frame" PYTHONPATH=bots/machine test/check-puppeteer.js
```

This will run them in a verbose mode where you can follow the browser queries and events.

Let's walk through some of the code:

```js
function startVm() {
    return new Promise((resolve, reject) => {
        let proc = child_process.spawn("bots/machine/testvm.py", [testOS], { stdio: ["pipe", "pipe", "inherit"] });
        let buf = "";
        proc.stdout.on("data", data => {
            buf += data.toString();
            if (buf.indexOf("\nRUNNING\n") > 0) {
                let lines = buf.split("\n");
                resolve({ proc: proc, ssh: lines[0], cockpit: lines[1] });
            }
        });
        proc.on("error", err => { throw `Failed to start vm-run: ${err}` });
    });
}
```

This uses `testvm.py` as above to launch the VM. In a "real" test suite this would go into the per-test setup code.
`check-puppeteer.js` does not use any test case organization framework (like [jest](https://www.npmjs.com/package/jest)
or [QUnit](https://qunitjs.com/)), but if you have more than two or three test cases it's recommended to use one.


```js
async function testStarterKit() {
    const vm = await startVm();

    const browser = await puppeteer.launch(
        // disable sandboxing to also work in docker
        { headless: true, executablePath: 'chromium-browser', args: [ "--no-sandbox" ] });
```

This is the actual test case. Here we start Puppeteer, and here you can change various
[options](https://github.com/GoogleChrome/puppeteer/blob/master/docs/api.md#puppeteerlaunchoptions)
to influence the test. For example, set `headless: false` to get a visible Chomium window and follow live what the test
does (or where it hangs).

```js
    const page = await browser.newPage();

    try {
        // log in
        await page.goto(vm.cockpit);
        await page.type('#login-user-input', 'admin');
        await page.type('#login-password-input', 'foobar');
        await page.click('#login-button');
```

This is the equivalent of Cockpit test's `Browser.login_and_go()`. In a real test you would probably factorize this into
a helper function.

```js
        await page.waitFor('#host-nav a[title="Starter Kit"]');
        await page.goto(vm.cockpit + "/starter-kit");
        let frame = getFrame(page, 'cockpit1:localhost/starter-kit');

        // verify expected heading
        await frame.waitFor('.container-fluid h2');
        await frame.waitForFunction(() => document.querySelector(".container-fluid h2").innerHTML == "Starter Kit");

        // verify expected host name
        let hostname = vmExecute(vm, "cat /etc/hostname").trim();
        await frame.waitFor('.container-fluid span');
        await frame.waitForFunction(
            h => document.querySelector(".container-fluid span").innerHTML == ("Running on " + h),
            {}, hostname);
    }
```

This is a direct translation of what check-starter-kit does: Assert the expected heading and host name message.

```js
    catch (err) {
        const attachments = process.env["TEST_ATTACHMENTS"];
        if (attachments) {
            console.error("Test failed, taking screenshot...");
            await page.screenshot({ path: attachments + "/testStarterKit-FAIL.png"});
        }
        throw err;
    }
```

This part is optional, but very useful for debugging failed tests. If any assertion fails, this creates a PNG screenshot
from the current browser page state. Run the test with `TEST_ATTACHMENTS=/some/existing/directory` to enable this. The
Cockpit CI machinery will export any files in this directory to the http browsable test results directory.

```js
     finally {
        await browser.close();
        vm.proc.kill();
    }
};
```

This is a poor man's "test teardown" which closes the browser and VM.

## Feedback

starter-kit and external Cockpit project tests are still fairly new, so there are for sure things that could work more
robustly, easier, more flexibly, or just have better documentation. If you run into trouble, please don't hesitate
telling us about it, preferably by [filing an issue](https://github.com/cockpit-project/starter-kit/issues).

Happy hacking!

The Cockpit Development Team
