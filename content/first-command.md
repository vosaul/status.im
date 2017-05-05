## Create Your First Status Command

```js
var phoneConfig = {
    name: "phone",
    registeredOnly: true,
    icon: "phone_white",
    color: "#5bb2a2",
    title: I18n.t('phone_title'),
    description: I18n.t('phone_description'),
    sequentialParams: true,
    validator: function (params) {
        return {
            validationHandler: "phone",
            parameters: [params.phone]
        };
    },
    params: [{
        name: "phone",
        type: status.types.PHONE,
        suggestions: phoneSuggestions,
        placeholder: I18n.t('phone_placeholder')
    }]
};
status.response(phoneConfig);
status.command(phoneConfig);
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

In the my-dapp directory you created with the index.html and app.js files, we can now begin to do some more fun things. We start by writing a command in the app.js that will allow us to confirm a user's phone number and send them a response.

Now, the example provided is a fairly big chunck of code to work through, but it will all become clear if you take a look over the API specs below.

`status.command()` can take 12 different parameters, of which we are using 9 to ensure that we get the phone configuration set up properly.

As you can see, we build up the different parameters we want in a variable, and then pass this in to `status.command()`. In this case, we are also passing it to `status.response()` as we require some interaction from the user. 'status.response()` takes the same parameters that `status.command()` does, the only difference is that with this method you can actively ask a user to issue a command.

Obviously, it is also possible to build the command yourself without first defining a variable, as shown in the second example where we use `status.command()` to allow a user to access the Ropsten faucet and get some test ether to send to their friends and interact with DApps already living in Status. 



