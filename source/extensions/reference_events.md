---
id: reference_events
title: Extension Reference - Events
---

# Events in Extensions

An event is defined by a name and an optional map of arguments.

# Events

| Symbol             | Arguments                  |
| -------------      | -------------              |
| alert              | value :string              |
| log                | value :string              |
| store/put          | key :string, value :string |
| store/append       | key :string, value :string |
| store/clear        | key :string,               |
| store/put          | key :string, value :string |
| http/get           | url :string, timeout? :string, on-success :event, on-failure? :event |
| http/post          | url :string, body :string, timeout? :string, on-success :event, on-failure? :event |
| ipfs/cat          | hash :string, on-success :event, on-failure? :event |
| ethereum/send-transaction          | to :string, gas? :string, gas-price? :string, value? :string, method? :string, params? :vector, nonce? :string, on-result? :event |
| ethereum/call          | to :string, method? :string, params? :vector, on-result? :event |

Example usage:

```clojure
[button {:on-click [store/put]}]
```