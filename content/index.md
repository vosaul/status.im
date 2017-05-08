---
weight: 10
title: API Introduction
---

# Introduction

Welcome to the Status API! Tread carefully, for you tread on the dreams of a better web.

Status allows users to interact with a wide array of Decentralized Applications (DApps) using the same intuitive chat interface (it also does a bunch of other things, but we'll focus on this aspect for now). In the near future, Status users will be able to have group chats where most of the participants are DApp chatbots. All DApp developers will benefit from this synergy, because a common chat interface for multiple DApps makes using your specific DApp more convenient, and effectively makes your DApp more powerful by giving it access to potentially far wider and more powerful network effects.

In this guide, we’ll explore how you can use the Status Status API to develop your DApp and create custom commands for your users that will work in a beautifully-intuitive, mobile context. As a result of developing on Status, you’ll have a DApp that your users can access on MetaMask, Mist, and Status. It's really worth emphasising that using Status brings with it access to mobile users with native mobile commands. With little extra developer time invested, you’ll gain a mobile app.

# Quickstart

If you already have a DApp with a web interface, then this will be the quickest Quickstart ever (trademark pending). Simply open Status, navigate to Console, hit the `/browse` command and type in the url where you DApp is running.

Voila! Users in Status can already see your DApp and interact with it (on the Ropsten Test Network). Make some mobile optimizations of your own and you're away.

OK, but what if `(a)` I don't have a DApp yet, or `(b)` I want to use this awesome API to get access to native mobile commands and actual, fully decentralized, chatbot functionality for my DApp?

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

> In a new terminal window. It is important to pass in the `--ip` flag with the IP address listed by Console once you have selected the `debug` option and turned it on. You may also need to do port forwarding if you are using an Android device.

```shell
adb forward tcp:5561 tcp:5561  # Android only
status-dev-cli add-dapp '{"whisper-identity": "my-dapp", "dapp-url": "http://<Your IP>:8080/", "name": "My DApp"}' --ip <IP listed in Status console>
```

Before we really dive into the finer print, we will be using only the bare-bones `status-dev-cli` tools in order to create our very first status DApp that can be accessed through Status. First, install the dev tools globally using NPM.

Then, create a directory for you app to live in, switch into it and create an `index.html` file and an `app.js` file.

The index.html will be really simple. We are going to add several meta tags to make our DApp look good on small screens of mobile phones and add a span that will be used by our JavaScript.

Our app.js file will also be simple. We are going to display the information about your account inside a span with account id. Status injects web3.js automatically, so you have an access to web3 variable from everywhere and you don’t need to care about including web3.js manually. However, you can do this and most probably you want to do this if you want to make your DApps work on other platforms.

You then need to install a really simple `http-server` from NPM, and start it in the `my-dapp` directory we just created.

Then, open your Status app, navigate to Console, select the `debug` option and turn it on. This should return a message with an IP address.

Open a new terminal window and navigate back to you `my-dapp` directory and go ahead and add you dapp to Status! Make sure to pass in the `--ip` flag using the address returned to you by Console. `<Your-IP>` needs to be `127.0.0.1` if you are using a simulator, or whatever your PC's IP is if you are using a connected phone.

You can also do live-reloading once you're happy with this by running `status-dev-cli watch-dapp . '{"whisper-identity": "my-dapp"}'`

Happy travels!

<aside class="warn">
  You need not use NPM's http-server to serve content, there are innumerable ways of doing this. Just pick whatever is best for your environment.
</aside>

# Step-by-Step Tutorials

## Create Your First Status Command

```js
status.command({
    name: "hello",
    title: "HelloBot",
    description: "Helps you say hello",
    color: "#7099e6",
});
```

Once you have worked through the Quickstart tutorial and understood the basic steps to building a DApp and adding it into Status, it's time to get our hands a little more dirty by actually writing some real commands that will begin to utilise the awesome power of the Status API.

In the my-dapp directory you created with the index.html and app.js files, we can now begin to do some more fun things. We start by writing a command in the app.js that will allow us to say `hello` to a user when they open the DApp.

`status.command()` can take 12 different parameters, of which we are only using 4 to ensure that we can greet our user nicely and make them feel great about using all this new and awesome technology.

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

## Create An Interactive Suggestion Area

Great work! So, we have set up Status in `debug` mode, added our DApp to it (hopefully run the `dapp watch` command to get some live-reloading going and learned how to issue a basic command that will greet our user when they open the app. Now it's time to actually start doing what chatbots are meant to do - interact with users and gather the necessary info we need from them.

This first thing to add is a `preview` object to that neat little `hello` command we just wrote in app.js. `preview` defines what your user will see as a result of their action, before any other response. The preview parameter takes a function, which should return a `status.component`.

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
