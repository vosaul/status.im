---
weight: 20
title: Tutorials
---

# Tutorials

## Overview

Just before we get started, it's well worth acquainting yourself with some of our terminology so you'll be able to make sense of it all. This anatomy establishes the different sections of the chat interface and establishes a common verbiage. The main components are:

* Message
* Input
* Keyboard
* Suggestions

![Chat Anatomy](images/chat-anatomy.png)

Please take some time to familiarize yourself with all the areas and the different configurations possible depending on what you want to do. Missing from the above is what we refer to throughout this documentation as the 'markup', by which we mean the mobile equivalent of the 'view', i.e. where the messages appear. 

Creating all of these native setups is totally possible through the API - just read on.

## Installing Status

OK, let's learn how to build our first DApp on Status (mobile-first ftw!). To progress further, you need to have Status running either:

* on a real phone,

* in an Android simulator, or

* in an iOS simulator.

You can go to [https://test.status.im](https://test.status.im) to download for Android. At the time of writing, we’re out of invitations for Testflight, but you can sign up for early iOS access [on our website](http://status.im).

If you don’t have a smartphone, or you only have an iPhone but want to get started right away, you can build Status yourself for either Android or iOS by following [these guidelines](https://wiki.status.im/contributing/development/building-status/). There, you will find instructions for installing an Android simulator, or starting up Status in the Xcode simulator. 

Our wiki guidelines should be all you need, but if you get lost come ask around in [our Slack](https://slack.status.im).

## Networking and Debugging

{{% tabs android-device genymotion %}}
{{% tab android-device %}}

First, connect your phone to your development machine. If you are using an android device, you can check that is is connected and then enable port forwarding on `5561` for the debug server.

```shell
# android only
adb devices
adb forward tcp:5561 tcp:5561

# more than one device connected?
adb -s DEVICE_ID forward tcp:5561 tcp:5561
```
 
![With your phone connected, /debug "On"](images/starting-a-dapp-on-status-with-frameworks_01.png)

*With your phone connected, /debug "On"*

You then need to open Status, navigate to `Console`, hit the `debug` suggestion and turn on the debugging server. You’ll get back a message telling you that debugging is on, and that you can use the [status-dev-cli](https://github.com/status-im/status-dev-cli) tools if you want. 

The important part of the message is your `device IP` address, which we'll be using throughout.

{{% /tab %}}

{{% tab genymotion %}}

1. Install genymotion
2. Create a genymotion virtual device
3. Switch to network bridge mode
4. Start device
5. Install status.im apk from nightly builds by dragging onto emulator window
6. Start status.im app on device
7. Turn on debugging in console (/debug). Record the ip address to use later as THE_DEVICE_IP. You should be able to ping this ip from your actual os
8. Forward port 5561 (use genymotion adb!): `/opt/genymotion/tools/adb forward tcp:5561 tcp:5561`
9. Serve your app over http
10. `status-dev-cli add [dapp]` where dapp is your json file with `whisper-identity` etc.

{{% /tab %}}

{{% /tabs %}}

To find out your computer's IP, use `ifconfig` from the command line and look for your internal IPv4 address:
```shell
ifconfig | grep inet

# Find the line beginning with just inet - this is your IPv4 address
inet 10.10.0.216 netmask 0xfffffe00 broadcast 10.10.1.255
```


## My First DApp

{{% tabs diy embark truffle %}}
{{% tab diy %}}
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
status-dev-cli add '{"whisper-identity": "hello-bot", "dapp-url": "http://<MACHINE-IP>:8080/", "name": "Hello"}' --ip <DEVICE-IP>
```
First, install the `status-dev-cli` tools globally using NPM.

Then, create a directory for your app to live in, switch into it, and create an `index.html` file and an `app.js` file.

The index.html will be really simple. We are going to add several meta tags to make our DApp look good on the small screens of mobile phones, and add a span that will be used by our JavaScript.

Our `app.js` file will also be simple. We are going to display the information about your account inside a span with `account id`. Status injects `web3.js` automatically, so you have an access to web3 variable from everywhere and you don’t need to care about including `web3.js` manually. However, you can do this and most probably you want to do this if you want to make your DApps work on other platforms.

You then need to install a really simple `http-server` from NPM, and start it in the `my-dapp` directory we just created.

Open a new terminal session, navigate back to your `my-dapp` directory, and go ahead and add your dapp to Status! Make sure to pass in the `--ip` flag using the address returned to you by Console, when you [enabled debugging](#enabling-debugging).

`<MACHINE-IP>` needs to be `localhost` or `127.0.0.1`, if you are using a simulator, or whatever your PC's (internal) IP is if you are using a connected phone.

That's it! You should be able to see your DApp in the chats, and opening it should browse automatically to a page that shows your account information. You can also do live-reloading once you're happy with this by running `status-dev-cli watch $PWD '{"whisper-identity": "hello-bot", "dapp-url": "http://<MACHINE-IP>:8080/", "name": "Hello"}' --ip <DEVICE-IP>`

* Known Issues

1) You may need to escape the `json` information you are passing into `status-dev-cli` if you are on a windows machine, like so: `status-dev-cli add '{\"whisper-identity\": \"my-dapp5\", \"dapp-url\": \"http://<MACHINE-ip>:8
080\",\"name\": \"My DApp\"}' --ip <DEVICE-IP>`

2) If using a real device, you also need to ensure that it is set to use MTP (media transfer Protocol) in the USB-debugging settings. Open the equivalent of your settings or develop options by pulling down the top menu and clicking in the debugging options.

Happy travels!

<aside class="success">
  You need not use NPM's http-server to serve content, there are innumerable ways of doing this. Just pick whatever is best for your environment.
</aside>

{{% /tab %}}

{{% tab truffle %}}

### Truffle

OK, so we can write a little HTML5 DApp that displays information to Status users through a simple webView component. However, we want to do so much more! We want to write smart contracts, deploy them, and interact with them through a fully mobile user interface; and we want to build decentralized chatbots that live within Status and make friends with all the humans.

If you want to get straight to making chatbots, please go [here](#my-first-1-1-chatbot).

Frameworks can lighten the load of developing considerably, and so we include here some quick examples to get you up and running with the two most popular Ethereum frameworks currently available - Truffle and Embark.

Firstly, we'll need a network to develop against, so let's go get `testrpc` - a neat little simulation of the rules and logic of the Ethereum network that runs much faster than the live network (because it's only simulating things) and is very useful for quick and dirty iterations.

```shell
npm install -g ethereumjs-testrpc
testrpc -p 8546

# If you use android
adb reverse tcp:8546 tcp:8546
```

That’s it! It will show you a list of available accounts, private keys, your HD wallet and mnemonic. Please note that we're running testrpc on (non-default) RPC port 8546, just to avoid potential conflict with the node running inside Status. If using android, you need to open the connection from your PC to your phone on that port, so Status can listen for changes there.

We also need to make sure that our Status client is listening to our new `testrpc` network, rather than Ropsten, so that we can get the information we need about our contracts etc. Luckily, this is as easy as running:

```shell
status-dev-cli switch-node http://localhost:8546

# Of course, there are options. You can use go-ethereum instead of TestRPC, and instead of port forwarding you can switch to any other accessible node using its IP address.
```

Open a new shell (i.e. a new Terminal window or tab) for the next part. You’ll leave `testrpc` running in the first window, and use the second window for the rest of the tutorial.

Now that you have `testrpc` is going, and a new shell is open, run:

```shell 
npm install -g truffle // Version 3.0.5+ required.
```

This installs the Truffle framework, and you can find its GitHub [page here](https://github.com/trufflesuite/truffle).

With Truffle installed, we can grab the Status Truffle Box, and get a basic DApp running. All the Truffle Boxes also include the app frameworks React and Redux, which were designed by Facebook and are widely used by app developers. You can find the other Truffle Boxes [here](https://truffle-box.github.io/).

To install the Status Truffle box, all you have to do is run this command in the same Terminal window:

```shell
git clone https://github.com/status-im/truffle-box-status.git

# Change into the truffle box directory and install the node dependencies
cd truffle-box-status && npm install

# Compile the contracts from Solidity (much like JavaScript) into runnable EVM code
 truffle compile
 
# Publish the compiled contracts to your network. testrpc must already be running
 truffle migrate
```

![Example on OS X: testrpc running on the left, and installing Truffle on the right](images/starting-a-dapp-on-status-with-frameworks_02.png)

*Example on OS X: testrpc running on the left, and installing Truffle on the right*

As you run the `migrate` command - which is what deploys your contracts to the network - you can look at the window with `testrpc` running, and you’ll see your transactions being published. If you get `Error: Invalid JSON RPC response`, you probably forgot to run `testrpc`.

If you're using an Android device, the application won't be accessible automatically, since it runs on port 3000 and your device/emulator knows nothing about it. Execute the following to make web application accessible:

```shell
adb reverse tcp:3000 tcp:3000
```

Now we are ready to see our DApp running on Status. From within your DApp directory, run:

```shell
# Run your Javascript
npm run start

#(Remember to set ENV variable if working with real device)
 IP=<IP_of_your_phone> npm run start
```

This should tell you that the the app is running, and that the DApp has been added to the Status Contacts.

![The DApp added to the default Contacts](images/starting-a-dapp-on-status-with-frameworks_03.png)

*The DApp added to the default Contacts*

Again, the DApp should appear in your chats screen, and navigating to it should automatically open a browser that reveals all the goodies hidden in this truffle box. It should also display the stored value of `5` from the SimpleStorage contract that we deployed to `testrpc` by running `truffle migrate` above.

If you would like to change the name that appears for your bot when it gets added to Status, simply edit the `package.json` and update the name there.

*Known problems:*

1) If you are running on a real iOS device, you need to configure Truffle Box to use the network on your computer. In `truffle.js`, change `host` to the IP of your computer:

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

{{% /tab %}}

{{% tab embark %}}

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
nano config/blockchain.json

# Now edit the 'Development' Network and change only the rpcPort field to 8546:

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

Open a new shell tab, navigate to the same DApp directory, and - after ensuring you Android device has access to `testrpc` - install Status Embark:

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

Also, you may need to tell Embark the IP of the DApp host if you're not using `localhost` as a default. Navigate to and change the `config/webserver.js` file so that it reflects your development machine's IP address:

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

The Embark console will appear within your shell with useful information about the SimpleStorage contract it has created, compiled, and deployed. Now just add your DApp, and have some fun!

```shell
status-dev-cli add '{"whisper-identity": "embark", "dapp-url": "http://<MACHINE-IP>:8000/", "name": "Embark"}' --ip <DEVICE-IP>
```

![](images/starting-a-dapp-on-status-with-frameworks_04.png)

![The Embark simulator runs in one Terminal window on the left, and the Embark console on the right](images/starting-a-dapp-on-status-with-frameworks_05.png)

*The Embark simulator runs in one Terminal window on the top, and the Embark console on the bottom*

*Known Issues:*

1) To deploy the DApp successfully on a device you may need to patch [this line](https://github.com/status-im/embark-status/blob/master/index.js#L13) in embark-status to include `+ " --dapp-port 5561"`.

{{% /tab %}}

{{% /tabs %}}

Using Status, you can now develop mobile DApps as easily as developing for MetaMask or Mist! But Status offers extra goodies as well.

In particular, Status will help you allow your users to chat with your DApp! The chat interface will let your users easily and intuitively accomplish tasks. In the future, your users will be able to hold group conversations where all the other participants are DApps, which is kind of amazing.

Later we’ll have an easy mechanism to make your DApp available for others to use on Status, but for now please just submit a pull request using our [guide on adding DApps](http://wiki.status.im/contributing/development/adding-dapps/).

## My First 1-1 Chatbot

Once you have worked through the first tutorials and understood the basic steps to building a DApp and adding it into Status, it's time to get our hands a little more dirty by actually writing a simple, one-response chatbot that will begin to utilise the awesome power of the Status API.

We kind of cheated a little in the previous tutorials. While it is totally possible to have your html5 DApp work perfectly in Status via `webView`, it's obviously not the most optimal way to do things. There are essentailly two different ways for developers to interact with Status, best illustrated by the Status Anatomy below:

![status-anatomy.png](images/status-anatomy.png)

The main take away here is that the chat context itself is actually an Otto VM jail that executes the javascript you write, and then integrates that directly with Status. So, we can actually write bots that are purely javascript-based. Please see [here](https://github.com/status-im/status-react/tree/develop/bots) for a full list of all our current bots and their source code.

{{% tabs diy embark truffle %}}
{{% tab diy %}}

### Do It Yourself

First, we're going to create a new `bots` directory and add file to keep our javascript in. 

```shell
cd ~
mkdir bots && cd bots && touch bot.js
```

Instead of adding a new DApp, we can now include a `bot-url` parameter in our call to `status-dev-cli`. The chatbot url targets a `js` file, and this file will be loaded in the Otto VM shown in the anatomy. Code in this file сan interact with the input field, messages and react however we program it to.

Add the following code snippet to the newly-created `bot.js` file.

```js
status.addListener("on-message-send", function (params, context) {
    var result = {
            err: null,
            data: null,
            messages: []
        };

    try {
        result["text-message"] = "You're amazing, master!";
    } catch (e) {
        result.err = e;
    }

    return result;
});
```

Then, navigate back to the `bots` directory, do the necessary Android steps if you are using that platform, and start the http server again. Then, open a new shell window and add your new bot. It's important to note a few things here. We are `add`ing a new new bot, rather than just watching the DApp we built earlier for changes. Also, we are only passing in a `bot-url`, rather than a `dapp-url` - this will ensure that, when you open your new bot contact, it won't automatically launch a browser a window.

```shell
#make sure you're in my-dapp or the equivalent
cd ..

#start the server and then open a new shell window
http-server
```

```shell
# android only
adb -s DEVICE_ID reverse tcp:8080 tcp::8080

status-dev-cli add '{"whisper-identity": "botler",  "name": "Botler" ,"bot-url": "http://<MACHINE-IP>:8080/bot.js"}' --ip <DEVICE-IP>
```

This is pretty much the simplest responsive chatbot we can write, using only the `addListener` function from the API. All it's listening for is a message-send event, to which it will try to respond with the test `You're amazing, master!`. You'll see that it opens a browse window by default, which is not desired behaviour and will be fixed in the next release. Just close the window and type a message to your new bot. 

Obviously, there's much more we can do than simply listen for messages and send flattering responses. All will be revealed in the next tutorial. If you're feeling impatient, you can find a full Demo Bot [here](https://github.com/status-im/status-react/tree/34b77022f7926dbabbb0e8c5e8471eaea5ed812f/bots/demo_bot).

{{% /tab %}}

{{% tab truffle %}}

### Truffle

OK, so even though `status-dev-cli` is lightweight and awesome, the frameworks offer some really cool features and make development significantly easier for many projects. So, let's see what it looks like to add the same, flattering little chatbot to Status through the Truffle Box we set up earlier. Navigate back to that directory, ensure that `testrpc` is switched on and that you have opened all the right ports if you're on Android.

```shell
# Android only
adb forward tcp:5561 tcp:5561

testrpc -p 8546

# Android only
adb reverse tcp:8546 tcp:8546

status-dev-cli switch-node "http://localhost:8546"

cd ~/truffle-box-status

# If you want to be extra sure your contracts are there, run:
truffle migrate --reset
```

Then, we need to make a new javascript file and put it in a place we can access in the browser. Copy the code provided into another `bot.js` file.

```shell
cd build/ && mkdir bot/
touch bot/bot.js
nano bot/bot.js
```

```js
status.addListener("on-message-send", function (params, context) {
    var result = {
            err: null,
            data: null,
            messages: []
        };

    try {
        result["text-message"] = "You're amazing, master!";
    } catch (e) {
        result.err = e;
    }

    return result;
});
```

This time, rather than running the `npm` task, we'll just start a quick server with `truffle` itself. Writing the correct `start` script is left as an exercise for the reader ;)

```shell
# Make sure you're in the truflle-box-status/ directory
cd ..

truffle serve

# In another shell
adb reverse tcp:8080 tcp:8080

status-dev-cli add '{"whisper-identity": "truffle-botler",  "name": "Truffle Botler", "bot-url": "http://<MACHINE-IP>:8080/bot/bot.js"}' --ip <DEVICE-IP>
```

And you're away! You should be able to see your DApp, browse to the same site as before, and chat with the repetitively flattering greeter bot.

{{% /tab %}}

{{% tab embark %}}

### Embark

First, go back to the `embark_demo/` directory we created [earlier](#my-first-dapp), where we set up the correct configuration for Embark and Status. Essentially, you just want to make sure - as with the Truffle Box example - that you put the javascript file in the right place so that you can reference it correctly.

{{% /tab %}}

{{% /tabs %}}


## My First Status Command

{{% tabs diy embark truffle %}}
{{% tab diy %}}

### Do It Yourself with `status-dev-cli`

So, we have set up Status in `debug` mode, added our DApp to it (hopefully run the `dapp watch` command to get some live-reloading going) and learned how to start a conversation with a simple javascript chatbot. Now it's time to start using the API proper and start using the provided commands to interact with our users and help them out.

Navigate back to your `bots` directory and open the `bot.js` file where we put the `status.addListener` function in the previous tutorials. We will again pass this fils in as a `bot-url` parameter to `status-dev-cli`, which will then execute the code in an Otto VM jail.

```shell
cd ~/bots/ && nano bot.js

# or use 'vi bot.js' if that's your preference
```

Then, open the file in the text editor of your choice and add in the code provided. All we want to do is provide our user with a command, called `hello` that they can issue into the chat and we can respond to. In order to achieve this effect, we set up a simple `status.command()` and pass in a name, title and description so as to identify our command and display it to the user, along with some helpful information about what it does.

We then set a color for the command to appear in set up our preview function. You can read about exactly what the preview function can achieve in the formal API specififcation but, in a nutshell, the preview defines what the user will see returned in the markup - i.e. where the messages appear. 

Here, we are creating a simple text response by setting up a variable that we pass to `status.components.text`, which the perceptive will notice is a React Native component - a whole bunch more of which are available and detailed in the formal specification. Beneath the text, we are creating a standard response of "Hello from the other side!", all of which will be returned as json to the markup. Note again the use of another React Native component - `status.components.view`.

```js
status.command({
     name: "hello",
     title: "HelloBot",
     description: "Helps you say hello",
     color: "#CCCCCC",
     preview: function (params) {
             var text = status.components.text(
                 {
                     style: {
                         marginTop: 5,
                         marginHorizontal: 0,
                         fontSize: 14,
                         fontFamily: "font",
                         color: "black"
                     }
                 }, "Hello from the other side!");

             return {markup: status.components.view({}, [text])};
         }
 });
```

Go ahead and serve your dapp again:

```shell
http-server

# In another shell if on android
adb -s DEVICE_ID reverse tcp:8080 tcp:8080

status-dev-cli watch $PWD '{"whisper-identity": "botler",  "name": "Botler" ,"bot-url": "http://<MACHINE-IP>:8080/bot.js"}' --ip <DEVICE-IP>
```

And there you go - we are now capable of greeting and interacting with our bot in two ways! You should be able to see your DApp, navigate to it, tap the new `/hello` command you see above the text input field and see your new Dapp respond. 

{{% /tab %}}

{{% tab truffle &}}

### Truffle

```shell
cd ~/truffle-box-status/build/bot/ && touch hello.js
nano hello.js
```

Navigate back to the truffle box  `build` directory and make a new file for us to write a command in that we can display through truffle. Place the same command provided above in that file.

```js
status.command({
     name: "hello",
     title: "HelloBot",
     description: "Helps you say hello",
     color: "#CCCCCC",
     preview: function (params) {
             var text = status.components.text(
                 {
                     style: {
                         marginTop: 5,
                         marginHorizontal: 0,
                         fontSize: 14,
                         fontFamily: "font",
                         color: "black"
                     }
                 }, "Hello from the other side!");

             return {markup: status.components.view({}, [text])};
         }
 });
```

This time, rather than running the `npm` task, we'll just start a quick server with `truffle` itself. Writing the correct `start` script is left as an exercise for the reader ;)

```shell
# Make sure you're in the truflle-box-status/ directory
cd ..

truffle serve

# In another shell
adb reverse tcp:8080 tcp:8080

status-dev-cli add '{"whisper-identity": "truffle-hello",  "name": "Truffle Greeter", "bot-url": "http://<MACHINE-IP>:8080/bot/truffle-hello.js"}' --ip <DEVICE-IP>
```


{{% /tab %}}

{{% tab embark %}}

### Embark


{{% /tab %}}

{{% /tabs %}}


## My First Interactive Suggestions Area

OK, so we can build up a basic command, show it to the user and have it do something (like return text) when the user taps it. That's great, but what happens if we want to be a bit more dynamic and interactive and suggest to our users a range of options to choose from when issuing the command?

{{% tabs diy embark truffle %}}
{{% tab diy %}}

### Do It Yourself with `status-dev-cli`

Let's go ahead and make that `hello` command we just created a little bit more clever.

```shell
cd ~/my-dapp/bot/ && nano hello.js
```
Instead of the preview parameter we used last time, let's build another `status.command()` and add in a `params` option with a `suggestions` object in it. This will create a suggestions area which - if you refer back to the [Chat Anatomy](#overview) - is what rolls up above the keyboard, such as you see when turning on the debugging server with the options `On` and `Off`.

```js
status.command({
     name: "greet",
     title: "Greeter",
     description: "Helps you say choose greetings",
     color: "#0000ff",
     params: [{
              name: "greet",
              type: status.types.TEXT
              suggestions: helloSuggestions
             }]
 })
```

"But wait!" we hear you cry, "what on earth is that `helloSuggestions` thing about?!". Well, let’s make a function to explain. This will return a `scrollView` with two suggestions: "Hello", and "Goodbye". Don’t get intimidated by the length, there’s actually not much to it.

First, we set up the helpers that will style the suggestion as it appears in the suggestions area.

```js
function suggestionsContainerStyle(suggestionsCount) {
    return {
        marginVertical: 1,
        marginHorizontal: 0,
        keyboardShouldPersistTaps: true,
        height: Math.min(150, (56 * suggestionsCount)),
        backgroundColor: "white",
        borderRadius: 5,
        flexGrow: 1
    };
}
var suggestionSubContainerStyle = {
    height: 56,
    borderBottomWidth: 1,
    borderBottomColor: "#0000001f"
};

var valueStyle = {
    marginTop: 9,
    fontSize: 14,
    fontFamily: "font",
    color: "#000000de"
};
```

Now, we need to write the main star of our show - that mysterious `helloSuggestions` function we passed into the `params` of our `status.command()`. The objective here is to return two touchable buttons - one for `Hello` and the other for `Goodbye`. We are making quite extensive use of React native Components here, so we expect at least some level of familiarity with the framework in order to get the most out of these tutorials.

```js
function helloSuggestions() {
    var suggestions = ["Hello", "Goodbye"].map(function(entry) {
        return status.components.touchable(
            {onPress: [status.events.SET_VALUE, entry]},
            status.components.view(
                suggestionContainerStyle,
                [status.components.view(
                    suggestionSubContainerStyle,
                    [
                        status.components.text(
                            {style: valueStyle},
                            entry
                        )
                    ]
                )]
            )
        );
    });

    // Let's wrap those two touchable buttons in a scrollView
    var view = status.components.scrollView(
        suggestionsContainerStyle(2),
        suggestions
    );

    // Give back the whole thing inside an object.
    return {markup: view};
}
```

The main point of this example is that your `suggestions` parameter should accept users’ input, and then return a component to be rendered.

We have already added this contact to Status, so let's se if we can set up our environment to do some live reloading so that we don't have to revert to the cli every time we want to change something in the process of building all the new things.

```shell
status-dev-cli watch $PWD '{"whisper-identity":"hello-bot", "dapp-name":"Hello", "bot-url":"http://localhost:8080/bot/hello.js"}' --ip <DEVICE-IP>
```

You can also work with the `suggestionsTrigger` parameter. Now that we’ve covered `params` and the possibility of `suggestions`, it’s easy to see that `suggestionsTrigger` will take a string corresponding to an event that, when triggered, will show all your `suggestions`. If you don’t include this parameter, the default is "on-change", so your suggestions will show when your users selects the command.

It's also worth knowing about the `fullscreen` option. If your command has `suggestions`, this `param` controls whether that list of suggestions expands to fill the entire screen. If your command has a lot of suggestions, you might want to set `fullscreen` to `true`, so that your users don’t have to pull the list upwards. On the other hand, if your command has only a few suggestions and you set `fullscreen` to `true`, your users will have to pull the list downwards to keep it from hiding the screen. Choose whichever will be most convenient to your users, considering your command’s suggestions.

{{% /tab %}}

{{% tab truffle &}}

### Truffle


{{% /tab %}}

{{% tab embark %}}

### Embark


{{% /tab %}}

{{% /tabs %}}

For another full example of an interactive suggestion area, please take a look over our [Demo Bot](https://github.com/status-im/status-react/blob/develop/bots/demo_bot/bot.js), which makes prominent use of the `defineSubscription` method from the API and may be helpful for those looking to waork with things like the `status.component.slider` React Native Component.

You could also build a location bot following a similar pattern. We provide the code for you, just because we can. See if you can get it all working right this time...

```js
I18n.translations = {
    en: {
        location_title: 'Location',
        location_suggestions_title: 'Send location',
        location_description: 'Share your location',
        location_address: 'address'
}}

status.command({
    name: "location",
    title: I18n.t('location_title'),
    description: I18n.t('location_description')
    hideSendButton: true,
    sequentialParams: true,
    params: [{
        name: "address",
        type: status.types.TEXT,
        placeholder: I18n.t('location_address')
    }]
 })
 ```
 
 Or, even better, can you get some location suggestions to display?
 
 ```js
 function locationsSuggestions (params) {
    var result = {title: "Send location"};
    var seqArg = params.seqArg ? params.seqArg : "";

    if (seqArg == "Dropped pin")
    {
        result.markup = ["view", {}, ["text", {}, "Dropped pin" + seqArg]];
    }
    else if (seqArg != "")
    {
        result.markup = ["view", {}, ["text", {}, "Let's try to find something " + seqArg]];
    }
    else
    {
        result.markup = ['current-location', {showMap: true}];
    }

    return result;
}
```
