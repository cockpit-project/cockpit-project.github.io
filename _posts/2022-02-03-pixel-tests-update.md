---
title: Pixel testing update
author: mvo
date: 2022-02-03 10:00
tags: cockpit
slug: pixel-testing-update
category: tutorial
comments: 'true'
---

Since May last year, the Cockpit integration tests contain "pixel
tests", as described [here](pixel-testing.html).  Let's have a look at
what has happened since then.

## Mobile layout

Katerina has made it so that all our integration tests run with two
sizes of the browser: one time with the old "desktop" size
(1920x1280), and again with a "mobile" size (414x1920). This has
forced us to look more closely at how Cockpit behaves in such a narrow
screen, and we have since fixed it up quite a bit.

Before this, we had relied on people manually testing Cockpit in a
mobile layout.  This was done occasionally, but now the mobile layout
is almost a first class citizen, and I am certain we will keep fixing
Cockpit until we are fully happy with it.  My feeling is that this
would not have happened without automated pixel testing.

A recent example is [this pull
request](https://github.com/cockpit-project/cockpit-podman/pull/902).
We did know about the broken mobile layout of the images list, but the
thing that kicked us to actually fix it was the enabling of "mobile"
pixel tests in the cockpit-podman repository.  Having to commit a
obviously terrible reference image is unpleasant enough to finally sit
down and fix the thing.

Of course, it helped that we had enough experience from fixing the
mobile layout of Cockpit, and that's how the rising tide lifts all the
boats: Soon everyone in the team will not only care about the mobile
layout, but also know how to fix any issues with it. We have managed
to push the mobile layout over the threshold where it becomes
rewarding to keep it in good shape, instead of it being so annyoing
that we would rather ignore it.

## Some numbers

Right now, we have 52 pixel tests in Cockpit itself, 20 in
Cockpit-machines, and 5 in Cockpit-podman.  Each pixel test has a
reference image for three layouts, so we have 231 of them, totalling
about 10 MiB.  The Git repository with all their history is about 22
MiB, for nine months of pixel testing.  (The main Cockpit repository is
about 110 MiB, for about nine years of hacking.)

Pixel tests are kind of slow, up to a few seconds per image
comparison.  They might increase the running time of our tests by a
couple of minutes.  We will have to measure this more carefully.

## Reproducing pixels

Unsurprisingly, it is non-trivial to make sure that the integration
tests always perform a given pixel test with exactly the same result.
We know that we had to battle rendering issues from the start, but it
took us a bit to figure out the following:

 - Elements need to be scrolled into view before we can test their
   pixels.  Obvious, but it needed to actually happen before we
   realized it.

 - There are some animations, and we need to make sure that we don't
   take a pixel test mid-animation.

 - When the Shell of Cockpit is changed, the content area for pages
   like Networking might change size.  This is a problem for external
   projects that don't control the version of the Cockpit shell.  We
   worked around this by giving the content iframe a fixed size (by
   making the browser window slightly bigger or smaller if necessary).

 - We would miss failed pixels when a test ran into a known issue. A
   known issue would cause the test to be skipped, and one would have
   to look very closely to spot that it also had a failing pixel
   test. This means that we sometimes forgot to update some reference
   images, and would later be surprised by how we could have missed
   them.

 - As we change tests, we would accumulate unused reference images.
   The bots now force us to clean up properly.

 - Even though the actual DOM rendering is suprisingly deterministic,
   one or two pixels in a million still come out slightly differently,
   from time to time.  We have no better idea but to allow a low
   number of imperfections per pixel test.

With every change, we are more certain that we can get the pixel test
costs under control.  We might never reach a point where we can stop
tweaking the pixel test machinery, but the same is true about our CI
testing machinery in general.

## Why don't we hate them?

I was expecting that adding pixel tests to Cockpit would be a hard
sell, but we all seem to like them.  That's awesome!  What a team!

I was afraid that pixel tests would be very unreliable because
browsers would not be nearly pixel perfect enough.  But it turns out
that they are very good at this, actually, even across versions.  We
had to switch off font hinting, and results are not consistent between
running the tests locally and runnning them in the cloud, but pixels
are almost never changing randomly from one run to the next.

The unreliability comes mostly from not getting the DOM into the exact
same state every time a given pixel test runs. This has always been a
problem with our tests and we are pretty good at dealing with it.

However, while the traditional tests were just code in the main repo,
pixel tests are binary files in a Git submodule. Submodules can be
very confusing, and we tried to hide most of it behind a script.  And
Github is actually pretty good with images.

One thing we have learned is to update reference images only very late
in the life of a pull request. Resolving merge conflicts of binary
files in a submodule is just not fun.

I think we all like them because the value that we derive from pixel
tests is well worth their cost. It feels awesome to officially replace
an image of a sucky part of Cockpit with a nice one while fixing the
code, and to show off a new feature with a couple of screenshots that
you know will be kept from regressing.

The original goal, updating Patternfly and not having to worry about
missing visual regressions, has been reached.

So I would say the future looks good for pixel tests.  We are still
adding more, and we have recently added a whole new browser size with
it's own set of 77 new reference images.  We keep them working, and
they keep Cockpit pretty and us honest.

I count that as a success!  And a lot of thanks to the team for being
so willing to experiment.  Especially to Katerina for being even more
excited about pixel tests in the beginning than I was. 😁
