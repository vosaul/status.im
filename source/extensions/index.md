---
layout: extensions
title: Extensions Manifesto
comments: false
---

# Extensions Manifesto

Extensions are a way for 3rd party developers to grow the Status application while reusing its features.

Lightweight, they provide native performance and feeling while ensuring you can keep things distributed. Augment your ÐApp with Status' unique features.

## Goal

Status is investing a lot of energy into make decentralized primitives available on mobile platforms. Let’s allow Ethereum developers to focus on what they do best: innovate. 

Open and free, Status is now extensible. 

Specifically we want:
* To make Status awesome for end users who want to use Mini DApps (MAPs?) easily
* To make Status an appealing way for Ethereum devs to extend their work on mobile

## Usage

Extensions are not applications. They free people from the heavy cost of installing anything through the App or Play stores.

A typical scenario consists of a user scanning a QR code and being redirected to Status, where an extension is installed. The extension can plug into Status' native features and leverage our UI to provide a friednly, lighter, fully distributed experience (without the user really needing to notice, beyond granting the necessary permissions). The extension can then disappear right after use, or persist. It depends on your preference.

#nofriction

## How open?

Status is inherently malleable. It is nevertheless Status’s responsibility to choose carefully what is available to extensions and how it can be extended.

Openness is fundamental to Status. It is based on three pillars: data access, our API, and extension points.

There is a delicate balance between providing the access needed to create awesome ÐApp while ensuring that users have absolute and granular control over their data. To that end, a new security model that emphasizes the `data destination` will be considered (in a p2p world, knowledge of what you send and to whom you send it is critical). 

### Data access

Data is kept in a single, tree-based entity. Extensions will rely on a query mechanism for accessing any subset of this data. Depending on the permissions granted, extensions might have access to most of the data manipulated by Status.

Specifically,

* Local profile / wallet details
* Contacts details
* Local Ethereum state

will be available.

## Security 

Security is important when we rely on external resources. In particular, we want to ensure that an extension:

* can access only the data it is supposed to access
* cannot trigger unallowed events
* cannot consume unexpected resources 

### Dynamic analysis

Extensions are primarily data driven, allowing Status to perform dynamic checks and validate the safety of an extension. Before an extension can be activated, Status displays comprehensive information related to the risks involved with running the extension: permissions, data accessed, peers accessed, custom code, and so on. 

### Whitelisting

Only a small subset of internal queries and events will be made available at first. Gradually, and based on feedback, new ones will be introduced. Data exposed and privacy concerns will be carefully analysed for each query.

### Isolation

For extra security, your custom JavaScript code is run isolated in a dedicated JavaScript environment, called Jail. Jail’s resource usage is monitored, and its lifecycle can be controlled. This ensures that each extension code is safe and cannot be seen by others. This also ensures that this code can impact Status only via the bridges it controls.

Special care must be taken in relation to the global JavaScript objects available in Jails. Notably, the web3 object provides hooks into the local Ethereum node. It might be necessary to filter some of the provided methods to ensure isolation between extensions and Status.

### Phishing

An extension might try to trick users into sending a transaction or signing data. Or it could recreate a fake Status signing window to get access to the account password. This attack vector already exists today with DApps and will be addressed through the same technique: by letting users validate a piece of data (a signing phrase) known only to them and Status. This signing phrase is not available to extensions.

### Resource abuses

Extensions, even those based only on data, might trick Status into using local resources: CPU, memory, and network. Some of these abuse attempts might be detected when an extension is being validated, but a specific scenario of an abuse attempt slipping through the cracks cannot be ruled out.

Status must monitor such impact, inform users of attempted abuses, and allow users to deactivate extensions. If this is not technically feasible, such extensions must be prevented from being reactivated on the next startup of Status.

## Privacy

### Permissions

Permission access is required for an extension to use sensitive queries or events. Permissions are granted, or not, per extension. They are not directly related to the underlying platform permissions, but are semantic permissions linked to data privacy: read profile details, send an HTTP request to a specific host, and so on.

Each available query and event is carefully audited by the core team to ensure that the privacy of shared data is protected by relevant permissions. The set of permissions required for an extension does not need to be manually listed by developers, because they will be inferred from the queries and events used.

The underlying platform permissions (access to camera, access to local storage, and so on) are granted at the application level (Status). Because semantic permissions are applied before platform permissions, there are no security risks related to extensions. This might cause surprises if an extension requests a permission (then granted by the user) that has never been requested. This permission will be granted to Status as a whole. To mitigate this we might consider moving Status to a semantic permission model too.

Similarly, if an extension requests a permission that was previously denied, the user will have to manually grant this permission via the Status profile settings.

## Share

Once a developer is satisfied with an extension the next step is to make it available to end users. Being decentralized all necessary parts will be shared on decentralized file storage and consumed directly by Status.
No need to setup servers, manage infrastructure or deploy in a centrally control platform: raw files accessed in a decentralized way.

This deployment model also enforces two of our core principle: open access and no control of extensions. Developers are free to share what they want, users are free to access what they want.

It also opens the DApps discovery model: local catalog, search engine, chat based federated discovery, serendipity, … the sky is the limit! 
