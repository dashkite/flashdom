# Technical Notes

### DOM Diffing Algorithm

The library relies on a custom diffing algorithm that compares the current and future DOM trees. It evaluates text nodes, attributes, and child node structures. It utilizes a similarity threshold (defaulting to 5) to identify the best matching candidate nodes among siblings during the diffing process. This helps in reusing existing nodes when child order changes or when elements are slightly modified.

### Native DOM Parsing

When provided with an HTML string, the library parses it into DOM nodes using `Document.parseHTMLUnsafe`. This ensures that the parsing relies directly on the browser's native capabilities, avoiding overhead from custom string parsers. 

Historically, DOM APIs have been associated with slow performance, leading to the use of Virtual DOM libraries as a common strategy for manipulating markup. However, these performance issues are not present in modern browser engines. Flash DOM embraces this reality, relying directly on native DOM APIs to efficiently create updates.

### Memory Flashing

The name Flash DOM is derived from the computer science concept of memory flashing. Just as flashing memory involves rapidly writing or overwriting specific blocks of state, Flash DOM swiftly applies precise, incremental patches to the existing DOM structure in place.
