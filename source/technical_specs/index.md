---
id: index
title: Whisper - Do You Want to Know a Secret?
---

## Introduction

Whisper is not a typical communications system. 

1. It is not designed to replace or substitute TCP/IP, UDP, HTTP or any other traditional protocols. 
2. It is not designed to provide a connection oriented system, nor for simply delivering data between a pair of specific network endpoints. 
3. It is not designed to maximise bandwidth or minimise latency (though as with any transmission system, these are concerns).

Whisper is designed expressly for a new paradigm of application development. The design goals include: 
1. Easy and efficient multi-casting and broadcasting; 
2. Low-level partially-asynchronous communications; and 
3. Low-value traffic reduction or retardation. 

Whisper is designed to be a building block in next generation ÐApps which require large-scale many-to-many data-discovery, signal negotiation, and transmissions with reasonable assurance of privacy for users.

In short, Whisper is a peer-to-peer, multicast, end-to-end encrypted, dark gossip protocol we use to communicate securely.

### Basic Outline

1. **`peer-to-peer`** refers to the fact that Whisper uses Ethereum's [ÐΞV-p2p wire protocol](https://github.com/ethereum/devp2p/blob/master/devp2p.md) to gossip messages around the network.
    
    **a.** ÐΞV-p2p is an application-layer networking protocol for communication among nodes in a distributed network.
    **b.** ÐΞV-p2p handles negotiation of supported sub-protocols on both sides and carries their messages over a single connection.

2. **`multicast`** means that, when I want to send a message to Bob, I actually broadcast that message to basically the whole network, though it is encrypted with the intended recipient's public key, or the #topic of the public chat for which it is intended.

    **a.** This requires setting a Proof-of-Work that is unique to Whisper, in order to prevent DDoS attacks on the network. 
    **b.** Currently, Status sets a lower `PoW` value for Whisper messages than other clients default to, as higher `PoW` uses too much battery and compute power for most mobile phones. This is an active area of our research.
    **c.** Each message gets sent with a Time To Live (`ttl`), and - even when you receive a message intended for you - you re-encrypt it and carry on broadcasting it until the `ttl` has expired to ensure that there is [plausible deniability](https://en.wikipedia.org/wiki/Plausible_deniability#Freenet_file_sharing) for recipients (a concept that has been used before, e.g. filesharing). 

3. **`end-to-end encrypted`** refers to the fact that Whisper uses it's own public-private key pairs to encrypt messages. It supports both symmetric and asymmetric encryption.

4. **`dark`** refers to the fact above that, in certain modes of operation, messages/packets cannot be tracked/inspected and do not leak metadata. Due to the `ttl` and the fact that clients rebroadcast even messages intended for them until it is over, as well as the ways in which messages are padded (for instance), it is very difficult to identify unique senders and receivers.

In the next article, we'll discuss Whisper's key features, the actual technical specification, and look at it both through the lens of datagram messaging systems (like UDP) and [Distributed Hash Tables](https://en.wikipedia.org/wiki/Distributed_hash_table).