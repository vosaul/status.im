---
weight: 20
title: Frameworks
---

# Frameworks (Truffle / Embark)

*(warning: the Truffle/Embark functionality is still a work in progress. Come ask in the [Slack](http://slack.status.im) if you hit bumps!)*

## Introduction

In this tutorial, we’ll use the Truffle and Embark frameworks to create a basic DApp ready for further development, and we’ll deploy it on mobile using Status. After we’re done, you’ll be ready to continue developing your DApp, and when you eventually go live, your users will be able to access your DApp by browsing through the Status app, the Chrome MetaMask extension, or the Ethereum Mist browser. One development process, three ways of accessing your DApp!

## Overview

Broadly speaking, for both Truffle and Embark, you’ll get the Status app running and connected to your computer, either on a simulator or on a real phone. Next, you’ll install some necessary dependencies. Then, you’ll start testrpc, a mini-Ethereum network that runs on your computer. Finally, you’ll install the Status Truffle box or the Status Embark plugin, create a basic demo app, and add it to Status.

This is what we're going to go through:

* [Installing Git, Node, and NPM](#installing-git-node-and-npm)
* [Installing testrpc](#installing-testrpc)
* [Creating a DApp using Truffle](#creating-a-dapp-using-truffle)
* [Creating a DApp using Embark](#creating-a-dapp-using-embark)

In order to install Status and enable debugging, please see the first of the [tutorials](#installing-status) [above](#enabling-debugging)

## Networking

### iPhone
If you're running Status on an real iPhone (not simulator), you will need to know the IP of both your computer and your phone.

To find phone's IP, go to Status Console and set `/debug` to `On`.

To find out your computer's IP, use `ifconfig` and look for the IP on the line starting with `inet`

    ifconfig en0     # OS X
    ifconfig eth0    # Linux

      en0: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
        ether d2:b6:39:f5:59:1f
        inet6 fe80::898:6cbd:e58:a6a7%en0 prefixlen 64 secured scopeid 0x4
    --> inet 192.168.123.101 netmask 0xffffff00 broadcast 192.168.123.255
        nd6 options=201<PERFORMNUD,DAD>
        media: autoselect
        status: active

(If you have more than one network adapter, try just `ifconfig` and look for the right one.)

<aside class="warning">Node module `truffle-box-status` relies on `status-dev-cli` which has a hardcoded value of `localhost` as the host of the DApp: <a href="https://github.com/status-im/status-dev-cli/blob/7b51136d8d0dc7b0a95136e6489c34870f925e4b/index.js#L33">(see github)</a>. This should be fixed to be configurable.</aside>

### Android

On Android, you will not need to explicitly set IPs, but you need to tunnel the `testrpc` port the DApp server by doing:

    adb reverse tcp:8546 tcp:8546

    adb reverse tcp:3000 tcp:3000

## Installing Git, Node, and NPM

We’ll use the version control tool Git to install the Truffle and Embark frameworks. If you have Xcode installed, Git is probably already installed. To see if it’s installed, open Terminal or any command line program and just enter `git`. You should see a list of common Git commands. If you don’t, you can install Git with [these instructions](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

We will also need __node__ (Node.js) and __npm__ (Node Package Manager) to install some dependencies, so make sure you have the latest versions installed. In particular, `testrpc` will complain if you don’t have at least Node 6.9.1.

On OS X, the easiest way to install node & npm is with [Homebrew](https://brew.sh). You can run `brew install node`, and then check the version with `node --version`. Npm is installed with node, but updated more often so it's good to update it with `npm install npm@latest -g`.

## Installing testrpc

To install testrpc, you just need to enter this on your command line:

    npm install -g ethereumjs-testrpc

What’s `testrpc`? When you deploy your DApp, you are asking the Ethereum network to create an address for it. When you use your DApp, you pay the Ethereum network to execute your code. Your DApps talk to the Ethereum network through remote procedure calls, or RPC’s.

`testrpc` is a local network that makes this whole process very fast and you don't have to spend ether with real value, so that it’s easy to develop your DApps. Essentially, `testrpc` gives you a small Ethereum network on your computer.

For more about gas and ether, see the top answer on this [StackExchange question](http://ethereum.stackexchange.com/questions/3/what-is-gas-and-transaction-fee-in-ethereum).

## Creating a DApp using Truffle

While the steps up until now apply to using both Truffle and Embark, now we’ll cover steps specific to each framework. Let’s start with Truffle. If you just want to use Embark, you can skip to the next section.

### Running testrpc

Open Terminal or any command line program and enter the command:

`testrpc -p 8546`

We're running testrpc on (non-default) RPC port 8546, just to avoid potential conflict with the node running inside Status.

That’s it! It will show you a list of available accounts, private keys, Wallet, and mnemonic.

Now open a new shell (such as a new Terminal window or tab) for the next part. You’ll leave testrpc running in the first window, and use the second window for the rest of the tutorial.

### Installing Truffle

Now that you have `testrpc` running, and a new shell open, you’ll run:

    npm install -g truffle // Version 3.0.5+ required.

This installs the Truffle framework, and you can find its GitHub [page here](https://github.com/trufflesuite/truffle).

With the Truffle framework installed, we can grab the Status Truffle Box, and get a basic DApp running. All the Truffle boxes also include the app frameworks React and Redux, which were designed by Facebook and are widely used by app developers. You can find the other Truffle [boxes here](https://truffle-box.github.io/), but for this tutorial you should use the Status Truffle Box, because it’s set up to be added to Status.

To install the Status Truffle box, all you have to do is run this command in the same Terminal window:

    git clone https://github.com/status-im/truffle-box-status.git

With the Status Truffle box successfully cloned, let’s walk through the next steps of running your DApp.

    # Change into the truffle box directory
    cd truffle-box-status

    # install the node dependencies
     npm install

![Example on OS X: testrpc running on the left, and installing Truffle on the right](images/starting-a-dapp-on-status-with-frameworks_02.png)

*Example on OS X: testrpc running on the left, and installing Truffle on the right*

    # Compile the contracts from Solidity (much like JavaScript) into
    # runnable EVM code
     truffle compile

    # Publish the compiled contracts to your network. testrpc must
    # already be running
     truffle migrate

As you run the `migrate` command, you can look at the window with `testrpc` running, and you’ll see your transactions being published to your local network. If you get `Error: Invalid JSON RPC response`, you probably forgot to run `testrpc`.

### Running our Truffle DApp on Status

If you are running on a real iOS device, you need to configure Truffle Box to use the network on your computer. In `truffle.js`, change `host` to the IP of your computer:

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


Now we are ready to see our DApp running on Status.

From within your DApp directory, run:

    # Run the server
     npm run start

    # Run the server (iOS real device)
     IP=<IP_of_your_phone> npm run start

This should tell you that the the app is running, and that the DApp has been added to the Status Contacts.

![The DApp added to the default Contacts](images/starting-a-dapp-on-status-with-frameworks_03.png)

*The DApp added to the default Contacts*

After you’ve clicked on your DApp within Status, you’ll see that the chat area at the bottom shows `/browse http://<IP_of_your_computer>:3000/` on iOS, and `/browse http://localhost:3000/` for Android.

In fact, you can also browse to that address from Console with the command `/browse`, just like you could browse to any other web address inside Status. You can also enter that address into your browser, and you’ll see the same thing.

## Creating a DApp using Embark

Now that we’ve covered Truffle, let’s take a look at Embark.

### Installing Embark and Starting the Network

Now that you have Status running and your dependencies installed, you’ll run:

    npm -g install embark

This installs the Embark framework, and you can find its GitHub [page here](https://github.com/iurimatias/embark-framework).

With the Embark framework installed, we can make a demo DApp:

    embark demo

    #change into the directory
    cd embark_demo

Next we want to run the network. You can run a full Ethereum node with `embark blockchain`, but for development you probably want to run `testrpc` with:

    embark simulator

### Configuring our Embark DApp for Status

Now we are almost ready to see our DApp running on Status — this part is short and easy. Open a new shell tab in the same DApp directory, and run:

    npm install embark-status --save

On a real iPhone, you need to insert its IP into two config files.

Open the file `embark.json` and edit the `plugins` key. If your phone's IP is `192.168.123.102`, it would look like this:

    "plugins": {
        "embark-status": {
          "deviceIp": "your-device-ip",
          "whisperIdentity": "dapp-embark-test",
          "name": "MyEmbarkDapp"
        }
      }

Also, you need to tell Embark the IP of the DApp host. If your computer's IP is 192.168.123.101, then `config/webserver.js` would look like:

    {
      "enabled": true,
      "host": "192.168.123.101",
      "port": 8000
    }


Finally, if you’re running Status on Android, enable port forwarding with:

    adb forward tcp:5561 tcp:5561

### Running the DApp

Now we’re ready to run the DApp on Status. From within your DApp directory, run:

```bash
# start your DApp
embark run
```

The Embark console will appear within your shell with useful information about the SimpleStorage contract it has created, compiled, and deployed. It will also tell you that the DApp has been added to Status!

![](images/starting-a-dapp-on-status-with-frameworks_04.png)

![The Embark simulator runs in one Terminal window on the left, and the Embark console on the right](images/starting-a-dapp-on-status-with-frameworks_05.png)

*The Embark simulator runs in one Terminal window on the top, and the Embark console on the bottom*

<aside class="warning">To deploy the DApp on the device we need to <a href="https://github.com/status-im/embark-status/blob/master/index.js#L13">patch this line in embark-status</a> to include `--dapp-port 5561`.</aside>

You should be able to tap the Contacts tab within Status and see your DApp there. After you’ve clicked on your DApp within Status, you’ll see that the chat area at the bottom shows `/browse http://192.168.123.101:8000/` for a real iOS device, and `/browse http://localhost:3000/` for Android.

In fact, you can also browse to that address from Console with the command `/browse`, just like you could browse to any other web address inside Status. You can also enter that address into your browser, and you’ll see the same thing.

## You’re Off to the Races

Using Status, you can now develop mobile DApps as easily as developing for MetaMask or Mist! But Status offers extra goodies as well.

In particular, Status will help you allow your users to chat with your DApp! The chat interface will let your users easily and intuitively accomplish tasks. In the future, your users will be able to hold group conversations where all the other participants are DApps, which is kind of amazing.

Later we’ll have an easy mechanism to make your DApp available for others to use on Status, but for now please just submit a pull request using our [guide on adding DApps](http://wiki.status.im/contributing/development/adding-dapps/).
