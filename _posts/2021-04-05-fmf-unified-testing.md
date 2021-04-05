---
title: Unified upstream/downstream testing with TMT and Packit
author: pitti
date: 2021-04-05
category: howto
tags: qa testing gating distribution fmf tmt fedora packit
comments: true
---

Two and a half years ago, we started to [gate the Fedora cockpit package on our browser integration tests](https://src.fedoraproject.org/rpms/cockpit/c/f639e531f9357e1a42ce7a050726d520c1586535), and since then have run an ever-increasing number of tests in it. When doing it properly, automated package update gating can increase the quality of a Linux distribution tremendously -- I've worked a lot on that in [Ubuntu](https://wiki.ubuntu.com/ProposedMigration) and [Debian](https://ci.debian.net/status/) [many years ago](https://piware.de/2011/11/12-04-testing-ftw/), and I am really happy to see it happening in Fedora as well, even though adoption is slow (because it does not do reverse dependency gating yet).

## Fedora gating woes

But since then we've had an ever-increasing problem: The more tests we added to it, the more likely any of them failed. The environment where Fedora runs its tests is different to our upstream VMs in quite a lot of subtle ways: configuration, capacity, and timing. So while we gate every PR on a dozen operating systems with several hundred complex integration tests, these did not take into account these differences. These distribution gating tests failed at the worst possible time: *after* an upstream release, when the damage was done.

They were also rather awkward to reproduce locally, one would have to know a lot of tricks like where to download the gating VM images from, and how to invoke them. The original definition of Fedora's [Standard Test Interface](https://docs.fedoraproject.org/en-US/ci/standard-test-interface/), while being fairly flexible and precise on the test API, was missing to pin down the test environment. It was mostly hand-waved away as "just run `ansible-playbook` in a VM".

I can't remember a single bodhi update in the last year when these tests went green, there was always a bunch of failures; so it really got high time to fix this once and for all.

## Fix: Run distribution tests upstream

The conceptual solution is quite obvious:
 1. Pin down the environment where these tests run, and provide a tool to create and use them.
 2. Make it trivial to locally run and debug a package's gating tests.
 3. Run these gating tests for *every* upstream change (i.e. pull request), in *exactly the same* environment, with *exactly the same* test metadata and configuration.

I'm really happy that all of these finally exist!

## Flexible Medadata Format

[FMF](https://tmt.readthedocs.io/en/latest/spec.html) is the successor of the Ansible based [Standard Test Interface](https://docs.fedoraproject.org/en-US/ci/standard-test-interface/). It is declarative, YAML, completely distribution/project agnostic, and rather rich (i.e. flexible), so that it does not limit by design what your tests can do or where to run them. Despite its complexity, most of its settings have sane defaults, so that you don't need to know that much about it.

As a reference for the Cockpit world, check out how FMF was [added to starter-kit](https://github.com/cockpit-project/starter-kit/commit/09823650e222da0): The central file is [test/browser/main.fmf](https://github.com/cockpit-project/starter-kit/blob/master/test/browser/main.fmf) which lists the test dependencies, the entry script, and a timeout:

```yaml
summary:
    Run browser integration tests on the host
require:
  - cockpit-starter-kit
  [...]
  - npm
  - python3
test: ./browser.sh
duration: 60m
```

This is a pretty straightforward translation from the [STI Ansible tests.yml](https://src.fedoraproject.org/rpms/cockpit/blob/d6853f04e1184f562f872c5c765f40644ef5edc8/f/tests/tests.yml) which looked like this:

```yaml
- hosts: localhost
  roles:
  - role: standard-test-source
    tags:
    - always

  - role: standard-test-basic
    tags:
    - classic
    required_packages:
    - cockpit
    [...]
    - npm
    - python3
    tests:
    - verify:
        dir: .
        run: ./verify.sh
        save-files: ["logs/*"]
```

Aside from that you just need some boilerplate `.fmf/version` (just "1") and at least one top-level [plans/*.fmf](https://github.com/cockpit-project/starter-kit/blob/master/plans/all.fmf) (which can really be the same for every project, and hopefully it will be the implied default some day).

This test metadata format provides the underpinnings for the following new tools.

## Test Management Tool

The relatively new [Test Management Tool](https://docs.fedoraproject.org/en-US/ci/tmt/) (`tmt`) addresses the first two points above: Provided that you project has FMF metadata for its tests, a simple

    tmt run

downloads a standard Fedora development series VM (34 at the moment), starts it in libvirt/QEMU, runs your tests inside it, gets you a live log while the test is running, copies out all the test logs and artifacts, and cleans up everything again. You can customize this in various dimensions, such as running on a different Fedora release:

    tmt run --all provision --how virtual --image fedora-33

or run the steps only until the `report` stage (thus skipping `finish`), so that you can ssh into the test VM and investigate failures:

    tmt run --until report
    tmt run -l login

See `--help` and the [documentation](https://docs.fedoraproject.org/en-US/ci/tmt/#_execute_tests) for details.

Until recently this only worked with `qemu:///system` libvirt, i.e. not in containers or [toolbox](https://docs.fedoraproject.org/en-US/fedora-silverblue/toolbox/). Fortunately, the latest [testcloud](https://pagure.io/testcloud/pull-request/83) and [tmt](https://github.com/psss/tmt/issues/541) versions now switched to `qemu:///session` by default (thanks to Petr Šplíchal for responding to my nagging so quickly!), so that `tmt` now makes *zero* root-only configuration assumptions about the hosts and does not need any root privileges, bridges, or services.

## Packit

[Packit](https://packit.dev/) started out as a tool and service to automatically package your project's new upstream releases into Fedora or COPR. It recently learned a really cool new trick, though: The [Packit-as-a-Service GitHub app](https://github.com/marketplace/packit-as-a-service) runs your project's FMF test plans in upstream pull requests. It is [simple to set up](https://packit.dev/docs/packit-as-a-service/), free, and completely addresses point 3 above.

Tests run on the [testing-farm](https://testing-farm.gitlab.io/api/), which provides reasonable (1 CPU, 2 GiB RAM) AWS EC2 instances for your project's tests. Critically, this is the *very same* infrastructure that is now being used for the Fedora gating tests. That's by design -- it's easier to maintain one testing farm than two sets of infrastructure, and provides the necessary reproducibility for project maintainers.

Similarly to Travis or GitHub workflows, your project only needs to add a `packit.yaml` file, similar to [starter-kit's](https://github.com/cockpit-project/starter-kit/blob/master/packit.yaml):
```yaml
specfile_path: cockpit-starter-kit.spec
actions:
  post-upstream-clone: make cockpit-starter-kit.spec
  # reduce memory consumption of webpack in sandcastle container
  # https://github.com/packit/sandcastle/pull/92
  # https://medium.com/the-node-js-collection/node-js-memory-management-in-container-environments-7eb8409a74e8
  create-archive: make NODE_OPTIONS=--max-old-space-size=500 dist-gzip
  # starter-kit.git has no release tags; your project can drop this once you have a release
  get-current-version: make print-version
jobs:
  - job: tests
    trigger: pull_request
    metadata:
      targets:
      - fedora-all
```

This binds together the knowledge how to produce an upstream release tarball from your branch, where the spec file is, and on which Fedora releases to run tests in a PR. Packit will build the tarball (`create-archive`), build an SRPM with the spec file, build it in a temporary [COPR](https://copr.fedorainfracloud.org/), and use `tmt` to run your tests against these built RPMs. As a consumer, it really can't get much simpler than that!

If you look on a [recent starter-kit PR](https://github.com/cockpit-project/starter-kit/pull/442), click on "View Details" to expand the tests, there you can see the four Packit runs.

It is still not obvious how to get from such a [result link](http://artifacts.dev.testing-farm.io/f24bede3-995e-4f10-970f-dc849e950e3a/) to all artifacts (search the `/work-allXXXXXX` directory path in the log, then open that), or getting some [live logs while a test is running](https://gitlab.com/testing-farm/general/-/issues/13), but that will surely be improved really soon.

## Recent Fedora CI changes

As mentioned above, Fedora's gating tests recently switched to run on the very same [testing-farm](https://testing-farm.gitlab.io/api/), so that Fedora gating and Packit tests run in the same environment and thus compare very well. It also supports FMF/TMT test metadata in addition to the old STI.

This gets us *really* close to the goal of sharing the tests upstream and downstream. The only bit that's missing is that there is no clean way how to run tests that are contained in your upstream tarball -- right now, the packaging dist-git must have a top-level [FMF test plan](https://src.fedoraproject.org/rpms/cockpit/blob/rawhide/f/plans/upstream.fmf) like this:

```yaml
discover:
  how: fmf
  repository: https://github.com/cockpit-project/cockpit
  # FIXME: get rid of the hardcoding: https://github.com/psss/tmt/issues/585
  ref: "241"
execute:
  how: tmt
```

This checks out the tests from your upstream project git, from the tag that **must** match the release in the spec file, so that the tests are in sync with the tested packages. This is awkward, as it requires accessing a remote git even though the tests are already in the source tarball; and it needs to know which exact tag to check out, so that the tests match your packaged release. This requires some [tmt design discussion](https://github.com/psss/tmt/issues/585), but for now we just [hacked our release scripts](https://github.com/cockpit-project/cockpituous/commit/2ef3f6c99912) to automatically bump the `ref:` in the test plan when it commits the new release to dist-git. If you use this in your project, you need similar magic, or always remember to update the test plan's `ref:` along with your spec file.

Even with this hack, cockpit's [commit to move from STI to upstream FMF](https://src.fedoraproject.org/rpms/cockpit/c/0fee2830080033ea2be13be30d156b51dcf75b7d) was still a major net gain: The added files are rather static and uninteresting, and all the test setup and the tests themselves run straight from upstream now.

## Putting it all together

Cockpit's [starter-kit](https://github.com/cockpit-project/starter-kit/#running-tests-in-ci), the basis for creating your own Cockpit UIs, contains all of this now: FMF metadata, [setup scripts](https://github.com/cockpit-project/starter-kit/tree/master/test/browser), [packit.yaml](https://github.com/cockpit-project/starter-kit/blob/master/packit.yaml), and [documentation](https://github.com/cockpit-project/starter-kit#running-tests-in-ci).

[Doing this for cockpit](https://github.com/cockpit-project/cockpit/pull/15504) was a little more involved, mostly because packit's `create-archive` step is currently rather limited -- it needs to work in a 768 MiB VM and finish in 30 minutes, which is just not enough for webpack. So we [build the tarballs](https://github.com/cockpit-project/cockpit/blob/master/.github/workflows/build-dist.yml) in a GitHub workflow and just download these from packit (we want to do that anyway, as these are highly useful for speeding up reviews and local development as well). This is not an issue for smaller projects like [cockpit-podman](https://github.com/cockpit-project/cockpit-podman), where the entire webpack build does fit info packit. It should certainly not be an issue for most C/Python/etc. projects where `make dist` (or `meson dist`, `./setup.py sdist`, etc.) will usually be fairly quick.

Finally we were able to collect the prize -- the cockpit 241 release [passed Fedora gating tests](https://bodhi.fedoraproject.org/updates/FEDORA-2021-abd3934d7b) for the first time in a year or so! 🎉

## Conclusion

There are finally good enough tools to give you proper upstream/downstream CI, in a consistent way, for free, without having to maintain your own infrastructure. This is a major milestone and motivator. No excuse any more to ship broken stuff! 😀

Many thanks in particular to [Petr Šplíchal](https://github.com/psss) (testcloud/tmt), [Tomas Tomecek](https://github.com/TomasTomecek/) (packit), and [Miroslav Vadkerti](https://github.com/thrix) (Testing Farm) for tirelessly fixing stuff, responding to my nagging, and helping me with figuring out how it all hangs together!
