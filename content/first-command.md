## Create Your First Status Command
```js
status.command({
 name: “hello”,
 title: “HelloBot”,
 description: “Helps you say hello”,
 color: “#7099e6”,
});
```

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

Once you have worked through the Quickstart tutorial and understood the basic steps to building a DApp and adding it into status, it's time to get our hands a little more dirty with by actually writing some real commands that will begin to utilise the awesome power of the Chat API.

In the my-dapp directory you created with the index.html and app.js files, we can now begin to do some more fun things. We start by writing a command in the app.js that will allow us to say hello to a user when they open the DApp.

`status.command()` can take 12 different parameters, of which we are only using 4 to ensure that we can greet our user nicely and make them feel great about using all this new and awesome technology.

It is possible to build up the different parameters we want in a variable, and then pass this in to `status.command()`.

However, we are just building up the command ourselves as it is easy enough to keep track of four simple arguments. Obviously, this small `hello` example can be extended greatly so that we can get responses from users and do a bunch of other rad things, but that will all become clear in the sections below on interactive suggestion areas etc.

We have included a far more complete example that utilises 9 of the 12 parameters you can pass into `status.command()` and is what we use to make it possible for our users to access the Status Faucet and get some of that tasty (test) ether to send to their friends and interact with the DApps already living in Status.

Read on!



