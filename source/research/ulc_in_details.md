---
id: ulc_in_details
title: Ultra Light Client in details
---

# Ultra Light Client in details

## Definitions
* TD - the total difficulty of the chain until a given block
* LES - light Ethereum subprotocol
* ULC - ultra light client, an option of LES
* CHT - Canonical Hash Trie which maps historical block numbers to their canonical hashes in a Merkle trie. This allows us to discard the block headers themselves in favor of a trie root which encompasses the accumulation of their hashes, and to fetch proofs that a specific block hash is in fact the one we verified earlier [\[1\]][1]

## Overview
ULC is a new option in LES that doesn't break compatibility with the LES protocol, but does significantly reduce the time and resources required to sync with the main Ethereum chain.
The main idea is about reducing the amount of messages and doing less client side validation.

## What does ULC solves?
1) CPU and battery consumption
2) Time to start sync
3) Time to finish sync

## ULC in schemes
### Algorithm
```flow
st=>start: Start LES client
with ULC options

op=>operation: Connect to N Trusted LES servers
Hold these connections

op2=>operation: Ask for signed announcements
for the block with max TD

op3=>operation: Sync CHTs up to known max TD

op4=>operation: Ask for N latest
signed announcements

op5=>operation: Ask usual LES server (can be different each time)
for a block header

cond=>condition: Are M of N announcements the same?
Are all signs valid?

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
ULC->N_Trusted: Ask to announce
N_Trusted-->ULC: Highest announce
Note left of ULC: announce:\nblock hash, TD, number

ULC->N_Trusted: Ask CHTs
N_Trusted-->ULC: CHT "chain" sync

Note left of ULC: Sync headers starting\nfrom latest block CHT + 1
ULC->N_Trusted: Ask to announce
N_Trusted-->ULC: announce

ULC->Untrusted: handshake
Untrusted-->ULC: handshake

ULC->Untrusted: ask block header
Untrusted-->ULC: header
Note left of ULC: header:\nblock announce, logsBloom,\nMerkle trees roots:\nstate, transactions, receipts
```

### Validation of header "chain" for LES and ULC
1. sanity check that the provided chain is actually ordered and linked. If we have a header chain of length N, for every $n_i$ and $n_{i-1}$, $i \epsilon [0; N]$, conditions should hold:
    1.1. $n_i.Number = n_{i-1}.Number+1$
    1.2. $n_i.ParentHash = n_{i-1}.Hash$
2. in Ethereum Yellow Paper section 4.3.4. "Block Header Validity"[\[2\]][2]
    2.1. The length of $n_i.Extra < 32 bytes$
    2.2. Checks block timestamp:
        2.2.1. It shouldn't be from future more than 15 secs
        2.2.2. $n_i.Time > n_{i-1}.Time$
    2.3. verify the block's difficulty based on it's timestamp and parent block's difficulty: $n_i.Difficulty = expectedDifficulty(n_i)$
    2.4. $n_i.gasLimit$ shouldn't overflow `2^63-1`
    2.5. $n_i.gasUsed <= n_i.gasLimit$
    2.6. checks gas limit:
        2.6.1. should be more than MinGasLimit: $n_i.gasLimit >= 5000$
        2.6.2. the change of $n_i$ gas should be bounded: $|parent.GasLimit - header.GasLimit| < parent.GasLimit / 1024$
    2.7. validate hard forks special fields, eg. every $n_i \epsilon [DAOForkBlock; DAOForkBlock+10]$ should have special value in `ExtraData` field 
    2.8. Verify a seal securing the block

#### Verify a seal of a block
The main improvement of ULC is that a client doesn't need to verify the seal of a block and can skip this step at all.

As it said the Ethereum code `light` (actually `fast` and `light`) client has `slow-but-light PoW verification`, but `full` has `fast-but-heavy`. The main difference is about that `full` client generates all the data needed to verify all block in an epoch, but light client calculates many values on-the-fly.

The detailed algorithm can be found on the [Ethereum wiki](https://github.com/ethereum/wiki/wiki/Ethash).

The verification has 2 steps: init caches and verify. Let's describe them in detail.

##### Init step
_All numbers below are given for the Epoch 232 (a current epoch at 12 Nov 2018)_
_Some parts of this step can be run in parallel._
_All numbers and the algorithm steps are from [geth code](https://github.com/ethereum/go-ethereum/blob/master/consensus/ethash/consensus.go#L239)_

It runs once per epoch: `epochLength = 30000 blocks ~ each 3.5 days = twice per week`

It needs to generate a verification matrix of pseudo-random values (called `cache`).

Calculate seedHash in `epochNumber steps = 232 sha3 operations`
Calculate the initial cache in:  `cacheSize/64 steps = 51641792/64 = 806900 sha3 operations`. `CacheSize` can be taken from [table `cacheSizes`](https://github.com/ethereum/go-ethereum/blob/master/consensus/ethash/algorithm.go#L821), for `epoch=232` it equals `51641792`.

At the end of the day $O_{cpu}(initStep)= N*O(sha3)$, where N is a current block number.

For example, for epoch 232 (a current epoch at 12 Nov 2018) $O_{cpu}(initStep) = O_{cpu}(seedHash)+O_{cpu}(initCahce) = 807133*O(sha3)$

This is theoretical lower bound. [Ethash article](https://github.com/ethereum/wiki/wiki/Ethash-Design-Rationale) mentioned that "a light client should be able to become fully operational and able to verify blocks within 40 seconds in Javascript".

##### Verify step
Light mode seal verification doesn't store the entire dataset for block verification, but generates nessusary items on the fly. For a single block it runs `hashimotoLight` algorythm that takes:

$generateDatasetItem = (2*sha3 + 512*fnv)$ 

_More details about FNV32-1 hash function can be found [here](https://en.wikipedia.org/wiki/Fowler%E2%80%93Noll%E2%80%93Vo_hash_function)._

$hashimotoLight = loopAccesses*mixBytes/hashBytes * (generateDatasetItem + fnvHash)$
$hashimotoLight = 64*128/64 *(generateDatasetItem + fnv)$
$hashimotoLight = 128*(generateDatasetItem + fnv)$
$hashimotoLight = 256 sha3 + 65664 fnv$

This is the difference between ULC and LES clients for each block. As far as each CHT is generated once per 32767 blocks the total difference is $[1; 32767] * Cost(hashimotoLight) = [256*O(sha3) + 65664*O(fnv) ; 8.388.352*O(sha3) + 2.151.612.288*O(fnv)]$. The growth is linear.

This is theoretical lower bound. As it said in [Ethash article](https://github.com/ethereum/wiki/wiki/Ethash-Design-Rationale) for a single block verification step should take `'0.1 seconds in Python'` in practice it takes `~200ms` in golang Geth code.

## LES vs ULC
So ULC saves `807133*O(sha3)` at init stage that happens each epoch and [256*O(sha3) + 65664*O(fnv) ; 8.388.352*O(sha3) + 2.151.612.288*O(fnv)] for each block while syncing. As far as difficulty of a block verification grows linear, the total difficulty of syncing N block grows as $N^2$.

## ULC in Roles
### Trusted LES servers
Trusted LES servers are needed only to send announcements (in Geth code it has name `announce(block hash, TD, number)`) to LES(ULC) clients. All announcements should be signed. Trusted servers don't know whether they have been chosen as trusted or not by any given client. Such servers can be started with an `onlyAnnounce` flag, which ensures that the LES server operates under the rule "only send announcements to my peers, do not process any other requests".

### LES servers (untrusted)
LES servers - usual LES servers, a header chain is synchronised with them. Helps to prevent attacks on trusted servers.

### ULC client
1. has some CHT root at the start; has a CHTs "chain", that can be synced from LES servers; CHT chain allows to request any historical information (block, transaction, receipt) from LES server
2. trusts to announcements, that receives from N Trusted LES servers. Announcements should be signed by Trusted LES servers. It should be at least M identical announcements to trust.
3. Asks for announcements with the biggest TD
4. ULC client starts CHT sync before syncing header chain. ULC client requests newer CHTs from LES servers.
5. requests headers from untrusted LES server, starting from `the highest block is known to latest CHT + 1` up to latest block number known from trusted announce
6. ULC client validates:
6.1. announcements checking are there M the same announcements from N received from Trusted LES servers
6.2. doesn't validate CHT, if we get incorrect CHT, it'll be clear later after receiving block headers.
6.3. validates headers, as usual, LES client except [VerifySeal](https://github.com/ethereum/go-ethereum/blob/master/consensus/ethash/consensus.go#L491). ULC doesn't run `VerifySeal` at all.

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

### Sybill attack on ULC (client)
Prevented because it is already prevented in a classic LES model and we only download headers with trusted announcements.

### Sybill attack on trusted servers
Even less possible than in LES model because it's needed to attack,k at least M servers.

### DoS on trusted servers
Possible. ULC makes it much less possible by hiding what nodes are trusted for each user. A user doesn't send any unusual for LES information to LES servers trusted or untrusted. Any trusted for a user LES server doesn't know that it has been chosen by the user to be trusted LES server.

### MITM
Prevented because all announcements must be signed by according LES server.

### What other security guarantees does ULC give and what is it comparable with?

#### Some math
There're 2 kinds of security guarantees:
1. reducing the probability of failure to perform a correct request due to the failure of remote servers - failure and censorship resistance
2. reducing the probability of trust in data coming from malicious nodes

The very mechanism of blockchain synchronisation of the ULC is the same as that of the LES. Therefore, comparing the security guarantees of ULC with full, fast and LES does not make sense. It is more important to compare the guarantees of a private RPC server or Infura with ULC.

If the probability of failure or hacking Infura or RPC server is taken as P, then with the ULC consensus M/N, the probability of its failure can be considered as Bernoulli process:

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

So ULC drastically increases censorship resistance of an Ethereum client. We can develop a far more reliable system using unreliable nodes.

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
ULC client needs a set of trusted LES servers to get the current Chain state. It should be said that only ULC client knows it's trusted list, LES servers don't know that has been chosen as trusted by someone ULC client. The only difference is ULC client request and accepts only signed announcements to trust nonce (PoW) without check.

We're going to provide, predefined in the App, a trusted LES servers list. This also means that an application wanting to use ULC can define their own such trusted list of clients and do load balancing with a simple random choice.

Here comes one of the LES problems is that LES server can handle a limited number of clients. At the moment it's $LES\_limit=25$.

So if we want 3(M) out of 4(N) ULC consensus, in avarage we have 1000 users online, so we need minimum $Servers=Max(AvarageUsers*N/LES\_limit; N)=Max(1000*4/25; 4)=160$

That was the reason why in ULC a new option was announced for LES server: `--onlyAnnounce`. It limits LES server to handle only `get announce` requests, but it increases the number of simultaneous users up to ~250 (should be stress tested).

With `--onlyAnnounce` the formule looks like:
$Servers=Max(AvarageUsers*N/LES\_only\_announce\_limit; N)=Max(1000*4/250; 4)=Max(16; 4)=16$

| Users online | N | Server w/o `onlyAnnounce` | With `onlyAnnounce` |
| ------- | ------- | ------- | ------- | 
| 1000    | 4    | 160    | 16 | 
| 1000    | 5    | 200    | 20 | 
| 1000    | 6    | 240    | 24 | 
| 1000    | 7    | 280    | 28 | 
| 5000    | 4    | 800    | 80 | 
| 5000    | 5    | 1000    | 100 | 
| 5000    | 6    | 1200    | 120 | 
| 5000    | 7    | 1400    | 140 | 
| 10000    | 4    | 1600    | 160 | 
| 10000    | 5    | 2000    | 200 | 
| 10000    | 6    | 2400    | 240 | 
| 10000    | 7    | 2800    | 280 | 

It's obvious that scaling due to server expansion inside the service is strictly limited. A prerequisite for the operation of ULC at large scales is an increase in the percentage of LES of servers relative to all Ethereum servers.

At the moment there are 15000 nodes. If 30% of them would use the LES server option, more than 300 000 ULC users could be handled simultaneously.

## Benchmarks
Our beta test showed that ULC sync is ~10x times [faster than LES](https://youtu.be/Z6UUT1TqdTs?t=623)

## Plans
### Short-Term
Status.im is going to start using ULC to achieve greater censorship resistance and enable all possible `web3` features for DApps and developers.

### Long-Term
* [On ULC incentives](https://hackmd.io/6IhsF6zRSqmtggvNnp1sHQ)
* Ethereum services are going to have microtransactions and it will make possible to make a market of LES server quotas using [LES service model](https://github.com/zsfelfoldi/ethereum-docs/blob/master/les/service_model.md#continous-auction)

[1]: https://wiki.parity.io/The-Parity-Light-Protocol-(PIP)
[2]: https://ethereum.github.io/yellowpaper/paper.pdf
