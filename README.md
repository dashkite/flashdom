# Flash DOM

*Diff and patch the DOM*

[![Hippocratic License HL3-CORE](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-CORE&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/core.html)

Flash DOM is a lightweight library designed to update the Document Object Model (DOM) incrementally. It achieves high performance by relying on native DOM APIs instead of a Virtual DOM, making it ideal for integration with Web Components and other native browser technologies. 

## Features

- Incremental DOM updates for precise rendering.
- Extremely small footprint of less than 2kB.
- High performance by utilizing native DOM APIs.
- Operates directly on DOM nodes, eliminating the need for a Virtual DOM.
- Highly suitable for Web Components and modern web application development.

## Installation

```shell
pnpm install @dashkite/flashdom
```

## Usage

```coffeescript
import { flash } from "@dashkite/flashdom"

# Provide a selector and an HTML string
flash "body", "<h1>Hello, world!</h1>"

# Provide a DOM element and another DOM element
h1 = document.createElement "h1"
h1.textContent = "Welcome"
flash document.body, h1
```

## Other Resources

- [Reference Documentation](docs/reference.md)
- [Usage Guides](docs/recipes.md)
- [Technical Notes](docs/technical-notes.md)
- [Testing](docs/testing.md)
