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

  A fleet of robots run the test suites for each pull request.  This includes unit tests, integration tests, and browser-compatability tests.

  The integration tests performed are slow and brittle, and not all failures are caused by bugs in the pull request, but don't just blame every failure on the crappy tests.

* Whenever a pull request changes the API or makes other significant changes, the documentation needs to be updated. Documentation locations that require manual updating include:
  * https://github.com/cockpit-project/cockpit/blob/master/README.md
  * https://github.com/cockpit-project/cockpit/blob/master/HACKING.md
  * https://github.com/cockpit-project/cockpit/blob/master/test/README
  * the [documentation tree](https://github.com/cockpit-project/cockpit/tree/master/doc), used for [the guide]({{ site.baseurl }}/guide/latest/)

## Git-related / Merging Conventions

* No merge commits on master.

  See https://sandofsky.com/blog/git-workflow.html for the motivation.  In brief, merge commits are confusing when rolling back history to find the commit that introduced a particular bug/feature.

  Thus, we normally use "Rebase and Merge" when merging pull requests, but see below for the special "GH #nnnn" line that needs to be present for this to work.

* Each commit on master should have been reviewed.  (Almost each.)

  The commits made during a release to bump the version number etc don't need to be formally reviewed.

  We trust that all information about the review process will be available from GitHub, thus we don't add Reviewed-By lines or similar markers to the commit messages anymore.  However, we need a strong connection between the commits and the actual pull request so that the review for every commit on master can be found.

  Thus, commits should explicitly reference their pull request. The last line of the commit message should just be "#nnnn".

  It is best if the author of a pull request adds the "#nnnn" line to his/her own pull requests.  This requires rewriting the PR since the number isn't known yet when creating the pull request.

* The subject of a commit should start with a short `<topic>: ` prefix.

  This is usually the package name for frontend code, such as `shell`, `base`, or `server-systemd`, or some other suitable directory name.  Check the existing commits for examples.

* If a commit fixes an issue, it should have a `Fixes #NNN` line.

  At the bottom, before the `Reviewed-by` line.

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