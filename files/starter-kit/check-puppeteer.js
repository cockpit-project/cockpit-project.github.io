#!/usr/bin/node
/* Usage:
 * 1. Build a Cockpit starter kit test VM:
 *   $ git clone https://github.com/cockpit-project/starter-kit.git
 *   $ cd starter-kit
 *   $ make vm
 *
 * 2. Install puppeteer, using the already installed chromium browser:
 *
 *   $ PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1 npm install puppeteer@0.12.0
 *
 *   (You can also just do "npm install puppeteer" if you don't mind
 *   downloading an internal copy of Chromium and want to use the latest
 *   version.)
 *
 * 3. Run this test, with some debug output:
 *
 *   $ DEBUG="puppeteer:page,puppeteer:frame" PYTHONPATH=bots/machine test/check-puppeteer.js
 */

const testOS = process.env["TEST_OS"] || "centos-7";

const child_process = require('child_process');
const puppeteer = require("puppeteer");

// start virtual machine and return VM object; call vm.proc.kill() to stop it again
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

// run shell command in VM object and return its output
function vmExecute(vm, command) {
    let cmd = vm.ssh + ' ' + command;
    let out = child_process.execSync(cmd, { encoding: 'utf8' });
    console.log(`vmExecute "${cmd}" output: ${out}`);
    return out;
}

// return Puppeteer frame object for given frame ID
function getFrame(page, id) {
    return page.mainFrame().childFrames().find(f => f.name() == id);
}

async function testStarterKit() {
    const vm = await startVm();

    const browser = await puppeteer.launch(
        { headless: true, executablePath: 'chromium-browser', args: [ "--no-sandbox" /* to work in docker */ ] });

    const page = await browser.newPage();

    try {
        // log in
        await page.goto(vm.cockpit);
        await page.type('#login-user-input', 'admin');
        await page.type('#login-password-input', 'foobar');
        await page.click('#login-button');

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
    } catch (err) {
        const attachments = process.env["TEST_ATTACHMENTS"];
        if (attachments) {
            console.error("Test failed, taking screenshot...");
            await page.screenshot({ path: attachments + "/testStarterKit-FAIL.png"});
        }
        throw err;
    } finally {
        await browser.close();
        vm.proc.kill();
    }
};

testStarterKit()
    .catch(err => {
        console.error(err);
        process.exit(1);
    });
