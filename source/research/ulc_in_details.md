---
id: ulc_in_details
title: Ultra Light Client in details
---

# Ultra Light Client in details

## Definitions
* TD - the total difficulty of the chain until a given block
* LES - light Ethereum subprotocol
* ULC - ultra light client, an option of LES
* CHT - Canonical Hash Trie which maps historical block numbers to their canonical hashes in a merkle trie. This allows us to discard the block headers themselves in favor of a trie root which encompasses the accumulation of their hashes and to fetch proofs that a specific block hash is in fact the one we verified earlier [\[1\]][1]

## Overview
ULC is a new option in LES that doesn't break capability with LES protocol, but significantly reduces Ethereum client time and resources to sync with the chain.
The main idea is about reducing an amount of messages and doing less validations on client side.

## What does ULC solves?
1) CPU&Battery consumption
2) Time to start sync
3) Time to finish sync

## ULC in schemes
### Algorithm
```flow
st=>start: Start LES client
with ULC options

op=>operation: Connect to N Trusted LES servers
Hold this connections

op2=>operation: Ask for signed announces
for the block with max TD

op3=>operation: Sync CHTs up to known max TD

op4=>operation: Ask for N latest
signed announces

op5=>operation: Ask usual LES server (can be different each time)
for a block header

cond=>condition: M of N announces are the same?
And all signs are valid?

st->op->op2->op3->op4->cond->op5->op4
cond(yes)->op5
cond(no)->op4
```

### Dataflow
```sequence
ULC->N_Trusted: handshake
Note right of N_Trusted: setup LES params
N_Trusted-->ULC: handshake

Note left of ULC: CHT sync
ULC->N_Trusted: Ask announce
N_Trusted-->ULC: Highest announce
Note left of ULC: announce:\nblock hash, td, number

ULC->N_Trusted: Ask CHTs
N_Trusted-->ULC: CHT "chain" sync

Note left of ULC: Sync headers starting\nfrom latest block CHT + 1
ULC->N_Trusted: Ask announce
N_Trusted-->ULC: announce

ULC->Untrusted: handshake
Untrusted-->ULC: handshake

ULC->Untrusted: ask block header
Untrusted-->ULC: header
Note left of ULC: header:\nblock announce, logsBloom,\nMerkle trees roots:\nstate, transactions, receipts
```

## ULC in Roles
### Trusted LES servers
Trusted LES servers are needed only to send announces (block hash, td, number) to LES(ULC) clients. All announces should be signed. Trusted servers don't know anything about were they choosen as trusted or not by any client. Can be started with `onlyAnnounce` flag, that switches LES server to the mode "only send announces to my peers, do not process any other requests".

### LES servers (untrusted)
LES servers - usual LES servers, a header chain is synchronized with them. Helps to prevent attacks on trusted servers.

### ULC client
1. has some CHT root at the start; has a CHTs "chain", that can be syncked from LES servers; CHT chain allows to request any historical information (block, transaction, receipt) from LES server
2. trusts to announces, that receives from N Trusted LES servers. Announces should be signed by Trusted LES servers. It should be at least M identical announces to trust to.
3. Asks for announces with the biggest TD
4. ULC client starts CHT sync before syncing header chain. ULC client requests newer CHTs from LES servers.
5. requests headers from untrusted LES server, starting from `the highest block known to latest CHT + 1` up to latest block number known from trusted announce
6. ULC client validates:
6.1. announces checking are there M the same announces from N received from Trusted LES servers
6.2. doesn't validates CHT, if we get incorrect CHT it'll be clear later after receiving block headers.
6.3. validates headers as usual LES client except of [VerifySeal](https://github.com/ethereum/go-ethereum/blob/master/consensus/ethash/consensus.go#L491). ULC doen't run `VerifySeal` at all.

## ULC client resources
### Network
* CHT is received from a single LES server that is considered "best to sync" at the moment
* headers are received from a single LES server
* announcements are received from N Trusted LES servers

### Network connections
* tries to be always connected to N Trusted LES servers, in case of disconnection it reconnects
* handles a usual number of connections to LES servers

### Storage
* at least one CHT, but we can have several consecutive CHTs
* headers chain of blocks of the latest Epoch

## Security
### Main issues
1) Mostly are inherited from LES
2) Too few LES servers in the Network
3) Trusted servers discovery (?)
4) DoS on trusted nodes

### Sybill atack on ULC (client)
Prevented because it is already prevented in a classic LES model and we only download headers with trusted announces.

### Sybill atack on trusted servers
Even less possible than in LES model because it's needed to attac,k at least M servers.

### DoS on trusted servers
Possible. ULC makes it much less possible by hiding what nodes are trusted for each user. A user don't send any unusual for LES information to LES servers trusted or untrusted. Any trusted for a user LES server doesn't know that it has been choosen by the user to be trusted LES server.

### MITM
Prevented because all announces must be signed by according LES server.

### What other security guarantees does ULC give and what is it comparable with?

#### Some math
There're 2 kinds of security guarantees:
1. reducing the probability of failure to perform a correct request due to the failure of remote servers - failture and censorship resistance
2. reducing the probability of trust in data coming from malicious nodes

The very mechanism of blockchain synchronization of the ULC is exactly the same as that of the LES. Therefore, comparing the security guarantees of ULC with full, fast and LES does not make sense. It is more important to compare the guarantees of a private RPC server or Infura with ULC.

If the probability of failure or hacking Infura or RPC server is taken as P, then with the ULC consensus M/N, the probability of its failure will be considered as Bernoulli process:

$$P_{ULC\_failure}=\sum_{i=M}^N C_N^i*P^i*(1-P)^{N-i}$$

For example, let's calculate the failure probability $P_{ULC\_failure}$ while syncing or getting an incorrect state, given N=10, M=6 and the failure probability of a single node P:

$$P_{ULC\_failure}=C_{10}^6*P^6*(1-P)^4+C_{10}^7*P^7*(1-P)^3+C_{10}^8*P^8*(1-P)^2+C_{10}^9*P^9*(1-P)+C_{10}^{10}*P^{10}$$

$$P_{ULC\_failure}=210*(1 - P)^4*P^6 + 120*(1 - P)^3*P^7 + 45*(1 - P)^2*P^8 + 10*(1 - P)*P^9 + P^{10}$$

Let's take several values of the LES server failure probability and see what the probability of ULC breakage of the client is:
| $P_{server\_failure}$ | 5% | 1% | 0.1% | 0.01% |
|---|---|---|---|---|---|---|---|---|---|---|
| ~$P_{ULC\_failure}$ | $10^{-6}\%$ |$10^{-10}\%$ | $10^{-16}\%$ | $10^{-22}\%$ |

![0-1](https://i.imgur.com/D8lh6eG.png)

![0-0.001](https://i.imgur.com/0GmOWvy.png)

So ULC drastically increase censorship resistance of an Ethereum client. We can develop far more reliable system using unreliable nodes.

A few N/M, given $P_{server\_failure}=0.01\%$:
| N | M | ~$P_{ULC\_failure}$ |
| ------- | ------- | ------- | 
| 3 | 2 | $3*10^{-8}\%$ |
| 4 | 2 | $6*10^{-8}\%$ |
| 4 | 3 | $4*10^{-12}\%$ |
| 5 | 2 | $10^{-7}\%$ |
| 5 | 3 | $10^{-11}\%$ |
| 5 | 4 | $5*10^{-16}\%$ |
| 6 | 2 | $1.5*10^{-7}\%$ |
| 6 | 3 | $2*10^{-11}\%$ |
| 6 | 4 | $1.5*10^{-15}\%$ |
| 6 | 5 | $6*10^{-20}\%$ |

Values 2/3, 3/4, 3/5, 4/5 look like reasonable values to use in ULC client.

| N | M | ~$P_{ULC\_failure}$ |
| ------- | ------- | ------- | 
| 3 | 1 | $3*10^{-8}\%$ |
| 4 | 1 | $6*10^{-8}\%$ |
| 5 | 1 | $10^{-7}\%$ |
| 5 | 2 | $10^{-11}\%$ |
| 6 | 1 | $1.5*10^{-7}\%$ |
| 6 | 2 | $2*10^{-11}\%$ |

#### Trusted nodes
ULC client needs a set of trusted LES servers to get the current Chain state. It should be said that only ULC client knows it's trusted list, LES servers don't know that has been chosen as trusted by someone ULC client. The only difference is ULC client request and accept only signed announcements to trust nonce (PoW) without check.

We're going to provide predefined in the App trusted LES servers list. E.g. any application wanted to use ULC can define such trusted list for its clients and do load balancing with simple random choice.

Here comes one of the LES problems is that LES server can handle limited number of clients. At the moment it's $LES\_limit=25$.

So if we want 3(M) out of 4(N) ULC consensus, in avarage we have 1000 users online, so we need minimum $Servers=Max(AvarageUsers*N/LES\_limit; N)=Max(1000*4/25; 4)=160$

That was the reason why in ULC a new option was announced for LES server: `--onlyAnnounce`. It limits LES server to handle only `get announce` requests, but it increases the number of simultaneous users up to ~250 (should be stress tested).

With `--onlyAnnounce` the formule will looks like:
$Servers=Max(AvarageUsers*N/LES\_only\_announce\_limit; N)=Max(1000*4/250; 4)=Max(16; 4)=16$

| Users online | N | Server w/o `onlyAnnounce` | With `onlyAnnounce` |
| ------- | ------- | ------- | ------- | 
| 1000	| 4	| 160	| 16 | 
| 1000	| 5	| 200	| 20 | 
| 1000	| 6	| 240	| 24 | 
| 1000	| 7	| 280	| 28 | 
| 5000	| 4	| 800	| 80 | 
| 5000	| 5	| 1000	| 100 | 
| 5000	| 6	| 1200	| 120 | 
| 5000	| 7	| 1400	| 140 | 
| 10000	| 4	| 1600	| 160 | 
| 10000	| 5	| 2000	| 200 | 
| 10000	| 6	| 2400	| 240 | 
| 10000	| 7	| 2800	| 280 | 

It's obvious that scaling due to server expansion inside the service is strictly limited. A prerequisite for the operation of ULS in large scales is an increase in the percentage of LES of servers relative to all of the Etheraum servers.

At the moment there're 15000 nodes, if 30% of them will use LES server, more than 300.000 ULC users can be handled simultaneously.

## Benchmarks
Our beta test showed that ULC sync is ~10x times [faster than LES](https://youtu.be/Z6UUT1TqdTs?t=623)

## Future plans
### Short-Term
Status.im is going to start using ULC to have more censorship resistance and enable all web3 features for DApps.

### Long-Term
* [On ULC incentives](https://hackmd.io/6IhsF6zRSqmtggvNnp1sHQ)
* Ethereum services are going to have microtransactions and it will make possible to make a market of LES servers quotas using [LES service model](https://github.com/zsfelfoldi/ethereum-docs/blob/master/les/service_model.md#continous-auction)

[1]: https://wiki.parity.io/The-Parity-Light-Protocol-(PIP)
