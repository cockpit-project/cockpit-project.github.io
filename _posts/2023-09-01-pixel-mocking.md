---
title: Pixel testing update II
author: mvo
date: '2023-09-01'
tags: cockpit
slug: pixel-mocking
category: tutorial
summary: 'Mocking the DOM for Better Pixels, plus statistics'
---

When testing pixels, one needs to deal with parts of the UI that
change from one run of the test to the next.  Things like MAC
addresses, time stamps, and UUIDs are obvious examples.

The pixel test machinery did have mechanisms for this since the
beginning, and now we have added one more.

## Ignored pixels

My initial idea was to use the alpha channel in reference images to
mark specific pixels where the reference doesn't need to match the
current pixels. I did indeed think that we would open GIMP and
carefully paint the areas that we expect to be unstable. That never
happened, obviously. The code to support this is still there, but it
was clear very early on that this is too much work.

So we had the `ignore` argument for `assert_pixels`. With this, you
could specify right in the tests which DOM elements were allowed to
differ from one run to the next. This was much easier to maintain and
made it much more obvious what was going on.

However, different element content might not only change the pixels
inside the element itself, it might also change the size of the
element, and that in turn might change the layout of other
elements.

For example, if a DOM element that should be ignored gets smaller from
one run to the next, the old pixels in the reference image that are
now outside of this element (but used to be inside) will now count as
a difference.

In reality, this is much less of a problem than it might seem: We
usually compare big containers for pixel tests, such as a whole dialog
or top-level panels. These larger elements are not supposed to change
size when their content changes.

However, their internal layout might still be affected: The most
stubborn example is maybe table layout. If the size of the content of
a cell changed at all, the widths of all table columns might
change. We ended up ignoring most content of tables, which is a bit
unsatisfactory.

## Fake pixels

Of course, some large elements do change their size depending on their
content, like pop-ups and tooltips.

So in order to be able to reliably pixel test those and the tables, we
started exploring another approach: Replacing the real data in the UI
with "mock data".  Instead of ignoring a UUID, we would inject a
specific fake one into the UI.

This is conceptually simple, but I got a serious case of "perfection
is the enemy of the good". I was imagining all kinds of theoretical
problems, and I wanted to avoid them all with a bullet proof
implementation. This ultimately failed, but the journey might be worth
telling.

The main issue is that the DOM is "owned" by React, and modifiying it
without involving React seemed like asking for trouble. React might
decide to render just when the tests had inserted their mock
data. Also, as it turned out later, React keeps references to the
nodes it has created and will crash if it finds the DOM in an
unexpected state.

So, the first try was to involve the Cockpit UI code itself in the
mocking process and insert the fake data in front of React. This would
be ultimately stable and ultimately flexible. People would write
something like this to implement a mockable React component:

```js
const Thing = ({ thing }) => {
    const mock = useMock('thing');

    return <div id="uuid">UUID: {mock.?uuid || thing.uuid}</div>;
}
```

And this to control it from a test:

```py
    b.assert_pixels(..., mock={'thing': { uuid: "4713f4c5-404b-43d6-9df6-d6e7f9d951eb" }})
```

This wasn't popular. We don't want to litter our code with a lot of
stuff that is only used during testing.

Instead, we really want to write this in a test:

```py
    b.assert_pixels(..., mock={'#uuid': "4713f4c5-404b-43d6-9df6-d6e7f9d951eb" })
```

This means changing the DOM without telling React: The text content of
anything matching `#uuid` would be replaced with the given string,
right in the DOM.

The first idea was to stop JavaScript execution on the page so that
React didn't have any chance to interfere.  But this meant doin all
DOM manipulation with the CDP APIs! That was not a lot of fun because
those APIs are a bit clunky, and I gave up when React started crashing
anyway because of the unexpected DOM changes. I could probably pressed
on and avoided those crashes, but I was actually happy to give up for
some time.

Using the CDP APIs also meant we couldn't use the nice Sizzle CSS
query syntax that we enjoy in the rest of our test code, and that was
another reason to abandon this route.

But then we found more pixel testing problems that looked like they
could benefit from mocking. At that point, I was finally ready to say
"screw perfection" and just did the most direct implementation that
would work for the most immediate cases that we wanted to tackle, and
race conditions be damned.

So the first implementation that landed in main was little more than

```
document.querySelector("#uuid").textContent = "4713f4c5-404b-43d6-9df6-d6e7f9d951eb";
```

This worked surprisingly well, and I should have just done this from
the start.

Later, we did get the expected React crashes, and we had to improve
the mocking code to never remove nodes from the DOM. Now it is careful
to only ever change attributes of nodes of type "TEXT".

We already need to make sure that React is reasonably quiet when the
tests look into the DOM, so I don't actually expect a lot of trouble
in this regard. And we will anyway only fix actual problems from now
on, not imaginary ones!


## Real numbers

Lets look at some numbers and compare them to [from 19 months
ago](https://cockpit-project.org/blog/pixel-testing-update.html).

We now have two more layout variants, "dark" and "rtl". These cover
two new features in Cockpit, "Dark Mode" and right to left text
rendering. As with the "mobile" layout, pixel testing these will help
avoid regressions even if us developers rarely use Cockpit in those
modes ourselves.

The main Cockpit tests now have 72 pixel tests (up from 52),
Cockpit-podman now has 12 (up from 5), and Cockpit-machines has 31 (up
from 20).

The full set of reference images is now about 20 MiB (up from 10 MiB).

The repository with all the history of all reference images is now
about 220 MiB, up from only 22 MiB.  As a comparison, the main Cockpit
source repository grew to about 200 MiB from 110 MiB in the same time.

So as expected, the reference image history grows much faster in size
than the code history. It was the right call to keep it out of the
main source repository and arrange its commits so that we can prune
history without affecting the main source repositories at all. Still,
we can probably do another five years of pixel testing without having
to think of actually pruning anything.
