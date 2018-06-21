---
title: Status Communication Protocol Changes
author: Andy Tudhope and Eric Dvorsak
authorURL: http://twitter.com/cryptowanderer
---

For the last year, Status has been focussed on research and development of the core protocols that make up Ethereum, especially Whisper - the "dark", peer-to-peer, end-to-end encrypted messaging protocol. We have worked with various people to bring Whisper from v2 to v5 and now v6, both of which show great performance and reliability improvements, without compromising on the original vision of a truly decentralized chat protocol.

<!--truncate-->

However, there have been some big changes, like the inclusion of offline inboxing, so that we can offer better reliability for sending and receiving messages, especially when offline. Precisely because we are a decentralized community, we do not want to shy away from the problems we have encountered and how we have fixed them, because this is really what is most interesting.

Networks like Ethereum - and the protocols on which they depend - are not "delivered", they are built collaboratively and in the open. In that spirit, we are documenting in more public places the technical achievements, issues, and open questions we have generated since Jarrad first presented Status at DevCon 1.

First up, I had a talk with Eric Dvorsak, one of the Clojure developers responsible for the new chat protocol we have built in the client. We talked about what's changed, the reasons for changing it, and possible future improvements to research.

Eric is a one of a kind person, so settle in for the ride.


## A Better Way to Handle Whisper In the Client



1.  Firstly, it's not really the **new** protocol, it's just the beta version of an evolving decentralized chat protocol. 

1.  Basically,
    1.  You have Whisper, the network communication protocol, which allows you to post messages with certain parameters.
        1.  It is multicast gossip protocol, meaning when you want to send a message to somebody, you send it to pretty much the whole network, and it bounces around with a payload (the message), a ttl (the time to live), and a proof-of-work (yes, whisper needs its own PoW to prevent spam).
        1.  Messages are organised by topics, sort of like an address or ID on the envelope the message is sent in.
        1.  Whisper was really intended for DApp to Dapp communication, so it is an open research question about whether it can handle millions of messages if we scale up to those kind of numbers.
    1.  Status has built an overlay for this - our communication protocol. 
        1.  This provides the primitives needed to use Whisper as a chat protocol.
        1.  We are also researching Swarm and PSS, which is a protocol very closely related to Whisper, but trades off better and more efficient routing of messages for more potential metadata leaks (i.e. it is more obvious to tell who you are trying to send messages to). 

1.  Let's talk a little about the upgrade from Whisper v5 to v6... 
    1.  The major change was the introduction of bloom filters, which result in a reduction of the traffic you are receiving at the cost of some privacy, because you need to "advertise" more about what you're interested in (i.e. which topics you're filtering).
    1.  A [bloom filter](https://en.wikipedia.org/wiki/Bloom_filter) is a data structure that is used for filtering the data you are interested in with false positives (some data you are not interested in pass through but you never miss data you were interested in).  

1.  Status changed our protocol for handling messages with the v6 implementation. 
    1.  Status was originally using only one topic, so the bloom filter approach would have been ineffective. 
    1.  However, there are still trade offs involved here: you can use one topic, like #status, and make it obvious that you are using Status, or you can use multiple topics like in v6, but this may make it possible to develop a sort of "footprint" of your interests. This remains an area of research for now.
    1.  The trade off is important though, because if you use only one, known topic, you make it easy for someone to spam that topic. 
    1.  That said, we still have this weakness in a sense, as contact requests rely on a single channel. This can and will be changed, using different channels, user-set channels, or completely offline key exchange.
    1.  It might have been good to test multi vs single topic to see the effect using multiple topic has on Status' use of bandwidth, as more topics create a heavier load on the network. 

1.  The changes were mostly about making it easier to do updates to the protocol in the future and make the code easier to understand and work with. Going through it just for the changes listed below was sort of like an archaeological dig.
    1.  The documentation is very raw and people are constantly asking for help with experimenting with the latest Whisper, especially other teams of respected developers. We need to answer their calls for help.
    1.  We have built out our protocol incrementally, and it was spread all over the place in areas where it perhaps not have been.
    1.  We needed to "re-contain" all the protocol stuff so that it can be worked on in a more logical and focussed manner. If you have to go all over the codebase to fix something just related to the protocol, it's hard to reason about and test. 

1.  The biggest changes to our client-side protocol were:
    1.  1-1 chat was previously done with asymmetric encryption, and group chat was handled with symmetric keys. It was discussed whether we should use symmetric keys for 1-1 chat. For the go-team in particular, this was a preferable option for performance reasons.
        1.  However, Jacek thinks the performance improvements might be negligible, so it was not necessarily something that needed to be done.
        1.  After some discussion, we then re-introduced asymmetric encryption for 1-1 chats. So, we use symmetric encryption only for contact updates at the moment.
        1.  The choice is easily reversible both ways but it is a little unclear how signatures work exactly: we can dig deeper here for understanding and documentation.
        1.  Part of a whisper message contains a signature field that allows you to verify it has been signed by a specific public-private key pair.
    1.  Group chat was not really working (due to issues with key exchange for large groups, and deleting users from chats), so we tried to fix it. However, due to time constraints and the fact that the functionality of group chats was not clearly defined, especially in terms of their security properties, we pushed it for later and moved to focus on shipping beta, so it has not been further fleshed out.
    1.  There were no big changes to public chat. 

1.  After publishing the updates, there was a lot of discussion around - for instance - which encoding layer we should be using.
    1.  Adria made the [go-sdk](https://github.com/status-im/status-go-sdk), which is all about using the chat primitives from the new protocol to interact with Whisper.
    1.  This is really useful tool and should help us in terms of documenting Whisper and showing in an easy environment how to use and play with it as a developer, but this is not quite possible yet. 
    1.  We need a definitive document on Whisper as it currently stands, and the sdk can still be improved. Sebastien is working on the sdk currently.
    1.  There needs to be further discussion about how to advance the cause for the sdk and Whisper documentation and further development of both whisper and our client side protocol. 
    1.  Perhaps it should not be an sdk, it should be part of status-go itself, so that if you are a go developer, you can just use status-go and tune in to what you want to hear and say.
    1.  Most developers seem to want to use web3 (javascript), so having it in go might lose a large part of the developers who would be interested in using such a tool.
        1.  This is not a view held across the team - Jacek thinks we should design a good protocol to begin with and avoid any kind of vendor/API lock in.

You can find more about the actual code changes and more directly technical stuff on our [wiki](https://wiki.status.im/Status_Communication_Protocol).

## Conclusions

The doc detailing Whisper has been created, and just needs to be split up into easily-readable sections so that we don't just dump a 16-pager on people.
Research into PSS, Swarm and other alternatives has also begun in earnest.
That [status-go-sdk](https://github.com/status-im/status-go-sdk) is also being actively developed, but this needs to be focussed on and owned. Hopefully @seb will handle that.
