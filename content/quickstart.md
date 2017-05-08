## Get Up and Running Fast

```bash
npm install -g status-dev-cli

mkdir my-dapp && cd my-dapp
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
```bash
npm install http-server -g
http-server
```

> In a new terminal window. It is important to pass in the `--ip` flag with the IP address listed by Console once you have selected the `debug` option and turned it on. You may also need to do port forwarding if you are using an Android device.
```bash
(only on android): adb forward tcp:5561 tcp:5561
status-dev-cli add-dapp '{"whisper-identity": "my-dapp", "dapp-url": "http://127.0.0.1:8080/", "name": "My DApp"}' --ip <IP listed in Status console>
```

For this section, we will be using only the bare-bones `status-dev-cli` tools in order to create our very first status command. Simply follow along in the example provided to the right and you should be up and away in no time at all!

First, install the dev tools globally using NPM.

Then, create a directory for you app to live in and switch into it.

The index.html will be really simple. We are going to add several meta tags to make our DApp look good on small screens of mobile phones and add a span that will be used by our JavaScript.

Our app.js file will also be simple. We are going to display the information about your account inside a span with account id. Status injects web3.js automatically, so you have an access to web3 variable from everywhere and you don’t need to care about including web3.js manually. However, you can do this and most probably you want to do this if you want to make your DApps work on other platforms.

You then need to install a really simple `http-server` from NPM, and start it in the `my-dapp` directory we just created.

Then, open your Status app, navigate to Console, select the `debug` option and turn it on. This should return a message with an IP address.

Open a new terminal window and navigate back to you `my-dapp` directory and go ahead and add you dapp to Status! Make sure to pass in the `--ip` flag using the address returned to you by Console.

You can also do live-reloading once you're happy with this by running `status-dev-cli watch-dapp . '{"whisper-identity": "my-dapp"}'`

Happy travels!

