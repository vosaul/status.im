---
title: Optimize Your DApp for Status
---

## What does it mean to be Optimised for Status?

- Your DApp looks great on mobile
- You use our name & logo if featuring mobile wallets 
- Your DApp is available on Mainnet and HTTP Secure

Once these items are checked off, you can [submit your DApp](https://docs.google.com/forms/d/1YeYi5MC6LaJJR8iso52cLwSqQPJpmnqIfAWTT6bwTDE/edit) to be included in our registry. 

### Mobile optimization

First and foremost, your DApp should look good on a mobile device. 

- Is your layout responsive? 
- Have you followed [best practices](https://developer.mozilla.org/en-US/docs/Web/Guide/Mobile) to make it easily readable and navigable on mobile? 
- Are images optimised to load quickly on lower bandwidth? 
- Does your DApp contain interstitials or pop-ups that could block mobile users?

Load up your DApp in the Status browser to test it out. We recommend stepping through the core flows of your user.

If you find yourself pinching the screen to zoom in or scrolling horizontally to view cut-off content, you know what to do.  Open that CSS file!

#### Detecting Status

The beauty of Status is that any user accessing your DApp through our browser has *already* installed everything they need to access the Ethereum network and make transactions.

You can detect our browser by checking if `web3.currentProvider.isStatus` returns true.

Knowing that your users are on a mobile browser means that you can put aside any instructions about how to set up a wallet.

You can also provide Status-specific information or show our logo, if you’d like. Our brand assets are available [on GitHub](https://github.com/status-im/design-guides).

#### Technical requirements

We’re always happy to check out projects that are still in development on testnet. Ping us in the #dapps chat on Status or in the [#dev-status channel](https://chat.status.im/#/room/#dev-status:status.im) on Riot with URLs for us to try out.

But for production purposes, DApps need to be available on Mainnet. 

Your DApp also needs to have a valid SSL certificate and be HTTP Secure.


## Adding your DApp to Status

### Instructions

If you’ve tested your DApp on Status and are satisfied with the experience, please [fill out this form](https://docs.google.com/forms/d/1YeYi5MC6LaJJR8iso52cLwSqQPJpmnqIfAWTT6bwTDE/edit).

Due to official Store policies, we unfortunately face restrictions on which DApps we can accept. Gambling & pornography DApps are currently not accepted. 

For more details on these restrictions, please read the [Play Store](https://play.google.com/about/restricted-content/) and [Apple Store guidelines](https://developer.apple.com/app-store/review/guidelines/).

### A note on curation

We want our users to have a great experience of web3 and strive to show them DApps they’ll love, so we do exercise some judgment in curating our list.

Users have the freedom to visit *any* DApp or website they wish in our browser.

We know what you're thinking, and no—it is not in line with our ethos to centralize curation! We plan to solve this with a token curated registry that will give SNT holders the power to decide which DApps belong.

### Need support?

If you need support, it's best to ping us in [#dev-Status](https://chat.status.im/#/room/#dev-status:status.im) on Riot or open an issue [on GitHub](https://github.com/status-im/status-react). 

We’re also reachable on Status, [Telegram](https://t.me/StatusNetworkChat) and [Twitter](https://twitter.com/ethstatus) and we love to hear from you.