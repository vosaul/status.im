---
id: access_eth_provider
title: Accessing an Ethereum Provider
---
# The Decentralized Web Awaits You...

The pattern of full provider auto-injection followed by the previous generation of Ethereum-enabled DOM environments fails to protect user privacy and fails to ensure a safe user experience: untrusted websites can both view account information and arbitrarily initiate transactions on a user's behalf. Even though most users may reject unsolicited transactions on untrusted websites, a protocol for provider exposure should make such unsolicited requests impossible.

In order to access an Ethereum provider (especially after November 2, 2018), you will need to request permission from the user, rather than automatically injecting `web3` into the page.

You can read the full rationale on [our blog](https://our.status.im/breaking-change-to-the-status-browser/).

### Include the web3.js Library in Your Project

This can be done different ways depending on the structure of your project and the flavour of JS you happen to be using. Most often it looks something like this:

`import Web3 from 'web3'`

### Create a New Web3 Object

After importing `Web3` from the library you're using, you need to make sure it is instantiated for that page/app:

`web3 = new Web3(ethereum)`

### Request Full Access to the Provider

```js
window.addEventListener('load', async () => {
    // Read-only provider is exposed by default
    console.log(await ethereum.send('net_version'));
    try {
        // Request full provider if needed
        await ethereum.enable();
        // Full provider exposed
        web3.eth.sendTransaction(transactionObject [/* ... */]);
    } catch (error) {
        // User denied full provider access
    }
});
```

Note the read-only provider in the first line, which is exposed by default. Accessing the user's address and initiating transactions or signing messages requires the `ethereum.enable()` call to be accepted by the user.

Further details around the structure we have all settled on together can be found in [EIP 1102](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1102.md). You can see that they suggest there using `await ethereum.send('eth_sendTransaction', [/* ... */]);` but we like handling things as above as we feel there is less room for error. Constructing the `transactionObject` is, again, heavily dependent on what you're trying to do, but here is a super simple example of what it might look like if you just plugged the required values straight in:

```js
// using the promise
web3.eth.sendTransaction({
    from: '0xde0B295669a9FD93d5F28D9Ec85E40f4cb697BAe',
    to: '0x11f4d0A3c12e86B4b5F39B213F7E19D048276DAe',
    value: '1000000000000000',
    gas: gasLimit // use web3.eth.estimateGas() to get this amount, and add a little for extra safety.
})
.then(function(receipt){
    ...
});
```





