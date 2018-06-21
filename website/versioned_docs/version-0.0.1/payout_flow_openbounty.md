---
id: version-0.0.1-payout_flow_openbounty
title: Open Bounty Payout Flow
original_id: payout_flow_openbounty
---

This describes the sequence of events happening once a PR for an issue with a bounty was merged by repo maintainer.

## Quick info on transaction hashes
In the sequence described below, several types of hashes are used. SOB checks presence of different hashes on records in the issues table to decide which action to take on an issue and associated contract. These hashes are:

1. `transaction_hash:` set when contract is deployed to the labeled issue
2. `execute_hash:` set when PR for an issue with a bounty was merged
3. `confirm_hash:` fetched from receipt from transaction invoked in previous step
4. `payout_hash:` set when payout was confirmed via Manage Payouts

The event flow is given below. For the bounty to be paid, each issue has to go through the steps in given order.

## PR closed and merged
1. app receives notification via GitHub App webhook (endpoint: /webhook-app)
2. handle-claim fn is invoked which will:
3. save PR in the pull_requests DB table, where state=1 for merged PRs
4. update issue in the DB with commit_sha and winner_login, if PR was merged

Afterwards two interleaving sequences of actions come into play: scheduler threads and manual user interaction in the Manage Payouts tab.

## self-sign-bounty scheduler thread
1. input query name `:pending-bounties`. This selects pending bounties (where `execute_hash` is nil and `commit_sha` is set)
2. execute payout transactions
3. store `execute_hash` in issues DB table
4. update GitHub comment to `"Pending maintainer confirmation"`

## update-confirm-hash scheduler thread
1. input query name `:pending-payouts`. This selects bounties with `execute_hash set` and no `confirm_hash`
2. fetch `confirm_hash` from transaction receipt
3. store `confirm_hash` in issues DB table

## Manage Payouts view
In order to confirm a payout, following conditions have to be met for an issue:

1. it is merged
2. not paid yet (meaning its payout_hash is nil)
3. not being confirmed at the moment (:confirming? flag is true) OR
4. already confirmed by a scheduler thread(confirm_hash is not nil)

Note that confirm_hash issue field and confirmation action in the UI are different things, albeit identically named. In order to confirm a payout from the UI, confirm_hash has to be already set by scheduler thread (see above).

The payout confirmation action results in a `:confirm-payout` event. Its handler will:

1. use `confirm_hash` to construct transaction payload
2. set `:confirming?` flag to true
3. execute `confirmTransaction()` call
4. pass transaction callback to `confirmTransaction()`. Once invoked, the callback will:
    1. get `payout_hash` passed as an argument
    2. dispatch `:save-payout-hash event`. Its handler will:
        1. POST to `/api/user/bounty/%s/payout`
            1. This will update `payout_hash` in issues DB table
        2. if POST is successful, dispatch `:payout-confirmed`
            1. `:payout-confirmed` will update `:confirmed?` to `true` and remove `:confirming?` flag

## update-payout-receipt scheduler thread
1. input query name `:confirmed-payouts`. This selects confirmed payouts (the ones that have `payout_hash` and do not have `payout_receipt` set)
2. `store payout_receipt` in issues DB table
and update GitHub comment to `"Paid to:..."`  
