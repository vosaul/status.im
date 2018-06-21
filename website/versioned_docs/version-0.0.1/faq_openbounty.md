---
id: version-0.0.1-faq_openbounty
title: Status Open Bounty FAQ
original_id: faq_openbounty
---

## Can I use Status Open Bounty for any project?
Yes, any public repository hosted on GitHub will work with Status Open Bounty!

## How can I submit a PR to collect a bounty correctly?
Watch this video for a quick intro, or follow the text below.

Putting in your claim on an issue is as easy as simply submitting a Pull Request with the code fixes as you normally would, with the minor addition of a `Fixes #XX` where `XX` is the issue number to which the bounty is assigned. This can be included in the title, the description, or one of the commits, though it is best for readability to put it in the description when you submit the PR.

If you've submitted a PR already without referencing the issue number, don't stress! You can always just edit the PR description body to reflect the correct `Fixes #XX` and Open Bounty will pick it up.

1. Edit the issue by click the pencil in the top right.
2. Added the text "Fixes #XX" where XX is the issue you want reference:
3. Click Update and check the "Activities" tab on openbounty.status.im:

## What crypto is accepted for Status Open Bounty?
You can now create bounties with both Ether and other ERC-20 or ERC-223 tokens! Check out the site now for examples of some bounties with SNT assigned as their rewards.

## Can I use Status Open Bounty for any project? 
Yes, absolutely! Status Open Bounty is a full toolset in its own right that allows any open source project anywhere in the world to find quality contributors through assigning monetary rewards to work on any issue they might be having. The entire project is about building virtuous feedback loops that generate increasingly more value for open source software in general, so join in the fun.

## Is Status Open Bounty on main-net? 
Yes, it is.

## Can I try it on a testnet first?
Yes, we have an instance running on Ropsten here that you can use to test at first if you're not exactly sure about what you're doing.

## My claim was shown in the Activity feed and now I do not see it, what’s going on?
Most likely, your PR was merged and the bounty is waiting for confirmation from the repo admin. You can check it by opening the bounty issue, and look for pending approvals.

## Can you split a bounty?
Not quite yet, but we're working on it.

## Can I solve more than one issue in a PR?
Not currently.

## What is the actual deployment of contract flow from a technical perspective?
This briefly describes events that occur when an issue is labeled as bounty and a new contract has to be deployed.

1. Issue is labeled
2. Event is received via GitHub App webhook
3. Contract is deployed
4. GitHub issue comment "Deploying contract..." is posted
5. `transaction_hash` is stored in the issues table
6. The following items execute in scheduler threads that run each minute, so up to 60 sec delay can be expected.

1. `update-issue-contract-address` scheduler thread fetches transaction receipt, pdates `contract_address` and updates GitHub comment with a new image and current balance
2. `deploy-pending-contracts` scheduler thread checks if there are issues that did not have corresponding contracts deployed and attempts to redeploy
3. `update-balances` scheduler thread checks balances and updates GitHub comment accordingly
4. `update-contract-internal-balances` scheduler threads updates internal ERC20 token balances for all deployed contracts. This is required by current contract code.
