---
id: development
title: Get Your Hands Dirty
---

# Developing an Extension

Development is split into feature-driven milestones. Each milestone's goal is to ship an identified set of features in a short time (i.e. a few weeks).

1. The high level scope of a milestone is agreed on by the whole team.
2. Developers then create a set of atomic and detailed github issues. 
3. Based on those an estimated delivery date is defined.
4. Reasonable efforts are made to not modify the scope of a milestone once started.
5. Issues are closed regularly to get good sense of progress.
6. If finished early, development proceed to next milestone.

# Workflow

Once an issue is assigned, a developer will work on implementing the feature or fixing a bug. Once ready, the push a PR. It's then their responsibility to make sure this PR gets merged quickly. PRs are the only way to introduce new code in the codebase.

A [trunk based development](https://paulhammant.com/2013/04/05/what-is-trunk-based-development/) model is followed. A PR is reviewed with great care: our ultimate goal is zero regressions, and master is considered production quality.

## Pull request content

A pull request is linked to an issue. Sufficient information is provided so that the review process is simplified.

How to link PR and issues:

* commit name: [#XXX] `<commit_name_here>`
* PR title is the same as commit name
* PR comment starts with `fixes #123` for easier issue navigation

## Definition of done

To be considered ready for review, a pull request must (when relevant):

* not define TODOs
* have a reasonable design (no hack policy)
* be pixel perfect
* have automated tests
* have commented code
* provide documentation
* have been demoed

Developers must go the extra mile to perform manual tests.

## Pull request lifecycle

Once pushed, a pull request will go through a review cycle. Whenever possible checks are automated, e.g. 

* compilation / unit tests execution via CircleCI
* code quality
* patterns usage

Once checks pass, the pull request must be reviewed.
Reviewers are assigned automatically, based on defined [codeowners](https://help.github.com/articles/about-codeowners/)

A reviewer might request changes. If agreement emerges an individual commit is created to simplify follow up reviews.
All commits are squashed into a single commit for final merge.

# Tooling

Github tools are leveraged: issues, pull requests and milestones.

A github project helps tracking overall progress. Kanban is roughly followed.

## Tags

Tags are used to identify and track progress of issues and pull requests.

Initial tags are first added by issue creator. Those can be completed by the whole team.

### Issues tags

* type: bug, enhancement, maintenance, question
* priority: critical, high, medium, low
* status: abandoned, duplicate, wontfix, on hold

### PR tags

* status:  `available`, `in progress`, `blocked by design`, `3rd party`, `review needed`, `revision needed`, `accepted`
