# FlashDOM

*Diff and patch the DOM*

[![Hippocratic License HL3-CORE](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-CORE&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/core.html)

## Features

- Incremental DOM updates and nothing else
- Small footprint (less than 2kB)
- Relies on native DOM APIs whereever possible, so it’s fast
- No need for VDOM: use DOM nodes directly
- Ideal for use with Web Components

## Example

```coffeescript
import { flash } from "@dashkite/flashdom"

# pass an HTML string
flash document.body, "<h1>Hello!</h1>"

# or a DOM element
h1 = document.createElement "h1"
h1.textContent = "Hello, world!"
flash document.body, h1

# may also pass a selector as the first argument
flash "body", "<h1>Goodbye</h1>"
```

