---
weight: 20
title: Tutorials
---

# Tutorials

## Installing Status

OK, let's learn how to build our first DApp on Status (mobile-first ftw!). To progress further, you need to have Status running either:

* on a real phone,

* in an Android simulator, or

* in an iOS simulator.

You can go to [https://test.status.im](https://test.status.im) to download for Android. At the time of writing, we’re out of invitations for Testflight, but you can sign up for early iOS access [on our website](http://status.im).

If you don’t have a smartphone, or you only have an iPhone but want to get started right away, you can build Status yourself for either Android or iOS by following [these guidelines](https://wiki.status.im/contributing/development/building-status/). There, you will find instructions for installing an Android simulator, or starting up Status in the Xcode simulator. 

Our wiki guidelines should be all you need, but if you get lost come ask around in [our Slack](https://slack.status.im).

## Networking and Debugging

First, connect your phone to your development machine. If you are using an android device, you can check that is is connected and then enable port forwarding on `5561` for the debug server.

```shell
* android only
adb devices
adb forward tcp:5561 tcp:5561

** more than one device connected?
adb -s DEVICE_ID forward tcp:5561 tcp:5561
```
 
![With your phone connected, /debug "On"](images/starting-a-dapp-on-status-with-frameworks_01.png)

*With your phone connected, /debug "On"*

You then need to open Status, navigate to `Console`, hit the `debug` suggestion and turn on the debugging server. You’ll get back a message telling you that debugging is on, and that you can use the [status-dev-cli](https://github.com/status-im/status-dev-cli) tools if you want. 

The important part of the message is your `device IP` address, which we'll be using throughout.

To find out your computer's IP, use `ifconfig` from the command line and look for your internal IPv4 address:
```shell
ifconfig | grep inet

# Find the line beginning with just inet - this is your IPv4 address
inet 10.10.0.216 netmask 0xfffffe00 broadcast 10.10.1.255
```


## My First DApp

### Do It Yourself with `status-dev-cli`

```shell
npm install -g status-dev-cli
mkdir my-dapp && cd my-dapp
touch index.html app.js
```
> In index.html, add: 

```html
<html>
<head>
 <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
 <meta name="HandheldFriendly" content="True">
 <meta name="MobileOptimized" content="320">
 <meta name="viewport" content="width=device-width,minimum-scale=1,maximum-scale=1">
 <title>My DApp</title>
 <script src="app.js"></script>
</head>
<body>
 <h1>Hello world!</h1>
 Web3 account: <span id="account"></span>
</body>
</html>
```
> In app.js, add:  

```js
function onContentLoaded() {
  var accountSpan = document.getElementById("account");
  accountSpan.innerHTML = 
    (typeof web3 === "undefined" ? "undefined" : web3.eth.accounts);
}
document.addEventListener("DOMContentLoaded", onContentLoaded);
```

> Install and start an HTTP server - we recommend NPM for ease-of-use. Make sure you are still in your my-dapp directory when running the 2nd command.  

```shell
npm install http-server -g
http-server
```

> In a new terminal window run the port forwarding and DApp connection stuff. It is important to pass in the `--ip` flag with the IP address listed by Console once you have selected the `debug` option and turned it on. You should already have enabled adb port forwarding on 5561 if you are using an Android device.

```shell
status-dev-cli add-dapp '{"whisper-identity": "my-dapp", "dapp-url": "http://<Your IP>:8080/", "name": "My DApp"}' --ip <IP listed in Status console>
```
First, install the `status-dev-cli` tools globally using NPM.

Then, create a directory for your app to live in, switch into it, and create an `index.html` file and an `app.js` file.

The index.html will be really simple. We are going to add several meta tags to make our DApp look good on the small screens of mobile phones, and add a span that will be used by our JavaScript.

Our `app.js` file will also be simple. We are going to display the information about your account inside a span with `account id`. Status injects `web3.js` automatically, so you have an access to web3 variable from everywhere and you don’t need to care about including `web3.js` manually. However, you can do this and most probably you want to do this if you want to make your DApps work on other platforms.

You then need to install a really simple `http-server` from NPM, and start it in the `my-dapp` directory we just created.

Open a new terminal session, navigate back to your `my-dapp` directory, and go ahead and add your dapp to Status! Make sure to pass in the `--ip` flag using the address returned to you by Console, when you [enabled debugging](#enabling-debugging).

`<Your-IP>` needs to be `127.0.0.1` if you are using a simulator, or whatever your PC's (internal) IP is if you are using a connected phone.

That's it! You should be able to see your DApp in the chats, and opening it should browse automatically to a page that shows your account information. You can also do live-reloading once you're happy with this by running `status-dev-cli watch-dapp . '{"whisper-identity": "my-dapp"}'`

Happy travels!

<aside class="success">
  You need not use NPM's http-server to serve content, there are innumerable ways of doing this. Just pick whatever is best for your environment.
</aside>

### Truffle

OK, so we can write a little HTML5 DApp that displays information to Status users through a simple webView component. However, we want to do so much more! We want to write smart contracts, deploy them, and interact with them through a fully mobile user experience; and we want to build decentralized chatbots that live within Status and make friends with all the human users.

If you want to get straight to making chatbots, please go [here](#my-first-command).

Frameworks can lighten the load of developing considerably, and so we include here two quick examples to get you up and running with the two most popular Ethereum frameworks currently available - Truffle and Embark.

Firstly, we'll need an Ethereum network to develop against, so let's go get `testrpc` - a neat little simulation of the rules and logic of the Ethereum network that runs much faster than the live network (because it's only simulating things) and is very useful to develop against.

```shell
npm install -g ethereumjs-testrpc
testrpc -p 8546

# If you use android
adb reverse tcp:8546 tcp:8546
```

We're running testrpc on (non-default) RPC port 8546, just to avoid potential conflict with the node running inside Status. If using android, you need to open the connection from your PC to your phone on that port, so Status can listen for changes there.

We also need to make sure that our Status client is listening to our new `testrpc` network, rather than Ropsten so that we can get the information we need about our contracts etc. Luckily, this is as easy as running:

```shell
status-dev-cli switch-node http://localhost:8546

# Of course, there can be options. You can use go-ethereum instead of TestRPC, and instead of port forwarding you can switch to any other accessible node using its IP address.
```

That’s it! It will show you a list of available accounts, private keys, your HD wallet and mnemonic.

Open a new shell (such as a new Terminal window or tab) for the next part. You’ll leave `testrpc` running in the first window, and use the second window for the rest of the tutorial.

Now that you have `testrpc` is going, and a new shell is open, run:

```shell 
npm install -g truffle // Version 3.0.5+ required.
```

This installs the Truffle framework, and you can find its GitHub [page here](https://github.com/trufflesuite/truffle).

With Truffle installed, we can grab the Status Truffle Box, and get a basic DApp running. All the Truffle boxes also include the app frameworks React and Redux, which were designed by Facebook and are widely used by app developers. You can find the other Truffle Boxes [here](https://truffle-box.github.io/).

To install the Status Truffle box, all you have to do is run this command in the same Terminal window:

```shell
git clone https://github.com/status-im/truffle-box-status.git

# Change into the truffle box directory and install the node dependencies
cd truffle-box-status && npm install
```

![Example on OS X: testrpc running on the left, and installing Truffle on the right](images/starting-a-dapp-on-status-with-frameworks_02.png)

*Example on OS X: testrpc running on the left, and installing Truffle on the right*

```shell
# Compile the contracts from Solidity (much like JavaScript) into runnable EVM code
 truffle compile
 
# Publish the compiled contracts to your network. testrpc must already be running
 truffle migrate
```

As you run the `migrate` command - which is what deploys your contracts to the network - you can look at the window with `testrpc` running, and you’ll see your transactions being published. If you get `Error: Invalid JSON RPC response`, you probably forgot to run `testrpc`.

If you're using an Android device, the application won't be accessible automatically, since it runs on port 3000 and your device/emulator knows nothing about it. Execute the following to make web application accessible:

```shell
adb reverse tcp:3000 tcp:3000
```

Now we are ready to see our DApp running on Status. From within your DApp directory, run:

```shell
# Run the server
npm run start

#(Remember to set ENV variable if working with real device)
 IP=<IP_of_your_phone> npm run start
```

This should tell you that the the app is running, and that the DApp has been added to the Status Contacts.

![The DApp added to the default Contacts](images/starting-a-dapp-on-status-with-frameworks_03.png)

*The DApp added to the default Contacts*

Again, the DApp should appear in your chats screen, and navigating to it should automatically open a browser that reveals all the goodies hidden in this truffle box. It should also display the stored value of `5` from the SimpleStorage contract that we deployed to `testrpc` by running `truffle migrate` above.

*Known problems:*

1) `status0dev-cli` currently has a hard-coded value for `localhost`, rather than allowing dynamic inputs. We are working on a fix, but - depending on your setup - you may need to change this for everything to work smoothly. Do this simply by executing:

```shell
cd node_modules/status-dev-cli/ && nano index.js
```

and change lines 13 and 33 to reflect the correct IP address of your machine.

2) If you are running on a real iOS device, you need to configure Truffle Box to use the network on your computer. In `truffle.js`, change `host` to the IP of your computer:

```js
module.exports = {
  migrations_directory: "./migrations",
  networks: {
    development: {
      host: "<IP_of_your_computer>",
      port: 8546,
      network_id: "*" // Match any network id
    }
  }
};
``` 

### Embark

OK, so Truffle is not your favourite and you prefer using Embark. Fine with us. As always, make sure you have installed the framework first.

```shell
npm -g install embark
```

Embark makes it super easy to set up a demo and get up and running fast:

```shell
embark demo
cd embark_demo
```

Next we want to start the network. You can run a full Ethereum node with `embark blockchain`, but for development you probably want to run `testrpc`. We want it to run on port 8546 though, so it doesn't interfere with Status, so we need to edit the `blockchain.js`:

```shell
cd embark_demo/config/ && nano blockchain.json

# Now edit the 'Development' Network to read:

"development": {
    "enabled": true,
    "networkType": "custom",
    "genesisBlock": "config/development/genesis.json",
    "datadir": ".embark/development/datadir",
    "mineWhenNeeded": true,
    "nodiscover": true,
    "maxpeers": 0,
    "rpcHost": "localhost",
    "rpcPort": 8546,
    "rpcCorsDomain": "http://localhost:8000",
    "account": {
      "password": "config/development/password"
    }
  }
  
# ctrl+O will write your changes to file, ctrl+X will exit the file.
# Now, navigate back to the root of your project and start testrpc

cd .. && embark simulator
```

Open a new shell tab, navigate to the same DApp directory, and - after the usual Android extras - install Status Embark:

```shell
# Android only 
adb reverse tcp:8546 tcp:8546 

npm install embark-status --save
```

When using a real device, you will now need to insert the relevant IP into two config files.

Open the file `embark.json` and edit the `plugins` key to reflects your DEVICE's IP address:

```js
"plugins": {
  "embark-status": {
    "deviceIp": "<your-device-ip>",
    "whisperIdentity": "dapp-embark-test",
    "name": "MyEmbarkDapp"
  }
}
```

Also, you need to tell Embark the IP of the DApp host. Navigate to and change the `config/webserver.js` file so that it reflects your development machine's IP address:

```js
{
  "enabled": true,
  "host": "<your-machines-ip>",
  "port": 8000
}
```

If you’re running Status on Android, remember to give your device access to the right ports again:

```shell
adb reverse tcp:8000 tcp:8000
```

Now we’re ready to run the DApp on Status. From within your DApp directory, run:

```shell
embark run
```

The Embark console will appear within your shell with useful information about the SimpleStorage contract it has created, compiled, and deployed. It will also tell you that the DApp has been added to Status!

![](images/starting-a-dapp-on-status-with-frameworks_04.png)

![The Embark simulator runs in one Terminal window on the left, and the Embark console on the right](images/starting-a-dapp-on-status-with-frameworks_05.png)

*The Embark simulator runs in one Terminal window on the top, and the Embark console on the bottom*

*Known Issues:*

1) To deploy the DApp successfully on a device you may need to patch [this line](https://github.com/status-im/embark-status/blob/master/index.js#L13) in embark-status to include `+ " --dapp-port " + 5561`.

