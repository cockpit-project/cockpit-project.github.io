---
title: Cross-project testing with tmt and Packit
author: pitti
date: 2023-08-01
category: howto
tags: qa testing reverse-dependency gating distribution tmt packit
---

## Motivation

All Cockpit projects have been running [gating tests with Packit and tmt](./fmf-unified-testing.html) in upstream PRs and Fedora/CentOS/RHEL for over two years now. That resolved most of our previous woes about broken gating tests after upstream releases.

However, even after several years of tmt tests, Fedora still does not use these tests for gating properly, in the sense that any package update can easily break *other* packages, i.e. packages which depend on the one being updated. That sets up a very bad motivation: By improving their gating tests, a package maintainer can only make their *own* life harder, but their dependencies can still break them all the time. A better approach is when each proposed package update runs the tests of all their dependencies, and is held back if there is any regression. That is generally called **"reverse dependency testing"**, and is what e.g. Debian or Ubuntu have practiced for many years.

As Cockpit is sitting pretty much at the top of the dependency tree, we feel that pain a lot: we find [hundreds of regressions](https://github.com/cockpit-project/bots/issues?q=is%3Aissue+label%3Aknownissue) through our tests. We also [track them in bugzilla](https://bugzilla.redhat.com/buglist.cgi?bug_status=__open__&bug_status=__closed__&f1=status_whiteboard&list_id=12879603&o1=substring&query_format=advanced&v1=CockpitTest) now. Each time that happens, it often takes hours to find the responsible package update, create a standalone reproducer, report a bug, and then either finding a workaround or creating a ["naughty pattern"](https://github.com/cockpit-project/bots/tree/main/naughty) to ignore the problem -- but of course that only takes care of unbreaking our test runs, users are still affected by the regression.

Unfortunately it is technically hard to actually do reverse dependency testing in general in Fedora [†](#footnotes). But also, it is too late at the distro level anyway: At that point the new upstream release which includes the regresssion was already done, and the culprit landed possibly weeks ago already, so that it disappeared from every developer's minds already.

It's [far more efficient](https://en.wikipedia.org/wiki/Shift-left_testing) to flag regressions in a project's consumers right in the pull request that introduces them, *before* it lands: That is the cheapest and most effective time to know what change caused this, the context is in the developer's head, and it avoids the weeks-long cycle of finding the regression, bugzilla, and finding some time to actually fix it. 10 of our known issues have been open since [2021 or earlier](https://github.com/cockpit-project/bots/issues?q=is%3Aissue+is%3Aopen+label%3Aknownissue+created%3A%3C2022-01-01)! [‡](#footnotes)

## Packit and tmt to the rescue

It turns out that modern [Packit](https://packit.dev/) and [tmt](https://tmt.readthedocs.io/) know enough tricks to actually do this. The high-level strategy is:

 1. Configure Packit to build every commit of your main branch, i.e. every merged PR, into a dedicated [COPR](https://copr.fedorainfracloud.org/) repository. That is not just useful for CI, but also for human users: They can easily test the latest fixes or features before you officially release them.

 2. Identify some strategic dependencies of your project which potentially or actually break your tests often.

 3. For each of these, add a tmt test plan for your project, and configure a separate Packit test job to run it for each PR. These run as a separate status, so it makes it very clear if/when a proposed change in the dependency breaks your project.

## RPM repository for each commit

The prerequisite to run tests from your main branch is that they run against the corresponding code, and not against some random older version from some Linux distribution. For a project's own tests, packit builds rpms from a PR automatically, but you need to set this up yourself to test an external project.

The canonical way to set this up is with a COPR. Go to <https://copr.fedorainfracloud.org> and create a "New Project" in your organization or user. Fill in the "1. Project information" section and mark your desired distro releases in "2. Build options". At the bottom, also fill in the "Packit allowed forge projects", i.e. allow the Packit service to interact with your project's pull requests. Example:

![packit allowed forge projects](/images/packit-allowed-forge-projects.png)

Take a look at [Cockpit's "main-builds" COPR](https://copr.fedorainfracloud.org/coprs/g/cockpit/main-builds/) for an example.

Then configure `packit.yaml` in your project to do a [build for each commit](https://packit.dev/docs/configuration/upstream/copr_build#supported-triggers) that lands on your "main" branch; that may have a different name for your project of course. For example, [cockpit-podman did this](https://github.com/cockpit-project/cockpit-podman/pull/1365):

```yaml
- job: copr_build
  trigger: commit
  branch: "^main$"
  owner: "@cockpit"
  project: "main-builds"
  preserve_project: True
```

After landing that, check your COPR's "Builds" page that you actually get a successful package build. The first run will fail, you will get a notification email and have to approve the "packit" COPR user to trigger builds in your COPR. Alternatively, you can [set up the permission in advance](https://packit.dev/docs/configuration/upstream/copr_build#using-a-custom-copr-project).

## Enable your test in a dependency project

This is the step which requires buy-in from the project to which you want to add your tests. That conversation needs to include some agreement how test failures are handled, who will look at them and in which time frame, and similar commitments. Possibly also a link to this blog post to provide the background and motivation 😀.

Add a new `plans/yourproject.fmf` test plan to the dependency which selects the
tests you want to run from your project. Unfortunately you cannot yet [auto-import all plans](https://github.com/teemtee/tmt/issues/1770), but first of all the plan structure doesn't tend to change often, and second this may actually be useful to select a subset of tests that apply to the tested dependency.

So this is mostly a copy of your project's main test plan, with one modification: they should not run by default, but only in a "revdeps" tmt context. For triggering cockpit-podman's tests, this can look like this:
```yaml
# reverse dependency test
enabled: false

adjust+:
  when: revdeps == yes
  enabled: true

discover:
    how: fmf
    url: https://github.com/cockpit-project/cockpit-podman
    ref: "main"
execute:
    how: tmt

/podman-system:
    summary: Run cockpit-podman system tests
    discover+:
        test: /test/browser/system

# ... possibly more test plans here
```

Conversely, you should mark the main test plan for the dependency project to *not* run in the "revdeps" scenario, to keep them apart in the PR statuses and log views:

```yaml
adjust+:
  when: revdeps == yes
  enabled: false
```

Finally, plug it all together: Tell `packit.yaml` to run the "revdeps" context test plan on current Fedora against your "builds from main" COPR, by specifying [tf_extra_params](https://packit.dev/docs/configuration/upstream/tests#optional-parameters). You can of course choose more/different `target`s, as long as your COPR has matching builds for them. Also give it a meaningful `identifier`, so that you can tell the statuses apart. Also enable [automatic failure notifications](https://packit.dev/docs/configuration/#notifications) to ping some people from your team when the tests fail, so that you can work with the PR author to resolve the regression:

```yaml
  # On current Fedora, run reverse dependency tests against https://copr.fedorainfracloud.org/coprs/g/cockpit/main-builds/
  - job: tests
    identifier: revdeps
    trigger: pull_request
    notifications:
      failure_comment:
        message: "revdeps tests failed for commit {commit_sha}. @userone, @otheruser, please check"
    targets:
      - fedora-latest-stable
    tf_extra_params:
      environments:
        - artifacts:
          - type: repository-file
            id: https://copr.fedorainfracloud.org/coprs/g/cockpit/main-builds/repo/fedora-$releasever/group_cockpit-main-builds-fedora-$releasever.repo
          tmt:
            context:
              revdeps: "yes"
```

This will result in a new packit test status where you can see the result and logs:

![packit revdeps test status](/images/packit-revdeps-test-status.png)

For an example, see this [cockpit PR](https://github.com/cockpit-project/cockpit/pull/19155) which enables this. This approach was developed and tested extensively [in an experimental PR](https://github.com/cockpit-project/cockpit/pull/19117).

## Conclusion

This demonstrates that it is possible today to do upstream cross-project testing for reverse dependency gating, without any extra privileges, secrets, or self-managed infrastructure. I truly believe that this approach on a bigger scale will lead to fewer regressions, less frustration, and avoid long and annoying bugzilla/fix/release turnaround cycles. It can increase velocity across the FOSS landscape in the same way as pervasive reverse dependency testing increased stability and velocity in Debian and Ubuntu.

Many thanks to [Karel Srot](https://github.com/kkaarreell) who knows a lot about tmt, [Laura Barcziová](https://github.com/lbarcziova) and [Frantisek Lachman](https://github.com/lachmanfrantisek) from Packit, and [Miroslav Vadkerti](https://github.com/thrix) from Testing Farm for their great help with figuring out all the details here!

## Footnotes

† This is due to the way tmt tests are defined: Their entry point is not in the srpm, but in their dist-git repository, but there is no efficient and robust way to get the dist-git commit that matches the package version that is currently visible to `dnf install`. Of course there can be heuristics like iterating over the commits until you find the right one; but (1) this is ugly, and (2) more importantly, this is first and foremost a political decision, and there currently does not seem to be much desire to actually do this in Fedora and CentOS stream.

‡ Our known issues auto-close once they get fixed, so all open ones are guarenteed to still happen in recent operating systems.

## Current users
 - [podman](https://github.com/containers/podman/blob/main/.packit.yaml) PRs run [cockpit-podman](https://github.com/cockpit-project/cockpit-podman/)'s tests; and already [found a regression](https://github.com/containers/podman/pull/19888#issuecomment-1711548343) which was corrected immediately without landing on main or in a release.
 - [udisks](https://github.com/storaged-project/udisks/blob/master/.packit.yaml) PRs run [cockpit](https://github.com/cockpit-project/cockpit)'s storage tests.

## Revisions

 - 2023-08-01: Original post
 - 2023-09-20: Add failure notifications and current users

*[PR]: Pull request
*[PRs]: Pull requests
