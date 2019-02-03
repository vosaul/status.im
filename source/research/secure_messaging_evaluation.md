---
title: SoK Secure Messaging Evaluation for Status
tags: status-protocol
---

# SoK Secure Messaging Evaluation for Status

**WARNING: This document is a work in progress and things here might be wrong. All errors in this document belong to Corey and Oskar.**

This document outlines the security guarantees we can make for Status and its messaging.

## Methodology

We use the survey of secure messaging tools by [Unger et al](http://cacr.uwaterloo.ca/techreports/2015/cacr2015-02.pdf) as a starting point.

They break down the problem of secure messaging into largely orthogonal components. For each component they further divide up the problem into security and privacy features; usability and adoption. This makes the trade-offs between thing like convenience, scalability and security apparent.

We (Corey and Oskar) went over each component and evaluated it to the best of our knowledge and by doing basic research.

Also see the sibling document: [evaluation for mixnet based transport privacy layer](https://notes.status.im/SHzCAVFHTKiTwl6snqED3w).

## Trust Establishment
Trust establishment deals with users verifying they are communicating with who they think they are.

### --- Security and Privacy Features
#### Network MitM Prevention (PARTIAL)
> Prevents Man-in-the-Middle (MitM) attacks by local and global network adversaries.

- We use Trust On First Use (TOFU). This is a form of opportunistic encryption. A user doesn't verify another one before talking, in the normal case. However, since a user is tied to a public key, subsequent communication will rely on that key. Unlike, say, a naive username.
- For the initial connection, there's no way of verifying that the public key actually belongs to that user.
- This also touches on impersonation for end UX, since a user can easily pretend to be someone else by setting any display name they want.
- We also have ENS naming system that links a username registered under \*.stateofus.eth to a public-key.  This means that you have to trust whomever owns that subdomain (staked in SNT) to be the owner of the public-key it resolves to. This can act as a form of key directory.
- Ways of improving this:
    - Briar requires users to be in close proximity and use QR codes
    - Additionally, a introducing client a la web of trust can be used; A knows B, B knows C, so B can introduce A and C.
- all messages are encrypted with public key of recipient and signed by sender
- https://blog.securegroup.com/the-socialist-millionaire-protocol-how-secure-chat-prevents-mitm-attacks

#### Operator MitM Prevention (PARTIAL)
> Prevents MitM attacks executed by infrastructure operators.

- See above. There's no specific additional infrastructure.

#### Operator MitM Detection (PARTIAL)
> Allows the detection of MitM attacks performed by operators after they have occurred.

- See above. For multiple devices that are paired, you *should* get notified when a new device is added and synced. However, this requires additional analysis to ensure this invariant holds.
- Each message is signed and *should* be verified.
- TODOS:
    - Verify that you always get notified when device is added.
    - Verify that signatures are verified at each message receival.

#### Operator Accountability (PARTIAL)
> It is possible to verify that operators behaved correctly during trust establishment.
 
- See above. 
- For ENS names, we can assume that the smart contract is working as intended for resolving to public keys.  The are two ways in which this can be compromised:
    - ENS subdomain owner is compromised and redirects the name to a different public-key
    - ENS system is hacked.

#### Key Revocation Possible (NO)
> Users can revoke and renew keys (e.g., to recover from key loss or compromise).

- changing public-key is changing identity
- you cannot currently revoke keys once establishment has been made

If you add a pairing device you can't unpair it (ghost membership vulnerability)

In the future:
- Functionality like universal logins will handle multiple keys under a single identity

Another interesting idea would be to have revocation contract, where people can blacklist their own keypair as a form of revocation. E.g. by default in public chats it'd show up as "compromised account". Sparse merkle trees can be used for this.

#### Privacy Preserving (PARTIAL)
> The approach leaks no conversation metadata to other participants or even service operators.

- By default, yes.
- ENS names are not privacy preserving, but that is an optional feature and it doesn't cover linking of identities.
- Your exposure in public chats could expose your identity as your public key is available.
- Out-of-band is privacy preserving. I.e. if you only have a public key and add someone with a QR code.

comments:
- In web of trust, like Keybase, the links between individuals are public. We currently don't have this mechanism, but this is also relevant when it comes to things like Shamir's key sharing for account recovery.

### --- Usability Properties

#### Automatic Key Initialization (YES)
>No additional user effort is required to create a long-term key pair.

- All key-pairs are HD generated and maintained by the software (or keycard if available)

#### Low Key Maintenance (YES)
>  Key maintenance encompasses recurring effort users have to invest into maintaining keys. Some systems require that users sign other keys or renew expired keys. Usable systems require no key maintenance tasks
  
- no key maintenance is required, only safekeeping of the backup seed phrase.
- In the future, functionality like universal logins would be useful to extend the options of user-facing key maintanence and device risk/revocation.

#### Easy Key Discovery (YES)
> When new contacts are added, no additional effort is needed to retrieve key material.

- contacts are at a base-layer a public-key
- additionally, by using ENS a kind of display name can be used for human-readable links. E.g. foo.barclub.stateofus.eth

#### Easy Key Recovery (YES)
> When users lose long-term key material, it is easy to revoke old keys and initialize new keys (e.g., simply reinstalling the app or regenerating keys is sufficient).

- Key recovery is re-initializing your account with your backed up recovery phrase, which rederives all needed keys

#### In-band (YES)
> No out-of-band channels are needed that require users to invest additional effort to establish.

- currently yes, but this might not be desirable in the future for stronger security guarantees.

#### No Shared Secrets (YES)
> Shared secrets require existing social relationships. This limits the usability of a system, as not all communication partners are able to devise shared secrets.

- A user is a public-key so it doesn't require coordination

#### Alert-less Key Renewal (NO)
> If other participants renew their long-term keys, a user can proceed without errors or warnings.
 
- There is no key renewal for base trust establishment, a user is a public-key
- In the future, Universal logins will help with this maintanence and functionality

#### Immediate Enrollment (YES)
> When keys are (re-)initialized, other participants are able to verify and use them immediately

comments:
- HD public keys have been setup to extend the functionality of having multiple identities under a single public key.  We currently only derive a single public key for conversation, but have the option to do more for identity management. 

#### Inattentive User Resistant (YES)
> Users do not need to carefully inspect information (e.g., key fingerprints) to achieve security.

- Currently and in general, yes.
- It is worth mentioning that we also use three random names as a shorthand mapping for public keys. This is useful to casually establish provenance in a public chat. Additionally we have display names that are user set (and visible to someone who is added as a contact), which could lead to impersonation attacks.
- Note that the possible amount of 3-word pseudonyms is drastically smaller than the possible amount of public keys, so there is potential for collisions, and therefor impersonation attacks here as well.

### --- Adoption Properties

#### Multiple Key Support (NO)
> Users should not have to invest additional effort if they or their conversation partners use multiple public keys, making the use of multiple devices with separate keys transparent. While it is always possible to share one key on all devices and synchronize the key between them, this can lead to usability problems.

- In the future, Universal logins will help with this, as it manages multiple keys and their associated device and risk, and also enables multi-factor authentication for various features. 
- Furthermore, HD wallets could add some multi-key functionality (e.g. different keypairs on each device), but it would probably be best to stick with universal logins.

comments: 
- potential for self-signed attestations to universal blacklist for compromised keys. (sparse merkle tree for lookup)

#### No Service Provider Required (YES)
> Trust establishment does not require additional infrastructure (e.g., key servers).
 
- Not required for trust establishment

#### No Auditing Required (YES)
> The approach does not require auditors to verify correct behavior of infrastructure operators.

- Not required for trust establishment

#### No Name Squatting (PARTIAL)
> Users can choose their names and can be prevented from reserving a large number of popular names

- In general, yes.
- Public keys have a big space. For three-random words it is possible to generate arbitrary combinations with decent computational resources, but this doesn' amonut to "reserving" it.
- For ENS, no. But for each name, a stake of 10 SNT is required, as well as the creation of a new identity (unless they interact directly with the ENSregistration contract directly and not through the app)

#### Asynchronous (YES)
> Trust establishment can occur asynchronously without all conversation participants online.

Yes.

#### Scalable (YES)
> Trust establishment is efficient, with resource requirements growing logarithmically (or smaller) with the the total number of participants in the system

Yes.

## Conversational Security
TODO: description here

### --- Security  and Privacy Features
#### Confidentiality (YES)
> Only the intended recipients are able to read a message. Specifically, the message must not be readable by a server operator that is not a conversation participant

- Yes.
- There's a layer of encryption at Whisper as well as above with Double Ratchet
- Relay nodes and Mailservers can only read a topic of a Whisper message, and nothing within the payload.

#### Integrity (YES)
> No honest party will accept a message that has been modified in transit.

- Yes.
- Assuming a user validates (TODO: Check this assumption) every message they are able to decrypt and validates its signature from the sender, then it is not able to be altered in transit.

#### Authentication (YES)
>  Each participant in the conversation receives proof of possession of a known long-term secret from all other participants that they believe to be participating in the conversation. In addition, each participant is able to verify that a message was sent from the claimed source

- 1:1 --- one-to-one messages are encrypted with the recipient's public key, and digitally signed by the sender's.  In order to provide Perfect Forward Secrecy, we build on the X3DH and Double Ratchet specifications from Open Whisper Systems, with some adaptations to operate in a decentralized environment.
- group --- group chat is pairwise
- public --- A user subscribes to a public channel topic and the decryption key is derived from the topic name

**TODO:** Need to verify that this is actually the case
**TODO:** Fill in explicit details here

#### Participant Consistency (YES?)
> At any point when a message is accepted by an honest party, all honest parties are guaranteed to have the same view of the participant list

- **TODO:** Need details here

#### Destination Validation (YES?)
> When a message is accepted by an honest party, they can verify that they were included in the set of intended recipients for the message.

- Users are aware of the topic that a message was sent to, and that they have the ability to decrypt it.
- 

#### Forward Secrecy (PARTIAL)
> Compromising all key material does not enable decryption of previously encrypted data

- After first back and forth between two contacts with PFS enabled, yes.

#### Backward Secrecy (YES)
> Compromising all key material does not enable decryption of succeeding encrypted data

- PFS requires both backward and forwards secrecy

#### Anonymity Preserving (PARTIAL)
> Any anonymity features provided by the underlying transport privacy architecture are not undermined (e.g., if the transport privacy system provides anonymity, the conversation security level does not deanonymize users by linking key identifiers).

- by default, yes
- ENS Naming system attaches an identifier to a given public key

#### Speaker Consistency (PARTIAL)
> All participants agree on the sequence of messages sent by each participant. A protocol might perform consistency checks on blocks of messages during the protocol, or after every message is sent.

- We use Lamport timestamps for ordering of events.
- In addition to this, we use local timestamps to attempt a more intuitive ordering.
- Fundamentally, there's no single source of truth, nor consensus process for global ordering

TODO: Understand how this is different from Global Transcript

#### Causality Preserving (PARTIAL)
> Implementations can avoid displaying a message before messages that causally precede it

- Not yet, but in pipeline (data sync layer)

TODO: Verify if this can be done already by looking at Lamport clock difference

#### Global Transcript (PARTIAL)
> All participants see all messages in the same order

- See directly above

#### Message Unlinkability (NO)
> If a judge is convinced that a participant authored one message in the conversation, this does not provide evidence that they authored other messages

- Currently, the Status software signs every messages sent with the user's public key, thus making it no able to give unlinkability.  
- This is not necessary though, and could be built in to have an option to not sign. 
- Side note: moot account allows for this but is a function of the anonymity set that uses it.  The more people that use this account the stronger the unlinkability.

#### Message Repudiation (NO)
> Given a conversation transcript and all cryptographic keys, there is no evidence that a given message was authored by any particular user

- All messages are digitally signed by their sender.
- The underlying transport, Whisper, does allow for unsigned messages, but we don't use it.

#### Participant Repudiation (NO)
> Given a conversation transcript and all cryptographic key material for all but one accused (honest) participant, there is no evidence that the honest participant was in a conversation with any of the other participants.

### --- Group related features
#### Computational Equality (YES)
>  All chat participants share an equal computational load

- One a message is sent, all participanats in a group chat perform the same steps to retrieve and decrypt it. 
- If proof of work is actually used at the Whisper layer (basically turned off in Status) then the sender would have to do additional computational work to send messages.

#### Trust Equality (PARTIAL)
> No participant is more trusted or takes on more responsibility than any other

- 1:1 chats and public chats are equal
- group chats have admins (on purose)
- Private Group chats have Administrators and Members.  Upon construction, the creator is made an admin. These groups have the following privaledges:
    - Admins:
        - Add group members
        - Promote group members to admin
        - Change group name
    - Members:
        - Accept invitation to group
        - Leave group
    - Non-Members:
        - Invited by admins show up as "invited" in group; this leaks contacat information
        - Invited people don't opt-in to being invited

TODO: Group chat dynamics should have a documented state diagram
TODO: create issues for identity leak of invited members as well as current members of a group showing up who have not accepted yet

#### Subgroup Messaging (NO)
> Messages can be sent to a subset of participants without forming a new conversation

- This would require a new topic and either a new public chat or a new group chat

#### Contractible Membership (PARTIAL)
> After the conversation begins, participants can leave without restarting the protocol

- For 1:1, there is no way to ignore or block a user from sending you a message.  This is currently in the pipeline.
- For public chats, Yes. A member simply stops subscribing to a specific topic and will no longer 
- For group chats: this assumes pairwise encryption OR key is renegotiated
- This only currently works on the identity level, and not the device level.  A ghost device will have access to anything other devices have.

#### Expandable Membership (PARTIAL)
> After the conversation begins, participants can join without restarting the protocol.

- 1:1: no, only 1:1
- private group: yes, since it is pair-wise, each person in the group just creates a pair with the new member
- public: yes, as members of a public chat are only subscribing to a topic and receiving anyone sending messages to it. 

### --- Usability and Adoption

#### Out-of-Order Resilient (PARTIAL)
> If a message is delayed in transit, but eventually arrives, its contents are accessible upon arrival

- Due to asynchronous forward secrecy and no additional services, private keys might be rotated

TODO: Requires investigation, but should be

#### Dropped Message Resilient (PARTIAL)
> Messages can be decrypted without receipt of all previous messages. This is desirable for asynchronous and unreliable network services

- Public chats: yes, users are able to decrypt any message received at any time.

#### Asynchronous (PARTIAL)
> Messages can be sent securely to disconnected recipients and received upon their next connection

- The semantics around message reliability are currently poor
- There's a TTL in Whisper and mailserver can deliver messages after the fact

TODO: this requires more detail

#### Multi-Device Support (YES)
> A user can participate in the conversation using multiple devices at once. Each device must be able to send and receive messages. Ideally, all devices have identical views of the conversation. The devices might use a synchronized long-term key or distinct keys.

- Yes
- There is currently work being done to improve the syncing process between a user's devices. 

#### No Additional Service (NO)
> The protocol does not require any infrastructure other than the protocol participants. Specifically, the protocol must not require additional servers for relaying messages or storing any kind of key material.

- The protocol requires whisper relay servers and mailservers currently. 
- The larger the number of whisper relay servers, the better the transport security but there might be potential scaling problems.
- Mailservers act to provide asyncronicity so users can retreive messages after coming back from an offline period. 

## Transport privacy

The transport privacy layer defines how messages are exchanged. The goal is to hide metadata such as sender, receiver and to which conversation a message belongs.

This evaluates Whisper as a standalone protocol. However, we also note common usage and Status specific usage.

- [EIP-627, aka Whisper v6](https://eips.ethereum.org/EIPS/eip-627)
- [Whisper PoC 2 spec (more motivation)](https://github.com/ethereum/wiki/wiki/Whisper-PoC-2-Protocol-Spec)

### --- Privacy

#### Sender Anonymity (PARTIAL)
> When a chat message is received, no non-global entities except for the sender can determine which entity produced the message.

- Generally speaking, a peer can't tell if a neighbor is the message originator.

- However, since the "signature" of an envelope doesn't change, this means a Global Passive Adversary can watch a packet as it traverses the network.

- Additionally, being fully surrounded by cooperating adverserial nodes breaks this. This is similar to an eclipse attack, since these nodes can cooperate and distinguish between relaying messages and new messages.

- Light clients that don't repeat traffic will leave more obvious metadata trail.

- Using a mix format would partially mitigate this, e.g. [Sphinx](https://cypherpunks.ca/~iang/pubs/Sphinx_Oakland09.pdf)

- Moot account
    - All messages are signed by (identity) private key that can be generated at will, which provides pseudonymity.  The Moot account is a shared key.  The more people that use it, the larger the anonymity set is. 
    - potential for hard coding it into app for increasing its anonymity set

#### Recipient Anonymity (YES)
> No non-global entities except the receiver of a chat message know which entity received it.

- One caveat is that if you listen to too specialized topics you might give up too much information. This is a trade-off with bandwidth consumption.

- 1:1 chats are currently under one topic, but will be partitioned (somehow)
- ask Roman

- We are working with an optional ACK message to verify receipt of message

- The various types of chat we provide right now are:
    - 1:1 chat
    - Private group chat
    - Public chats

- Since Whisper is broadcast based, we use topics for this. This ensures the bandwidth usage is somewhat more managable, trading off darkness.

- Public chats are hashed to a topic. Then we have a special discovery topic, which we use to coordinate further topics. E.g. for group chat there's a a secret, random topic that's agreed upon for further communication. 1:1 currently uses discovery topic, but you can either partition this or use things like topic ratcheting. This is at the expense of some more coordination, similar to how you generate a shared secret key.

#### Participant Anonymity (YES)
> No non-global entities except the conversation participants can discover which set of network nodes are engaged in a conversation

- See Conversation Security

#### Unlinkability (YES)

> No non-global entities except the conversation participants can discover that two protocol messages belong to the same conversation.

- Since it is broadcast based, there's no unique recipient.

- (This might change depending on topic usage).

#### Global Adversary Resistant (NO)
> Global adversaries cannot break the anonymity of the protocol

- Sender anonymity is broken if an envelope has a unique signature, as well as in the abovementioned eclipse-like attack.

### --- Usability

#### Contact Discovery (YES)

> The system provides a mechanism for discovering contact information.

- A "contact" identifier in Whisper is a public-key.  You can get this via a few methods
    - out of band 
    - in-band in a public chat
    - ENS naming scheme

- Assuming you have a public key, you can contact them.

##### Notes
For a mixnet based approach, see e.g. https://github.com/w3f/messaging/issues/22

#### No Message Delays (YES)
> No long message delays are incurred.

- No real time communication but assuming reasonable node connectivity the number of relays is a low constant.

#### No Message Drops (NO)
> No Message Drops: Dropped messages are retransmitted.

- Whisper messages have a TTL

- With Whisper mailserver extensions expired messages can be received through a direct TCP connection over some timeframe.

#### Easy Initialization (YES)
> The user does not need to perform any significant tasks before starting to communicate.

- True.

#### No Fees Required (YES)
> The scheme does not require monetary fees to be used.

- True.

### --- Adoption

#### Topology independent (YES)
> No network topology is imposed on the conversation security or trust establishment schemes

- The topology has no impact on the security of the network

##### Notes 
-https://github.com/w3f/messaging/issues/12


#### No Additional Services (YES*)
> The architecture does not depend on availability of any infrastructure beyond the chat participants.

- Technically nothing breaks if only the participants are relaying Whisper messages, but some of the security assumptions are based on a broader userbase

#### Spam/Flood Resistant (PARTIAL)
> The availability of the system is resistant to denial-of-service attacks and bulk messaging

- Proof of work produces a nonce based on payload and TTL. However, this doesn't take heterogenerous devices into account.

- For Status this is a NO since PoW is set arbitrarily low.

#### Low Storage (NO)
> The system does not require a large amount of storage capacity for any entity

- Entities receive messages they don't "need". However, there's no requirement for individual nodes to keep messages or write to disk.

- Storage requirement of entire network of N nodes for M messages can be up to M*TTL*N.

#### Low Bandwidth (NO)
> The system does not require a large amount of bandwidth usage for any entity.

- You receive messages you don't need, by relaying, also redundantly.

- It's a flood-like network.

- Use of bloom filters and partial relaying (light mode of operation) reduces this somewhat, at the expense of weaker privacy guarantees.

##### Notes

- Compare redundant messages in Whisper vs PSS: https://status.im/research/whisper_pss.html

#### Low Computation (NO)
> The system does not require a large amount of processing power for any entity

- Must attempt to decrypt every message received on the network, also must provide PoW to send

#### Asynchronous (NO)
> Messages sent to recipients who are offline will be delivered when the recipient reconnects, even if the sender has since disconnected.

- There's a TTL for each message.

- As an extension, there's a Whisper mailserver that resend messages on demand to trusted peers. However, this happens outside of the normal Whisper transport through a direct TCP connection.

#### Scalable (NO)
> The amount of resources required to maintain system availability scales linearly with the number of users.

- It's :whale: worse than linear, as every additional user must carry the load of all other users.

- The trade-off of partitioning the network is losing security around dark routing of messages.

- This trade-off appears suboptimal.

- Peer steering: https://github.com/ethereum/wiki/wiki/Whisper-PoC-2-Protocol-Spec

## Misc notes

### Factors not captured
- Censorship-resistance, DPI etc
- Continuance of protocol
- Availability/Robustness e.g. FW port blocking
- p2p no central source of control
- trust minimized
- Open machine readable specification
- multiple implementaions
- group chat performance
- mobile specific / churnable

### TODO: Later, for each property have
- Current prootocl
- How we use it
- Future considerations
- Desired by Status
- The ethereum txn viewpoint
