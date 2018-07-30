---
id: status_web_api
title: Status JavaScript API
---

On top of regular `web3` access, Status offers a set of API available to DApps developers. This API follows the [EIP1102](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1102.md) standard that will soon be used for web3 injection.

If Dapp was opened in Status web browser, Dapp's developers can request access to Status specific data using the Status JavaScript API

Dapps should request a Status JavaScript API by sending a message using the `window.postMessage` API. This message must be sent with a payload object containing a type property with a value of `'STATUS_API_REQUEST'` and `permissions` property corresponding to requested permissions, such as `“CONTACT_CODE”`.

Status will notify dapp of successful API exposure by sending a message using the `window.postMessage` API. This message will be sent with a payload object containing a type property with a value of `'STATUS_API_SUCCESS'` and a property corresponding to allowed permissions, such as `“CONTACT_CODE”`

Status will expose a Status JavaScript API as a global `STATUS_API` variable on the `window` object.

Example implementation: 

```JavaScript
window.addEventListener('message', function (event) {
    if (!event.data || !event.data.type) { return; }
    if (event.data.type === 'STATUS_API_SUCCESS') {
        console.log(event.data.permissions) //=> ["CONTACT_CODE"] if allowed , and [] if not allowed
        console.log(STATUS_API["CONTACT_CODE"]) //=> "0x0012300..123" if allowed
    }
});
// request status API
window.postMessage({ type: 'STATUS_API_REQUEST', permissions: ["CONTACT_CODE"] }, '*');
```
