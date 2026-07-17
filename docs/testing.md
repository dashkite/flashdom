# Testing

This document details the testing approach for the Flash DOM library.

## Testing Approach

The library utilizes the `@dashkite/amen` testing framework alongside standard assertions to verify its functionality. Tests validate that the `flash`, `diff`, and `patch` functions accurately identify DOM changes and apply them correctly to the target nodes. The testing suite focuses on edge cases for attribute manipulation, text node updates, and structural changes to the DOM tree.

## Running Tests

To run the testing suite, execute the following command in the repository root:

```shell
npx genie test
```

This command invokes the test runner configured in `genie.yaml` and outputs the results to the console.
