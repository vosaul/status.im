---
id: status_uses_openbounty
title: How Status Uses Open Bounty
---

## Who We Target

**Contributors**: get paid for merged Pull Requests in any open source GitHub repo. Payments are in ETH or ERC20 tokens like SNT.

**Organisations**: attract more talented developers who will fix bugs or implement new features faster by paying in ETH or ERC20 tokens for the merged Pull Requests in your GitHub repositories.

## How We Create Great Issues

It's important to set up a repeatable and transparent process for everyone in your organization to understand what kinds of issues are best to put up for bounties and how to create issues that communicate succinctly and exactly what the fix or feature required is, how to scope it correctly and assign an appropriate bounty, and how to manage testing and review of any Pull Requests from external contributors so that they are rewarded timeously for doing the work and encourage to keep on contributing to your project.

A core developer will create an issue she/he would like to see fixed using the same basic template we use for all our issues.
Once happy that they have described the issue and what might constitute an acceptable fix, the developer assigns a `bounty-awaiting-approval` label.
They also need to assign a size label. We use labels like `bounty-xs` to signify size, which translates to a rough estimate of number of hours required to fix. 

`xs=1-2 hrs`, `s=2-4 hrs`, `m=4-8 hrs`, `l=8-20 hrs`, `xl=20-40 hrs`, `xxl=40-60 hrs`. We have an organisational rate of `$35/hr`, though others organisations are welcome to set their own rates.

We use a GitHub Projects board, set up at an organisational level, so that we can pull in and manage bounties in different repos easily from one place. We want to make sure that any of the core developers can easily suggest an issue they'd like to see fixed soon for bounty, so have created a `bounty-awaiting-approval` column that uses Probot to pull in any issue assigned that label in any of the Status repos.

Someone on the team then adds a bounty label to the issue(s). As a result:
a new comment is added to the issue with an Ethereum contract address and 0 ETH and no tokens in it.

There are 3 people managing this currently to maximise responsiveness. They are responsible for creating bounties and then funding them. 

## Status-React Issue Requirements

An issue well-suited to being bounty should satisfy these conditions:

1. We are ok to wait undefined time for the PR (We will be implementing a time-constraint bounty option in the near future)
2. It's described in a good enough way, so external contributor can understand without needing to much prior knowledge of our specific codebase.
3. If it's a bug, then there need to be clear steps to reproduce (both actual and expected results). In case of status-react project - there is a link to TestFairy session with logs/video
4. We have clear acceptance criteria: how do we check that it's done?
5. We can estimate its complexity in XS, S, M, L or XL style (XS - tiny issue to fix, XL - lots of research and work to be done). Most of the time we will use S, M and L labels.
6. At least 2 more team members agree we need it fixed or implemented. Comment or +1 in the issue from extra 2 team members are OK.

## How We Handle and Test Submissions

Just as important as setting up a repeatable and transparent process for everyone in your organization to understand what kinds of issues are best suited to bounties, it's important to have a repeatable and transparent process by which you handle any Pull Requests that are submitted, test them quickly, suggest further fixes to contributors and generally be responsive in order to keep them coming back for more. Our aim is to incentivise open source contributions through both financial rewards, as well as through being responsive, helpful, kind and generally welcoming.

1. We use GitHub Organization Projects to track the issues that could be put up for bounty, have been bountied, have had a PR submitted or have been merged and confirmed. Viewing it may require some permissions within Status' repos, so get contributing ;)
2. First, a basic review of the PR is done. In addition to what the issue description expects, make sure that PR description or title contains "Fixes #NN" - this is how Open Bounty detects the claims for the bounty. Sometimes, this can be automated, but mostly this is fairly manual still. If the PR does not contain the expected "Fixes #NN" comment it will not be considered as a claim, so the developer will not receive payment if you merge as it is. FYI: All detected claims are shown on the Open Bounty website in the Activity feed.
3. If it's status-react project and it's a bug fix or functional feature: testers should get the build and verify the bug fix or new functionality on both Android/iOS before PR is merged.
4. If the PR is good, then merge it. As a result these changes will happen:
    1. For the repository owner on the Open Bounty website -> Manage Payouts. You will see that the button "Confirm" is active to confirm the payment
    2. Open Bounty website shows that developer A won X USD for issue Y (on Activity feed) and status is "Pending maintainer confirmation"
    3. Issue is not listed anymore on Bounties feed
    4. GH issue comment also shows that developer A is a winner
    5. The repository owner then needs to confirm the payment on Open Bounty website. Navigate to the Manage Payouts and click on the `Confirm` button. As a result, the ETH or tokens are released to the winner's Ethereum address from the contract.
