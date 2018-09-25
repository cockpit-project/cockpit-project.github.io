---
title: Workflow
source: https://github.com/cockpit-project/cockpit/wiki/Workflow
---

These are the rules we try to follow when working on Cockpit.

## Review Criteria
* Each commit should be easy to read.

  Commits are for people to read, so try to tell the story of a new feature clearly.  For example, refactor the code in a preparatory commit to make the actual change in the next commit easier to understand.  Try to separate changes to separate pieces of the code base.

  Historical accuracy of how you figured out the final form of a change is ususally not very interesting, but it doesn't need to be totally hidden of course.  If rewriting historical commits is tricky and has a high risk of introducing bugs, don't do it.

* Each commit should adhere to the [Cockpit Coding Guidelines](https://github.com/cockpit-project/cockpit/wiki/Cockpit-Coding-Guidelines)

* The tip of master must always pass the test suites

  A fleet of robots run the test suites for each pull request.  This includes unit tests, integration tests, and browser-compatibility tests.

  The integration tests performed are slow and brittle, and not all failures are caused by bugs in the pull request, but don't just blame every failure on the crappy tests.

* Whenever a pull request changes the API or makes other significant changes, the documentation needs to be updated. Documentation locations that require manual updating include:
  * https://github.com/cockpit-project/cockpit/blob/master/README.md
  * https://github.com/cockpit-project/cockpit/blob/master/HACKING.md
  * https://github.com/cockpit-project/cockpit/blob/master/test/README
  * the [documentation tree](https://github.com/cockpit-project/cockpit/tree/master/doc), used for [the guide]({{ site.baseurl }}/guide/latest/)

* [Screenshots](#screenshot) and/or [videos](#video) should be included in every pull request that causes visual changes.

  Having visuals communicates changes, helps with design reviews, and provides a way to highlight features in the release notes on Cockpit-project.org.

  Pull requests lacking screenshots or videos may be tagged with `needs-screenshot` and/or `needs-video` labels. Depending on the pull request, a lack of a screenshot and/or video may block design reviews or merging.

  When a pull request changes, it's a good idea to include a new screenshot or video to reflect the current state.

## Git-related / Merging Conventions

* No merge commits on master.

  See https://sandofsky.com/blog/git-workflow.html for the motivation.  In brief, merge commits are confusing when rolling back history to find the commit that introduced a particular bug/feature.

  Thus, we normally use "Rebase and Merge" when merging pull requests, but see below for the special "Closes #nnnn" line that needs to be present for this to work.

* Each commit on master should have been reviewed.  (Almost each.)

  The commits made during a release to bump the version number etc don't need to be formally reviewed.

  We trust that all information about the review process will be available from GitHub, thus we don't add Reviewed-By lines or similar markers to the commit messages anymore.  However, we need a strong connection between the commits and the actual pull request so that the review for every commit on master can be found.

  Thus, commits should explicitly reference their pull request. The last line of the commit message should just be "Closes #nnnn".

  It is best if the author of a pull request adds the "Closes #nnnn" line to his/her own pull requests.  This requires rewriting the PR since the number isn't known yet when creating the pull request.

* The subject of a commit should start with a short `<topic>: ` prefix.

  This is usually the package name for frontend code, such as `shell`, `base`, or `systemd`, or some other suitable directory name.  Check the existing commits for examples.

* If a commit fixes an issue, it should have a `Fixes #NNN` line.

* Force pushing to master is allowed, BUT...

  ...write an email to `cockpit-devel@lists.fedorahosted.org` to explain what has been done and why.

  Don't force push master lightly of course.  One reason would be to remove an accidental merge commit, or to quickly correct wrong or missing `Closes` or `Fixes` lines.  When in doubt, don't force push master, close/reopen issues manually as needed, and live with the shame.
 
* The main cockpit-project/cockpit repository should not have any work-in-progress branches.

  Otherwise, there will be a huge number of these branches over time.  We could delete them, but that throws away information, and people would still have them in their local clones.

  Instead, each developer (including the core developers) should make his/her own clone and submit pull requests from there.  This makes it slightly harder to take over a pull request from another developer, but it can be done.

* A pull request with a `WIP` prefix in the name is not yet ready for serious review.

  You can make those pull requests to more visibly share some of your work with the rest of the team.

* Github's 'Request changes' feature will be used to mark pull requests that have been reviewed and need action from the submitter.

  This includes changes to the code, or just replies to comments.  Once you have done all that work, you should dismiss the review and comment to indicate that it is ready for review again.

* A pull request is updated with copious rewrites and rebases until it has a small number of 'perfect' commits.

  These commits should be fit for master and the pull request is merged by rebasing these commits onto master.

* A pull request that depends on other pull requests declares that in its description.

  When the commits of a pull request sit on top of the commits of another pull request, it's not easy to see from github where one pull request ends and the other begins.  Thus, it is import to note dependencies explicitly so that the reviewer is less likely to get confused.

## Merge Workflow

We usually merge requests from the GitHub Web UI with the "Rebase and Merge" button, but sometimes you might need to do it manually.  **Don't follow the instructions for manual merging given by GitHub.**  They are for the regular merge, and will produce a merge commit.

This is Git, so there are many ways to arrive at the wanted result, and all are equally obscure.  Use whatever method is most familiar to you.  Here is one way:

```
$ git fetch origin master
$ git fetch origin pull/<PR-ID>/head
$ git rebase -i origin/master FETCH_HEAD
$ git log
## Check if everything looks good
$ git push origin HEAD:master
$ git checkout master
```

## Screenshot

Screenshots should be in a PNG format.

In some cases, you'll want a full Cockpit page. In others, you may want to crop to the specific section, dialog, or feature you're working on. Some of the tools (like Firefox Screenshots) allow you to crop to the area before saving. Otherwise, you may consider using an additional tool like GIMP to crop the image afterward.

### Firefox 

Firefox has two built-in ways to take screenshots.
1. [Firefox Screenshots](https://screenshots.firefox.com/) is integrated in the URL bar, in the `…` dropdown by default. (You can right click on the option and add it to always be in the URL bar if you take a lot of screenshots.)
   - When running the screenshot tool, it lets you screenshot a portion of the page (with an interactive, resizable area that lets you focus on a specific element), the visible area of a page, or the full page (if the page scrolls off the area — which shouldn't be an issue in Cockpit itself).
   - Once you're happy with the screenshot, click the down arrow to save the screenshot to your computer (in the Downloads folder). It will be in a PNG format, perfect for uploading to GitHub in the comment form of an issue or pull request.
2. Firefox Development Tools
   - If it's not on already, you might need to visit the DevTools configuration area and toggle the screenshot tool on.
   - Clicking on the camera icon will screenshot the whole page and save it to ~/Downloads/ with no UI. If you're already in development tools, it's a quick way to take a screenshot for uploading later. Depending on the context, might need to be cropped, or it might already be perfect for posting.
   - Firefox's responsive view includes this same screenshot tool in the mobile view switcher.

### Chrome

Chrome does not have an easy-to-find screenshot tool built-in by default. It does, however, have hidden developer functionality to take a screenshot:

1. Press "F12" (or hit `Ctrl`+`Shift`+`I`) to activate developer tools, if not active already.
2. Hit `Ctrl`+`Alt`+`P` to bring up developer tool action palette.
3. Start to type "screenshot"
4. Select full size (full page), node (selected element), or screenshot (visible).
5. Chrome saves the screenshot in ~/Downloads/

Also, Chrome has a tricky way to get a vector screenshot. This is super-useful for mockups and experimentation.

1. Open developer tools (F12, just like any other browser).
2. Click on the dev tools' ⠇ menu next to the × button.
3. Choose "More tools".
4. Select "Rendering".
5. Scroll down to "Emulate CSS media".
6. Choose "screen" in the dropdown.
7. Print the page. (`Ctrl`+`P` or select "Print…" from the browser's ⠇ menu in the top-right.)
8. Make the "Destination" set to "Save as PDF".
9. Ensure layout is "Landscape" (in most cases).
10. Click on "More settings".
11. Experiment with paper size (usually A4 or A3).
12. Set "Margins" to "None".
13. Be sure to have "Background graphics" checked.
14. Click the "Save" button.
15. Choose a name and place for your PDF. (The name should default to the title of the page. The location is probably "Downloads" by default.)
16. You can open the PDF in Inkscape to make an SVG, modify the graphics, export as a PNG, or anything else you'd like.

### GNOME Screenshot

GNOME itself has two screenshot tools.

1. Hit the `PrtScn` key (this is customizable, in case your keyboard doesn't have the key by default). A full screenshot is saved in your ~/Pictures/ folder as a PNG. This screenshot will most likely need to be cropped in the GIMP or a similar tool.
2. Type "Screenshot" when in overview mode and the screenshot tool will show up. It lets you grab the whole screen, current window, or select an area to grab. You can add a delay, include the cursor, or apply an effect. When done, you can save the screenshot or copy it to the clipboard (to paste into a tool like GIMP or Inkscape).

### GIMP

GIMP has the ability to take screenshots under the file menu. It has options similar to the GNOME Screenshot tool.

## Video

Install video applications as Flatpaks from Flathub, to ensure the video output works on your system. (Distribution packages sometimes have issues with various codecs and other dependencies.)

### Recording

Be sure to check your desktop to make sure there is no personal information onscreen or odd background tabs in your browser.

- GNOME has a built-in screen recorder: `Ctrl`+`Alt`+`Shift`+`R` toggles the recording state. Your full video output is captured, regardless of the resolution or number of external monitors. Videos are saved in WebM format in the Videos folder in your home directory. Resulting videos probably need to be cropped & edited. This works on Wayland and X11.
- [Peek](https://flathub.org/apps/details/com.uploadedlobster.peek) can record an arbitrary part of a screen, in both X11 and also on Wayland. Be sure to change the format from GIF to either MP4 or WebM (both can be edited in a video editor). In the preferences, change the framerate to 30.
- [SimpleScreenRecorder](http://www.maartenbaert.be/simplescreenrecorder/) works great on X11, but does not work on Wayland.

### Editing

- [Kdenlive](https://flathub.org/apps/details/org.kde.kdenlive) is a full-featured editor.
- [Flathub also has several other video editors](https://flathub.org/apps/search/video%20editor) available. Most are adequate for simple editing.

### Audio

In most cases, videos should have speech indicating what is happening. In everything but the quickest demos, you should have good quality audio.

Audio quality is important.
- Think about what you're going to talk about in advance
- Try to clearly enunciate words
- Record in a quiet environment
- Use a good microphone
- Consider re-recording audio after the video, when you're not trying to multitask by showing the feature and speaking — a good video editing tool lets you swap out the audio tracks

If you do not have an external microphone that works with your laptop, you might want to rely on your phone's built-in mic and swap out the audio track in the video editor.

Audio quality can be ranked (in order of best to worst):
1. Dedicated studio condenser microphone. ([A not-so-bad one can be purchased for €35](https://smile.amazon.de/gp/product/B01MQYWKYY/) — be sure to use the USB adapter if you get it.)
2. Phone's built-in microphone (as it's optimized for speech quality)
3. Webcam microphone
4. Headset/headphones/earbuds microphone (but the quality varies: sometimes it's great, sometimes it's awful)
100. Laptop's built-in microphone

_All_ of the above options will have a background hiss or background noise, unless you go with a higher-end dedicated microphone. Sometimes this comes from line noise; other times it may pick up noise from nearby electronics. Nearly every audio file benefits from processing in a tool like Audacity.

Cleaning up the audio track is a good idea. [Audacity](https://flathub.org/apps/details/org.audacityteam.Audacity) can process audio to [remove background noise](https://fedoramagazine.org/audacity-quick-tip-quickly-remove-background-noise/) and normalize the levels. While this works with audio recorded on a laptop's built-in microphone too, the principle of GIGO (garbage-in, garbage-out) still applies, so try to use a higher quality recording device.