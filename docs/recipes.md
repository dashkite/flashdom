# Usage Guides

## Updating a Container with New HTML Content

You need to update a specific container element with new HTML content without replacing the entire container. 

Flash DOM enables this by rapidly parsing the provided HTML string into nodes, computing the exact differences between the existing children and the new nodes, and applying only the necessary patches. This is the most common and approachable way to utilize the library for general interface updates.

### Example

```coffeescript
import { flash } from "@dashkite/flashdom"

# fetch new content from an external source
htmlString = "<ul><li>One</li><li>Two</li></ul>"
flash "#container", htmlString
```

### Algorithm

1. Identify the target container using a CSS selector string (`"#container"`).
2. Provide the new content as an HTML string.
3. Flash DOM internally delegates to the browser's native parser to create DOM nodes.
4. Flash DOM calculates the required incremental changes.
5. Flash DOM applies the changes directly to the target container, preserving unaffected nodes.

## Synchronizing an Existing DOM Element

You need to update an existing DOM element to match a newly constructed DOM element, minimizing reflows and preserving state such as focus or scroll position on unchanged elements.

Flash DOM handles this elegantly by comparing the actual DOM nodes. By providing a target node and a source node directly, you bypass the HTML parsing step. This approach is highly effective when your application logic naturally generates DOM elements programmatically.

### Example

```coffeescript
import { flash } from "@dashkite/flashdom"

# construct the future state programmatically
futureNode = document.createElement "div"
futureNode.setAttribute "data-state", "active"
futureNode.textContent = "Active State"

# apply it to the current node
currentNode = document.getElementById "status"
flash currentNode, futureNode
```

### Algorithm

1. Create or obtain the `futureNode` representing the desired state.
2. Obtain a reference to the `currentNode` representing the existing state in the document.
3. Pass both nodes to the `flash` function.
4. Flash DOM performs a similarity check and recursive diffing to find attribute and text changes.
5. Flash DOM updates the `currentNode` in place to precisely reflect the attributes and content of `futureNode`.

## Separating Calculation from Mutation

You need precise control over exactly when DOM mutations occur. Perhaps you are calculating updates based on a high-frequency stream of data, and you only want to apply the mutations during a browser animation frame to ensure smooth rendering.

Instead of using the high-level `flash` function, you can utilize the lower-level `diff` and `patch` functions. This advanced technique allows you to completely decouple the computation of differences from the actual DOM side-effects.

### Example

```coffeescript
import { diff, patch } from "@dashkite/flashdom"

currentNode = document.getElementById "data-view"
# construct the updated view
futureNode = generateUpdatedView() 

# calculate patches immediately
mutations = diff currentNode, futureNode

# defer the actual DOM updates to the next animation frame
requestAnimationFrame ->
  patch mutations
```

### Algorithm

1. Obtain the current and future DOM nodes.
2. Execute the `diff` function to synchronously calculate the array of necessary mutations.
3. Store the resulting array of patch instructions.
4. Wait for the appropriate moment in the application's lifecycle, such as an animation frame.
5. Pass the stored patches to the `patch` function to execute the DOM mutations all at once.
