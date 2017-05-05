---
weight: 20
title: Status API Reference
---

# status (API)

https://github.com/status-im/status-react/blob/develop/resources/status.js#L160

## status

Ethereum. Anywhere.  
Status is a browser, messenger, and gateway to a decentralized world.  

Status allows users to interact with a wide array of DApps using the same intuitive chat interface. In the near future, Status users will be able to have group chats where most of the participants are DApp chatbots. All DApp developers will benefit from this synergy, because a common chat interface for multiple DApps makes using your DApp more convenient, and effectively makes your DApp more powerful.

In this guide, we’ll explore how you can use the Status Chat API while developing your DApp on Status to create custom commands for your users. As a result of developing on Status, you’ll have a DApp that your users can access on MetaMask, Mist, and Status — and that invites mobile users with native mobile commands. With little extra developer time invested, you’ll gain a mobile app.

## status.command

> A really simple template:

```js
status.command({
 name: “hello”,
 title: “HelloBot”,
 description: “Helps you say hello”,
 color: “#7099e6”,
 preview: function () {
 return status.components.text({}, “you’re saying hello”);
 }
});
```

> It is important to note that params are available for any status.command, including in params itself. For instance, if your user sends /hello whatsup, the input "whatsup" will be available in your command under params.hello. You can add additional params to - for instance - preview like so:

```js
params: [{
 name: “hello”,
 type: status.types.TEXT
 placeholder: "Why not say hello"
}],
```

> The placeholder parameter above only applies if your users haven’t put any input into the command, not even the name of the command. You can use it to include helpful guidance where necessary, i.e. Type your password. Alternatively, you can also include suggestions for your users’ input. This should return a component to be rendered. For instance, if you are using the Console DApp and you select the /faucet command, you’ll see two suggestions to choose from.

> Example validator function (this specific example will raise an error if your user doesn’t input a string. Notice that you should return your message inside one of the status.components):

```js
validator: function(params) {
 if (!params.hello) {
   return status.components.text({}, “Say hello”);
   }
 }
 ```
 
> Example of the request command to get a user send some amount of Ether somewhere:

```js
handler: function (params) {
        return {
            event: "request",
            params: [params.amount],
            request: {
                command: "send",
                params: {
                    amount: params.amount
                }
            }
        };
    },
```

> Full example of pretty much all the <code>status.command</code> stuff in action:

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

### Parameters

Argument |  Description 
--------- |  ----------- 
name |  What your users will type in following a forward slash to invoke the command. For instance, if you wrote name: `“hello”`, your user might invoke `/hello`. There is an additional `params` object available on any of the below commands, including in params itself.
title | This is what will appear in the list of suggestions when a user starts typing a command. 
description | Appears below the `title` in the list of suggestions and does exactly what it says. 
validator | Allows you to check your users’ input before sending off the command. It takes a function, which should return an error if the input is invalid.
color | Defines the background color of the name of your command as it appears in the list of suggestions. Give commands different colors to help your users easily distinguish commands, and to harmonize with your DApp’s brand and color scheme.
icon | Define which icon will appear next to action messages, such as sending Ether or requesting a location. Think an arrow for sending, a pin for location etc.
params | Define all the possible inputs to your command. Requires an array holding an object, with possible parameters `name`, `placeholder`, `suggestions`, and one of the `status.types`, which are: `status.types.TEXT`, `status.types.NUMBER`, `status.types.PHONE`, and `status.types.PASSWORD`.
preview | Defines what your user will see as a result of *their* action, before any other response. The preview parameter takes a function, which should return a `status.component`.
shortPreview | While `preview` controls how your command appears within your DApp’s chat interface, `short-preview` controls how your commands get shown in the list of chats, before your users tap on your chat. `short-prview` expects two params: `icon` and `params`.  
onSend | A self-explanatory param that takes a function whcih will be executed when the user presses the “send” button. It will return a map that should contain a `markup` value. If you specify this function, there will be no way to send a command to the chat and, in this case, the area (it’s called the `result-box`) with a specified markup will be displayed instead.
fullscreen | If your command has suggestions, this param controls whether that list of suggestions expands to fill the entire screen. See the interactive suggestion area tutorial for more.
request | This will allow you to request any action from the user, such as a phone number, password, confirmation to send Ether etc. Used with the `executeImmediately` option set to `true`, it will create a message the user can tap on an execute immediately.
executeImmediately (Boolean) | If true, this means that the **response** will be executed immediately when you press on it. For instance, when you see a response in a chat, you don’t have to type something — you just need to press on a response and it will be executed right after that.
sequentialParams (Boolean) | Specifies the way command arguments will be “requested”. The default approach (`sequentialParams = false`) is to type a command this way: `/send 0.1 ETH somebody`, where `0.1`, `ETH` and `somebody` are arguments. However, there may be situations when you want to ask each argument separately. You can see the difference by executing `/password` command; it asks you for a password and, only after the user has provided one, requests confirmation.  Currently there is one limitation — you can use argument types (`type` value) only for `sequentialParams`, and if you want to (for example) hide the argument input, you should use `sequentialParams`
handler (!= null) | Of course, you probably want the command to do something when your users call it! The `handler` parameter takes a function to accomplish this. For instance, suppose your user inputs `/hello howdy`. “Howdy” is a valid string, and will pass the `hello` validator. From there, your handler could take over to send this greeting to another user: `handler: web3.shh.post(params.hello)`.

## status.response

> An example response for a confirmation code sent via SMS:

```js
status.response({
    name: "confirmation-code",
    color: "#7099e6",
    description: I18n.t('confirm_description'),
    sequentialParams: true,
    params: [{
        name: "code",
        type: status.types.NUMBER
    }],
    validator: function (params) {
        if (!/^[\d]{4}$/.test(params.code)) {
            var error = status.components.validationMessage(
                I18n.t('confirm_validation_title'),
                I18n.t('confirm_validation_description')
            );

            return {markup: error};
        }
    }
});
```

Now that you’ve covered all the parameters for `status.command()`, you can easily understand `status.response()`. This method takes the same parameters that `status.command()` does. The difference is that with this method you can actively ask a user to issue a command.

For example, the Status DApp Wallet allows you to /request money. In that case, the person you’re requesting money from will see the result of `status.response(send)` — they’ll be asked to give a command, `/send`, in response to your `/request` command.

The Wallet example illustrates that as a DApp developer, you may wish to use `status.command()` and `status.response()` together to create dialogues of commands. You could also use `status.response()` by itself to prompt your users to enter necessary information as part of the onboarding process for your DApp.

Because `status.command()` and `status.response()` take the same parameters, you can sometimes use nearly the same code for both of them. You simply have to consider when you want to ask a user to issue a command, and when you want to just make the command available. Most of the time, you’ll use `status.command()`.

## status.on

```js
status.on(“init”, function(params, context) {
 status.sendMessage(“Hello, man!”);
});
```

This method allows your DApp to respond to events. This method requires an event name as a string, and a callback function. With the "init" option shown here, your DApp will trigger `status.sendMessage()` when the Status app loads your DApp — your DApp will greet your users even before they have clicked on it. Other options include “text-change” and “message”

## status.addListener

```js
status.addListener("on-message-input-change", 
 function (params, context) {
    return jsSuggestions({code: params.message}, context);
});
```

```js
status.addListener("init", 
 function (params, context) {
    return {"text-message": "Hey, man!"};
});
```

```js
status.addListener("on-message-send", 
 function (params, context) {
    if (isNaN(params.message)) {
        return {"text-message": "Seems that you don't want to send money :("};
    }

    var balance = web3.eth.getBalance(context.from);
    var value = parseFloat(params.message);
    var weiValue = web3.toWei(value, "ether");
    if (bn(weiValue).greaterThan(bn(balance))) {
        return {"text-message": "No way man, you don't have enough money! :)"};
    }
    try {
        web3.eth.sendTransaction({
            from: context.from,
            to: context.from,
            value: weiValue
        });
        return {"text-message": "You are the hero, you sent " + value + " ETH to yourself!"};
    } catch (err) {
        return {"text-message": "Something went wrong :("};
    }
});
```

Listener |  Description
--------- |  -----------
on-message-input-change | This is analogous to the `text-change` event of chat’s input and we feel is fairly obvious given the example provided.
init | Is called once when a new session begins (by session currently means interval between login and logout from account). In the example provided the bot will just send this “Hey, man!” message to the user, but it could also it could return `markup` which will be shown in suggestions area, etc.
on-message-send | Will be called when any (not command) message is sent.


## status.localizeNumber

```js
preview: function (params, context) {
        return {
            markup: status.components.text(
                {},
                I18n.t('request_requesting') + " "
                + status.localizeNumber(params.amount, context.delimiter, context.separator)
                + " ETH"
            )
        };
    },
 ```

A simple method to try and ensure that whatever numbe the user inputs is put into a usable format. The example provided shows it in use to make sure the number requesting ETH is handled correctly. This is part of a larger `status.command()` object that can be found [here](https://github.com/status-im/status-react/blob/30596f743f0a6ac0b7aec575cc1483dd306cc1ef/bots/wallet/bot.js#L182).

## status.types

```js
    types: {
        TEXT: 'text',
        NUMBER: 'number',
        PHONE: 'phone',
        PASSWORD: 'password'
    },
    events: {
        SET_VALUE: 'set-value',
        SET_COMMAND_ARGUMENT: 'set-command-argument'
    },
```

Types dictate what sort of data your users may input. The type you specify will determine what kind of keyboard gets shown to the user (if you have not already defined a custom one) so that they can input their response easily. It is important to specify them for a smooth, easy, and intuitive UI.

## status.types.TEXT

If you define a `text` input, when the user responds, it will pop up a normal QWERTY keyboard.

## status.types.NUMBER

Defining `number` will result in the keyboard opening to it's number section.

## status.types.PHONE
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
```
Defining `phone` will result in the keyboard opening to it's number section as well. One example should suffice to give you a general idea of how this works, so we have provided an excerpt of how we do phone cofirmation using the `PHONE` type. You can find the full code [here](https://github.com/status-im/status-react/blob/develop/bots/console/bot.js#L450)

## status.types.PASSWORD

Defining `password` will result in the keyboard opening to it's variable character section.

## status.events

Events are essentially the glue that allow you to commuicate with the Status Chat API effectively.

## status.events.SET_VALUE
```js 
{onPress: status.components.dispatch([status.events.SET_VALUE, entry])},
```

This method will completely update the content of text input. The full function around the snippet example provided can be found [here](https://github.com/status-im/status-react/blob/30596f743f0a6ac0b7aec575cc1483dd306cc1ef/bots/console/bot.js#L560).

## status.events.SET_COMMAND_ARGUMENT
```js
{onPress: status.components.dispatch([status.events.SET_COMMAND_ARGUMENT, [0, entry.url]])},
```
As opposed to `SET_VALUE`, this event will only update a single argument which you define. The full function around the snippet example provided can be found [here](https://github.com/status-im/status-react/blob/30596f743f0a6ac0b7aec575cc1483dd306cc1ef/bots/console/bot.js#L485).

## status.components

Create React Native Components yourself or use our pre-fabricated components.

## status.components.view

Standard RN component - please see [JSCoach](https://js.coach/react-native) for more. 
Expects 2 arguments - `options` and `element`. 

## status.components.text

Standard RN component - please see [JSCoach](https://js.coach/react-native) for more. 
Expects 2 arguments - `options` and some array of strings `s`.

## status.components.slider

Standard RN component - please see [JSCoach](https://js.coach/react-native) for more.  
Expects only one argument - `options`.

## status.components.image

Standard RN component - please see [JSCoach](https://js.coach/react-native) for more.  
Expects only one argument - `options`.

## status.components.touchable

Standard RN component - please see [JSCoach](https://js.coach/react-native) for more.  
Expects 2 arguments - `options` and `element`.

## status.components.scrollView

Standard RN component - please see [JSCoach](https://js.coach/react-native) for more.  
Expects 2 arguments - `options` and `elements`.

## status.components.webView

Standard RN component - please see [JSCoach](https://js.coach/react-native) for more.  
Expects only 1 argument - `url`.

## status.components.validationMessage

> An example of using validationMessage within the validator argument being passed to status.command.
```js
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
```

This is the only custom Status component and it takes just two strings, and will return them wrapped in text components inside a view. You can find the full example [here](https://github.com/status-im/status-react/blob/develop/bots/console/bot.js#L550).

## status.components.bridgedWebview

Standard RN component - please see [JSCoach](https://js.coach/react-native) for more. Expects only 1 argument - `url`.

## status.components.subscribe

A method that allows you to add a subscription in the markup and expects just 1 argument - `path`. The added subscription will get the value from the bot-db using your specifiied path.

## status.components.dispatch

```js
var view = ["view", {},
        ["text", {}, "Balance " + balance + " ETH"],
        ["text", {}, ["subscribe", ["doubledValue"]]],
        ["slider", {
            maximumValue: ["subscribe", ["balance"]],
            value: defaultSliderValue,
            minimumValue: 0,
            onSlidingComplete: ["dispatch", ["set", "sliderValue"]],
            step: 0.05
        }],
        ['touchable',
            {onPress: ['dispatch', ["set-value-from-db", "roundedValue"]]},
            ["view", {}, ["text", {}, "Set value"]]
        ],
        ["text", {style: {color: "red"}}, ["subscribe", ["validationText"]]]
    ];
```

A method that allows you to specify an event that will be dispatched on some other event that occurs inside the markup (like pressing button, text change etc.). By 'markup', we mean - essentially - the view, or the mobile equivalent of the DOM.   
In the example provided, the variable `view` is what we mean by markup (and is, in this case, part of our `superSuggestion` function found [here](https://github.com/status-im/status-react/blob/2862af86c960b481ddf64ec1713e14908a366616/bots/demo_bot/bot.js#L31)) we specify that `["set", "sliderValue"]` will be dispatched on `onSlidingComplete`. We can’t allow user to write a real js handler here, so this is our workaround for now.

## status.setSuggestions

A method that allows you to set the suggestions that will appear in the markup, whether this is something simple like sending a message, or pretty much anything

## status.setDefaultDb

A method that can be used to add default values to bot-db. These values will be applied to app-db only when markup is rendered the first time. For instance, on each change in command input suggestions handler for particular command's parameter is called, and this handler returns some markup. If markup wasn't changed between calls values passed to setDefaultDb will not be applied to bot-db

## status.updateDb

A method that updates the bot-db, even if the markup doesn't contain any changes. It too expects just 1 argument - `map`

## status.sendMessage

Not currently implemented, but will be soon to avoid unnecessary complexities for API users wanting to perform simple actions, who currently need to use the `setSuggestions` method.

## status.defineSubscription


```js
function round(n) {
    return Math.round(n * 100) / 100;
}

function doubledValueLabel(params) {
    var value = round(params.value);
    return "sliderValue = " + value +
        "; (2 * sliderValue) = " + (2 * value);
}

status.defineSubscription(
    // the name of subscription and the name of the value in bot-db
    // associated with this subscription
    "doubledValue",
    // the map of values on which subscription depends: keys are arbitrary names
    // and values are db paths to another value
    {value: ["sliderValue"]},
    // the function which will be called as reaction on changes of values above,
    // should be pure. Returned result will be associated with subscription in bot-db
    doubledValueLabel
);

status.defineSubscription(
    "roundedValue",
    {value: ["sliderValue"]},
    function (params) {
        return round(params.value);
    }
);
```
This method was added to allow a bot to react on changes in the bot-db and add another calculated value to that bot-db in the result. It expects 3 arguments: the name of subscription, a map of values on which the subscription depends, and a callback function.
