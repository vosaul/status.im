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
