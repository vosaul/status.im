---
weight: 10
title: API Introduction
---

# Introduction

Welcome to the Status API! Tread carefully, for you tread on the dreams of a better web.

Status allows users to interact with a wide array of Decentralized Applications (DApps) using the same intuitive chat interface (it also does a bunch of other things, but we'll focus on this aspect for now). In the near future, Status users will be able to have group chats where most of the participants are DApp chatbots. All DApp developers will benefit from this synergy, because a common chat interface for multiple DApps makes using your specific DApp more convenient, and effectively makes your DApp more powerful by giving it access to potentially far wider and more powerful network effects.

In this guide, we’ll explore how you can use the Status API to develop your DApp and create custom commands for your users that will work in a beautifully-intuitive, mobile context. As a result of developing on Status, you’ll have a DApp that your users can access on MetaMask, Mist, and Status. It's really worth emphasising that using Status brings with it access to mobile users with native mobile commands. With little extra developer time invested, you’ll gain a mobile app.

# Quickstart

If you already have a DApp with a web interface, then this will be the quickest Quickstart ever (trademark pending). Simply open Status, navigate to Console, hit the `@browse` command and type in the url where you DApp is running.

Voila! Users in Status can already see your DApp and interact with it (on the Ropsten Test Network). Make some mobile optimizations of your own and you're away. That is the power of decentralized, web3 technologies. Awesome, right?

OK, but what if `(a)` I don't have a DApp yet, or `(b)` I want to use this awesome API to get access to native mobile commands and actual, fully decentralized, chatbot functionality for my DApp?

# Tutorials

## Overview

We will be using only the bare-bones `status-dev-cli` tools in order to create our very first status DApp that can be accessed through Status. Just before we get started, it's well worth acquainting yourself with some of our terminology so you'll be able to make sense of it all. This anatomy establishes the different sections of the chat interface and establishes a common verbiage. The main components are:

* Message
* Input
* Keyboard
* Suggestions

![Chat Anatomy](images/chat-anatomy.png)

Please take some time to familiarize yourself with all the areas and the different configurations possible depending on what you want to do. Missing from the above is what we refer to throughout this documentation as the 'markup', by which we mean the mobile equivalent of the 'view', i.e. where the message appear. Creating all of these native setups is totally possible through the API - just read on.

## Installing Status

To develop on Status, you need to have Status running either:

* on a real phone,

* in an Android simulator, or

* in an iOS simulator.

You can go to [https://test.status.im](https://test.status.im) to download for Android. At the time of writing, we’re out of invitations for Testflight iOS, but you can sign up for early iOS access  [on our website](http://status.im).

If you are running in an Android simulator, you also need to run on the command line:
```shell
adb forward tcp:5561 tcp:5561
```
If you don’t have a smartphone, or you only have an iPhone but want to get started right away, you can build Status yourself, for either Android or iOS by following [these guidelines](https://wiki.status.im/contributing/development/building-status/). Following those guidelines, you can install an Android simulator, or start up Status in the Xcode simulator. Our wiki guidelines should be all you need, but if you get lost come ask around in [our Slack](https://slack.status.im).

## Enabling Debugging

![With your phone connected, /debug "On"](images/starting-a-dapp-on-status-with-frameworks_01.png)

*With your phone connected, /debug "On"*

We’ll assume you have Status open, and that if you’re using a physical phone it’s connected to your computer. Now we need to enable debugging from within the Status app. After you’re logged in to Status, click on Console and run `/debug`, then pick "On." You’ll get back a message telling that debugging is on, and that you can use the [status-dev-cli](https://github.com/status-im/status-dev-cli) tools if you want. You don’t need those right now, because you’ll be using the pre-configured Status Truffle box or the Embark plugin.

The message also shows you your IP address, which you’ll need later for Embark.

## My First Mobile DApp

First, install Status (easy for [android](http://test.status.im/), tougher for iOS due to TestFlight. You can also [build it yourself](https://wiki.status.im/contributing/development/building-status/) if you're feeling intrepid).

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

> In a new terminal window run the port forwarding and DApp connection stuff. It is important to pass in the `--ip` flag with the IP address listed by Console once you have selected the `debug` option and turned it on. You may also need to do adb port forwarding if you are using an Android device.

```shell
adb forward tcp:5561 tcp:5561  # Android only
status-dev-cli add-dapp '{"whisper-identity": "my-dapp", "dapp-url": "http://<IP of machine running http-server>:8080/", "name": "My DApp"}' --ip <IP listed in Status console>
```
First, install the dev tools globally using NPM.

Then, create a directory for you app to live in, switch into it, and create an `index.html` file and an `app.js` file.

The index.html will be really simple. We are going to add several meta tags to make our DApp look good on small screens of mobile phones and add a span that will be used by our JavaScript.

Our app.js file will also be simple. We are going to display the information about your account inside a span with account id. Status injects web3.js automatically, so you have an access to web3 variable from everywhere and you don’t need to care about including web3.js manually. However, you can do this and most probably you want to do this if you want to make your DApps work on other platforms.

You then need to install a really simple `http-server` from NPM, and start it in the `my-dapp` directory we just created.

Then, open your Status app, navigate to Console, select the `/debug` option and turn it `On`. This should return a message with an IP address.

Open a new terminal window and navigate back to you `my-dapp` directory and go ahead and add you dapp to Status! Make sure to pass in the `--ip` flag using the address returned to you by Console. `<Your-IP>` needs to be `127.0.0.1` if you are using a simulator, or whatever your PC's IP is if you are using a connected phone.

You can also do live-reloading once you're happy with this by running `status-dev-cli watch-dapp . '{"whisper-identity": "my-dapp"}'`

But wait, there's yet more! If you close the `webView` markup with your account listed in it, you will see that you already have access to the `@browse`, `/location`, `/send` and `/request` functionality - those come standard with any DApp that makes its home within Status. All you will need to do is learn how to handle them.

Happy travels!

<aside class="warn">
  You need not use NPM's http-server to serve content, there are innumerable ways of doing this. Just pick whatever is best for your environment.
</aside>

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

Once you have worked through the first tutorial and understood the basic steps to building a DApp and adding it into Status, it's time to get our hands a little more dirty by actually writing some real commands that will begin to utilise the awesome power of the Status API. All we have done so far is added our DApp to Status and displayed our account in it using a `webView`. Now, it's time to start making use of the API proper, in order to leverage all that native mobile and chatbot functionality so that we can take your DApp to the next level.

We kind of cheated a little in the previous tutorial. While it is totally possible to have your html5 DApp work perfectly in Status via `webView`, it's obviously not the most optimal way to do things. We use [ClojureScript](http://www.braveclojure.com/introduction/) and React Native to handle all our things, but you don't have to. The main take away here is that the chat context itself is actually an Otto VM jail that executes the javascript you write and integrates that directly with Status. So, we can actually write bots that are purely javascript-based. Please see [here](https://github.com/status-im/status-react/tree/develop/bots) for a full list of all our current bots and their source code.

![status-anantomy.png](https://github.com/status-im/docs.status.im/blob/develop/static/images/status-anatomy.png)

The `status.command()` function that we are calling in this example can take 12 different parameters, of which we are only using 4 to ensure that we can greet our user nicely and make them feel great about using all this new and awesome technology.

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
