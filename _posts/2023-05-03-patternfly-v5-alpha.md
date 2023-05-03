# Cockpit upgraded to PatternFly 5 alpha

PatternFly team has been working with “all hands on deck” on the version 5. That new major release is still scheduled for June. They have conducted two rounds of alpha testing so far and they've gone pretty well. Meanwhile PatternFly 4 has been in development freeze for a while as the team is focusing on the new version.

**Cockpit has decided to go ahead with an early adoption of PatternFly 5.** The motivation for adopting PatternFly 5 can be summarized in several key points. Firstly, the early adoption of PatternFly 5 is advantageous for the PatternFly team. Secondly, as PatternFly 5 is still in its alpha phase, it is more receptive to significant changes. Thirdly, the high code coverage of Cockpit, with its integration and image comparison testing, provides confidence in being one of the early adopters without compromising product quality. Finally, PatternFly 4 is in development freeze, which hinders the ability to utilize the latest features and fixes found in PatternFly 5.

It’s important to note that PatternFly 5 is not introducing drastic UI changes that the user would be able to notice, like the PatternFly 3 to PatternFly 4 upgrade did. It’s quite accurate to perceive this major release as an evolution of PatternFly 4, with enhancements and bug fixes.

Some of the Cockpit team’s most awaited changes that have user impact from PatternFly 5 include improved dark theme support and using gap instead of margins for spacing, something that brings us one step closer to better RTL (Right to left) language support.


## Upgrade strategy for Cockpit projects

PatternFly 5 is already being used in [the main cockpit repository](https://github.com/cockpit-project/cockpit/). Cockpit projects  which live in separate repositories can still co-exist with Cockpit packages which have already been ported to PatternFly 5. However there is a limitation with the usage of the [shared Cockpit components library](https://github.com/cockpit-project/cockpit/tree/main/pkg/lib/). Since the library has already been updated to PatternFly 5, consumer plugins cannot use the latest shared library without upgrading their codebase to PatternFly 5 as well.

If you want to join Cockpit as an early adopter of PatternFly 5, use the following steps to upgrade.


# Upgrading to PatternFly 5


## Installing PatternFly 5

Run the following commands to install PatternFly 5 alpha:

``` sh
npm install --save \
    @patternfly/patternfly@alpha \
    @patternfly/react-core@alpha \
    @patternfly/react-icons@alpha \
    @patternfly/react-table@alpha \
    @patternfly/react-styles@alpha
```

The PatternFly team has developed a script to help with the upgrade process from `@patternfly/react-core@4.x.x` to `5.x.x`.  Run the following command to install the [pf-codemods](https://github.com/patternfly/pf-codemods/) script:

``` sh
npm install @patternfly/pf-codemods
```

Follow the [usage guidelines](https://github.com/patternfly/pf-codemods/#usage) and run the script for automatically doing part of the changes needed for the upgrade to PatternFly 5. However, running this script will not cover all required changes e  and will leave your codebase in an incomplete upgrade state.

Read the error messages that the script will generate one by one and make sure everything is addressed either by auto-fixes from the script or by manual intervention.

If you want to make multiple commits with isolated logical changes rather than one all-included commits you can use the [`–only` argument](https://github.com/patternfly/pf-codemods/#options) to run a specific rule at a time.


## Cockpit overrides for PatternFly 5

Cockpit has been maintaining a file for [CSS overrides for PatternFly 4](https://github.com/cockpit-project/cockpit/blob/289/pkg/lib/patternfly/patternfly-4-overrides.scss) containing fixes not yet included upstream in PatternFly and also some special customizations for Cockpit. This file has been renamed to [patternfly-5-overrides.scss](https://github.com/cockpit-project/cockpit/blob/main/pkg/lib/patternfly/patternfly-5-overrides.scss) and should be imported by all Cockpit plugins similarly to the PatternFly 4 overrides. The suggested way to import this file is indirectly by importing [page.scss](https://github.com/cockpit-project/cockpit/tree/main/pkg/lib/page.scss). See an [example](https://github.com/cockpit-project/cockpit-machines/blob/main/src/machines.scss#L1) of importing this file in Cockpit Machines repository.


## Examples of external Cockpit plugins upgraded

PR for cockpit-machines: [https://github.com/cockpit-project/cockpit-machines/pull/1052](https://github.com/cockpit-project/cockpit-machines/pull/1052)

PR for cockpit-podman: [https://github.com/cockpit-project/cockpit-podman/pull/1266](https://github.com/cockpit-project/cockpit-podman/pull/1266)
