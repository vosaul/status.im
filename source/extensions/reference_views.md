A view is composed of a set of nested components. A component is defined by a name and an optional map of properties.

# Components

| Symbol             | Properties              |
| -------------      | -------------           |
| view               | style                   |
| text               | style                   |
| touchable-opacity  | style, on-press :event  |
| image              | style, uri :string      |
| input              | style, on-press :event, placeholder :string  |
| button             | style, on-click :event  |
| link               | style, uri :string  |
| checkbox           | style, on-change :event, checked: boolean  |

Example usage:

```clojure
[view {:style {:background-color "red"}}
  [checkbox {:checked true}]]
```