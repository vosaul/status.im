---
weight: 20
title: Status API Reference
---

# status (API)

https://github.com/status-im/status-react/blob/develop/resources/status.js#L160

## status

## status.command

TODO
name
title
description
handler != null
registeredOnly
validator
color
icon
params
preview
shortPreview
onSend
fullscreen
request
executeImmediately
sequentialParams

## status.response

## status.addListener


TODO ask roman more

on-message-input-change
https://github.com/status-im/status-react/blob/develop/bots/demo_bot/bot.js#L75

on-message-send
https://github.com/status-im/status-react/blob/develop/bots/demo_bot/bot.js#L76

## status.localizeNumber

## status.types

change keyboard?

## status.types.TEXT

## status.types.NUMBER

## status.types.PHONE

## status.types.PASSWORD

## status.events

## status.events.SET_VALUE

## status.events.SET_COMMAND_ARGUMENT

## status.components

## status.components.view

## status.components.text

## status.components.slider

## status.components.image

## status.components.touchable

## status.components.scrollView

## status.components.webView

## status.components.validationMessage

## status.components.bridgedWebview

## status.components.subscribe

## status.components.dispatch

## status.setSuggestions

## status.setDefaultDb

## status.updateDb

## status.sendMessage

## status.addLogMessage

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

