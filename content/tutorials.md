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

{{% tabs diy embark truffle %}}
{{% tab diy block %}}
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

{{% /tab %}}

{{% tab truffle none %}}
### Truffle

OK, so we can write a little HTML5 DApp that displays information to Status users through a simple webView component. However, we want to do so much more! We want to write smart contracts, deploy them, and interact with them through a fully mobile user interface; and we want to build decentralized chatbots that live within Status and make friends with all the humans.

If you want to get straight to making chatbots, please go [here](#my-first-status-command).

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

1) `status-dev-cli` currently has a hard-coded value for `localhost`, rather than allowing dynamic inputs. We are working on a fix, but - depending on your setup - you may need to change this for everything to work smoothly. Do this simply by executing:

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
{{% /tab %}}

{{% tab embark none %}}
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

The Embark console will appear within your shell with useful information about the SimpleStorage contract it has created, compiled, and deployed. Now just add your DApp, and have some fun!

```shell
status-dev-cli add-dapp '{"whisper-identity": "embark", "dapp-url": "http://<MACHINE-IP>:8000/", "name": "Embark"}' --ip <DEVICE-IP>
```

![](images/starting-a-dapp-on-status-with-frameworks_04.png)

![The Embark simulator runs in one Terminal window on the left, and the Embark console on the right](images/starting-a-dapp-on-status-with-frameworks_05.png)

*The Embark simulator runs in one Terminal window on the top, and the Embark console on the bottom*

*Known Issues:*

1) To deploy the DApp successfully on a device you may need to patch [this line](https://github.com/status-im/embark-status/blob/master/index.js#L13) in embark-status to include `+ " --dapp-port 5561"`.

{{% /tab %}}
{{% /tabs %}}

## My First Status Command

```js
function sayHello() {
 status.command({
     name: "hello",
     title: "HelloBot",
     description: "Helps you say hello",
     color: "#7099e6",
 });
}
```

Once you have worked through the first tutorials and understood the basic steps to building a DApp and adding it into Status, it's time to get our hands a little more dirty by actually writing some real commands that will begin to utilise the awesome power of the Status API. It's time to make use of the API proper in order to build a decentralized chatbot that leverages Status' awesome mobile interface, so that we can take your DApp to the next level.

We kind of cheated a little in the previous tutorials. While it is totally possible to have your html5 DApp work perfectly in Status via `webView`, it's obviously not the most optimal way to do things. We use [ClojureScript](http://www.braveclojure.com/introduction/) and React Native to handle all our things, but you don't have to. The main take away here is that the chat context itself is actually an Otto VM jail that executes the javascript you write, and then integrates that directly with Status. So, we can actually write bots that are purely javascript-based. Please see [here](https://github.com/status-im/status-react/tree/develop/bots) for a full list of all our current bots and their source code.

Please take a moment to familiarise yourself with the anatomy of Status so that you can get a visual sense of what is happening where and how you can best utilise it all.

![status-anantomy.png](https://github.com/status-im/docs.status.im/blob/develop/static/images/status-anatomy.png)

The `status.command()` function that we are going to call for our very first `hello world` example can take 12 different parameters, of which we are only going to use 4 in order to greet our user and make them feel great about using all this new and awesome technology.

It is possible to build up the different parameters we want in a variable, and then pass this in to `status.command()`. However, we are just building up the command ourselves as it is easy enough to keep track of four simple arguments.

Obviously, this small `hello` example can be extended greatly so that we can get responses from users and do a bunch of other rad things, but that will all become clear in the sections below on interactive suggestion areas etc.

```js
status.command({
    name: "faucet",
    title: I18n.t('faucet_title'),
    description: I18n.t('faucet_description'),
    color: "#7099e6",
    registeredOnly: true,
    params: [{
        name: "url",
        type: status.types.TEXT,
        suggestions: faucetSuggestions,
        placeholder: I18n.t('faucet_placeholder')
    }],
    preview: function (params) {
        return {
            markup: status.components.text(
                {},
                params.url
            )
        };
    },
    shortPreview: function (params) {
        return {
            markup: status.components.text(
                {},
                I18n.t('faucet_title') + ": " + params.url
            )
        };
    },
    validator: function (params, context) {
        var f = faucets.map(function (entry) {
            return entry.url;
        });

        if (f.indexOf(params.url) == -1) {
            var error = status.components.validationMessage(
                I18n.t('faucet_incorrect_title'),
                I18n.t('faucet_incorrect_description')
            );

            return {markup: error};
        }
    }
});
```

We have also included a far more complete example that utilises 9 of the 12 parameters you can pass into `status.command()` and is what we use to make it possible for our users to access the Status Faucet and get some of that tasty (test) ether to send to their friends and interact with the DApps already living in Status.

Read on!

## My First Interactive Suggestion Area

Great work! So, we have set up Status in `debug` mode, added our DApp to it (hopefully run the `dapp watch` command to get some live-reloading going) and learned how to issue a basic command that will greet our user when they open the app. Now it's time to start doing what chatbots are meant to do - interact with users and gather the necessary info we need from them.

This first thing we must do is add a `preview` object to that neat little `hello` command we just wrote in app.js. `preview` defines what your user will see as a result of their action, before any other response. The preview parameter takes a function, which should return a `status.component`.

```js
preview: function () {
    return status.components.text({}, "you’re saying hello");
},
```

Next, we can add a `params` object to define a bunch of useful things, including the `TYPE` of response we're expecting (so that Status knows which keyboard to show the user. We are ALL about UI!)

```js
 params: [{
 name: "hello",
 type: status.types.TEXT
 placeholder: "Why not say hello"
}],
```

It's worth noting that these `params` are available in any parameter, including in `params` itself. For instance, if your users sends `/hello whatsup`, the input `whatsup` will be available in your command under `params.hello`. Also worth noting is the `placeholder` we have use in the provided example - full details can be found in the formal API spec.

If you want to be more exact about what options there are for your user to respond and make this truly interactive, you can use a `suggestions` parameter instead:

```js
params: [{
 name: "hello",
 type: status.types.TEXT
 suggestions: helloSuggestions
}],
```

"But wait!" we hear you cry, "what on earth is that `helloSuggestions` thing about?!". Well, let’s make a function to explain. This will return a `scrollView` with two suggestions: "Hello", and "Goodbye". Don’t get intimidated by the length, there’s actually not much to it.

```js
// Three little helpers - don't worry about them, they're just for
// style.

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

// The main star of our show! It will return two touchable buttons.

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

You can also work with the `suggestionsTrigger` parameter. Now that we’ve covered `params` and the possibility of `suggestions`, it’s easy to see that `suggestionsTrigger` will take a string corresponding to an event that, when triggered, will show all your `suggestions`. If you don’t include this parameter, the default is "on-change", so your suggestions will show when your users selects the command.

It's also worth knowing about the `fullscreen` option. If your command has `suggestions`, this `param` controls whether that list of suggestions expands to fill the entire screen. If your command has a lot of suggestions, you might want to set `fullscreen` to `true`, so that your users don’t have to pull the list upwards. On the other hand, if your command has only a few suggestions and you set `fullscreen` to `true`, your users will have to pull the list downwards to keep it from hiding the screen. Choose whichever will be most convenient to your users, considering your command’s suggestions.
