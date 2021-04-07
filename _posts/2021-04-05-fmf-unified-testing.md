---
title: Unified upstream and downstream testing with tmt and Packit
author: pitti
date: 2021-04-05
category: howto
tags: qa testing gating distribution fmf tmt fedora packit
---

Automated package update gating can tremendously increase the quality of a Linux distribution. (Gated packages are only accepted into a distribution when tests pass.)

Two and a half years ago, we started to [gate the Fedora cockpit package on our browser integration tests](https://src.fedoraproject.org/rpms/cockpit/c/f639e531f9357e1a42ce7a050726d520c1586535). We have continued to increase the number of tests ever since.

I'm especially happy gating is now in Fedora, as I had worked on [testing in Ubuntu](https://wiki.ubuntu.com/ProposedMigration) and [Debian](https://ci.debian.net/status/) [many years ago](https://piware.de/2011/11/12-04-testing-ftw/). (Adoption is a bit slower in Fedora, as it does not do reverse dependency gating *yet*.)

## Fedora gating woes

But there's a problem of scale: The more tests we added to gating, the more likely it became that any one of them would fail. Fedora's distribution gating tests also failed at the worst possible time: After an upstream release. It felt like every single Bodhi update in the last year had failing tests. I couldn't remember a single time when tests were green.

Fedora's test VMs use different settings from Cockpit's, such as the number of CPUs and amount of RAM, or the list of preinstalled packages. The time it takes to perform each test varies as well. For example: Fedora's testing VMs (running on EC2) are notably slow during evenings in Europe.

Running Fedora's tests locally requires know-how and tricks:

- How is the test environment defined and configured?
- Where can someone download the gating VM images?
- How do I start them to get a similar environment as the CI system?

Fedora's [Standard Test Interface](https://docs.fedoraproject.org/en-US/ci/standard-test-interface/) was flexible and precise when covering the API, but lacked pinning down the test environment. The documentation more or less says "just run `ansible-playbook` in a VM", but there is no tool to provide such a VM.

It was time to fix this once and for all.

## Fix: Run distribution tests upstream

The concept to fix the tests is simple:
1. Pin down the environment where these tests run, and provide a tool to create and use them.
2. Make it trivial to locally run and debug a package’s gating tests.
3. Run gating tests for *every* upstream change (i.e. pull request), using *the exact same* environment, test metadata, and configuration.

I'm happy to say that, after a lot of work from several different teams, all these now exist!

## Flexible Metadata Format

[FMF](https://tmt.readthedocs.io/en/latest/spec.html) (Flexible Metadata Format) is the successor of the Ansible-based Standard Test Interface. FMF is declarative YAML and distribution/project agnostic. The "flexible" in FMF is rich, so that (by design) it does not limit what tests can do or where to they run. Despite its complexity, most settings have good defaults, so you don’t need to know about every detail.

We first added FMF to Cockpit's [starter kit](https://github.com/cockpit-project/starter-kit/commit/09823650e222da0). As a reference, the central file is [`test/browser/main.fmf`](https://github.com/cockpit-project/starter-kit/blob/master/test/browser/main.fmf). This lists the test dependencies, the entry script, and a timeout:

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

Translating from [the STI Ansible tests.yml](https://src.fedoraproject.org/rpms/cockpit/blob/d6853f04e1184f562f872c5c765f40644ef5edc8/f/tests/tests.yml) is straightforward. The STI configuration looked like this:

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

Aside from the above, there's a little bit of boilerplate needed:

- `.fmf/version` (just “1”)
- At least one top-level [`plans/*.fmf`](https://github.com/cockpit-project/starter-kit/blob/master/plans/all.fmf). This can be the same for every project. Hopefully, it may be the implied default some day.

This test metadata format provides underpinnings for the following new tools.

## Test Management Tool

[Test Management Tool](https://docs.fedoraproject.org/en-US/ci/tmt/) (tmt) addresses the first two points (pinning the environment and running locally). If a project has FMF metadata for its tests, running tmt as simple as:

```sh
tmt run
```

The tool then:

1. downloads a standard Fedora development series VM (34 at the moment)
2. starts it in libvirt/QEMU
3. runs your tests inside the VM
4. produces a live log while the test is running
5. copies out all the test logs and artifacts
6. cleans up everything in the previous steps

### tmt customization

The run command uses a lot of defaults, but supports customization.

**Example 1**: Run on a different Fedora release:

```sh
tmt run --all provision --how virtual --image fedora-33
```

**Example 2**: Run the steps until the report stage (thus skipping finish). This allows you to ssh into the test VM and investigate failures.

```sh
tmt run --until report
tmt run -l login
```

See `--help` and the documentation for details.

Until recently, this only worked with `qemu:///system` libvirt. (That is: not in containers or [`toolbox`](https://docs.fedoraproject.org/en-US/fedora-silverblue/toolbox/).)

The latest testcloud and tmt versions have switched to `qemu:///session` by default. (Thanks to Petr Šplíchal for responding to my nagging so quickly!) Using session enables tmt to run without root privileges, bridges, or services.

## Packit

[Packit](https://packit.dev/) is a tool and a service to automatically package upstream releases into Fedora or Copr.

It recently learned a cool new trick: The [Packit-as-a-Service GitHub app](https://github.com/marketplace/packit-as-a-service) runs a project's FMF test plans in pull requests. Packit-as-a-Service is open source, [simple to set up](https://packit.dev/docs/packit-as-a-service/), and free to use. For projects that use it, this addresses point 3 above (running gating tests for every upstream change).

Tests run on the [testing-farm](https://testing-farm.gitlab.io/api/), which provides reasonable (1 CPU, 2 GiB RAM) AWS EC2 instances. Critically, this is the exact same  infrastructure that the Fedora gating tests use.  This is by design. It’s easier to maintain one testing farm than two sets of infrastructure. Using the same infrastructure provides the necessary reproducibility for project maintainers.

Like Travis or GitHub workflows, your project only needs to add a packit.yaml file. For example, here's Cockpit starter-kit’s:

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

The YAML above binds together:

- the knowledge how to produce an upstream release tarball from your branch
- where the spec file is
- which Fedora releases to run tests in a PR


Packit will then use this information to:

1. build the tarball (`create-archive`)
2. build an SRPM with the spec file
3. build the SRPM in a temporary Copr
4. use tmt to run your tests against these built RPMs

For an upstream project relying on tests, it can’t get much simpler!

### An in-practice example with starter-kit

As an example: Look at a [recent starter-kit PR](https://github.com/cockpit-project/starter-kit/pull/442). Click on “View Details” to expand the tests. It shows four Packit runs.

It's great, but not yet perfect. It is still not obvious how to get from such a [result link](http://artifacts.dev.testing-farm.io/f24bede3-995e-4f10-970f-dc849e950e3a/) to all artifacts.

Minor quality-of-life improvements that are likely forthcoming:

- Finding test artifacts (for now, look at the log to find out the path to the `/work-allXXXXXX` directory and append that to the URL)
- Seeing [live logs while a test is running](https://gitlab.com/testing-farm/general/-/issues/13)



## Recent Fedora CI changes

As mentioned above, Fedora's gating tests are now using the exact same testing farm as Packit. This recent switch allows the test to run in the same environment. It also supports the new FMF+tmt test metadata and the legacy STI format.

These changes get us close to the goal of sharing tests upstream and downstream.

### Missing: embedded test support

While it's almost complete, there is a missing part. There is no current clean way to run tests contained in the upstream tarball.
Right now, the packaging dist-git must have a [top-level FMF test plan](https://src.fedoraproject.org/rpms/cockpit/blob/rawhide/f/plans/upstream.fmf) like this:

```yaml
discover:
  how: fmf
  repository: https://github.com/cockpit-project/cockpit
  # FIXME: get rid of the hardcoding: https://github.com/psss/tmt/issues/585
  ref: "241"
execute:
  how: tmt
```

The workaround, seen in the above snippet, uses tests from a specific tag in the upstream project git. The git tag must match the release in the spec file, to keep tests in-sync with the tested packages. This is awkward, as it requires accessing a remote git (at a specific tag), even though tests exist in the source tarball.

Changing this requires some [tmt design discussion](https://github.com/psss/tmt/issues/585). For now, we [hacked our release scripts](https://github.com/cockpit-project/cockpituous/commit/2ef3f6c99912) to bump up the test plan's `ref:`  when committing a new release to dist-git. If you use this in your project, you need similar "magic" or always update the test plan’s `ref:` along with your spec file.

Even with this hack, Cockpit’s [commit to move from STI to upstream FMF](https://src.fedoraproject.org/rpms/cockpit/c/0fee2830080033ea2be13be30d156b51dcf75b7d) was still a major net gain. Cockpit's tests run straight from upstream now.

## Putting it all together

Cockpit’s [starter-kit](https://github.com/cockpit-project/starter-kit/#running-tests-in-ci), the basis for creating your own Cockpit UIs, implements this all now: FMF metadata, [setup scripts](https://github.com/cockpit-project/starter-kit/tree/master/test/browser), [packit.yaml](https://github.com/cockpit-project/starter-kit/blob/master/packit.yaml), and [documentation](https://github.com/cockpit-project/starter-kit#running-tests-in-ci).

[Doing the same for Cockpit itself](https://github.com/cockpit-project/cockpit/pull/15504) was more involved, because packit’s `create-archive` step has limits: it needs to work in a 768 MiB VM and finish within 30 minutes, but for larger projects this is not enough for webpack. Instead, [a GitHub workflow builds the tarballs](https://github.com/cockpit-project/cockpit/blob/master/.github/workflows/build-dist.yml) and Packit downloads the pre-built artifacts. (We want to do that anyway, as pre-building is useful for speeding up reviews and local development as well.)

The VM constraints are not an issue for smaller projects like [cockpit-podman](https://github.com/cockpit-project/cockpit-podman). The entire webpack build does fit within packit's limits.

It should also not be an issue for most C/Python/etc. projects where `make dist` (or `meson dist`, `./setup.py sdist`, etc.) will usually be quick and lean.

Finally, we were able to collect the prize... Thanks to the new testing frameworks, Cockpit release 241 [passed Fedora gating tests](https://bodhi.fedoraproject.org/updates/FEDORA-2021-abd3934d7b) for the first time in roughly a year! 🎉

## Conclusion

There are finally tools to for cloud-first, proper, consistent, and free upstream/downstream CI... and all without having to maintain your own infrastructure! This is a major milestone and motivator. There's now no excuse to ship any more broken stuff! 😀

Many thanks in particular to [Petr Šplíchal](https://github.com/psss) (testcloud/tmt), [Tomas Tomecek](https://github.com/TomasTomecek/) (packit), and [Miroslav Vadkerti](https://github.com/thrix) (Testing Farm) for tirelessly fixing stuff, responding to my nagging, and helping me with figuring out how it all hangs together!

*[AWS]: Amazon Web Services
*[CI]: continuous integration (testing)
*[Copr]: A build service for unofficial / semi-official Fedora community projects. It's a portmanteau, short for "Community Projects". Pronounced like the metal "copper".
*[EC2]: Amazon Elastic Compute Cloud
*[FMF]: Flexible Metadata Format
*[SRPM]: source RPM
*[STI]: Fedora's Standard Test Interface
*[tmt]: test management tool
*[VM]: virtual machine
*[VMs]: virtual machines
*[tmt]: test management tool
