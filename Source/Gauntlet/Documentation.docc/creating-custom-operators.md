# Creating Custom Assertion Operators

Create custom assertion operators to streamline your unit tests.

Gauntlet is designed to be easily extensible so that developers can write custom assertion operators to streamline their unit tests. Writing and testing a custom operator is straightforward, we'll look at the `isType` operator as an example of how to create an operator.

## Definition
An operator is defined by creating an extension on ``Assertion``, constraining the `Value` type if appropriate. It should be annotated as `@discardableResult` as assertions are not intended to be stored. All operators should contain a parameter to capture the line number (using `#line`) of calling code so that Xcode can correctly locate where in the source file a failure occurred (the file path is captured when the assertion is created). An `Assertion` should also return a new `Assertion` with a new value type when appropriate. Additionally the function should take a parameter used for validating the expected value.

For the `isType` assertion we'll take the expected type of the `Value` as a parameter, and the new Assertion will contain a value of the expected type if it succeeds.

```swift
extension Assertion {

    @discardableResult
    public func isType<T>(_ expectedType: T.Type, line: Int = #line) -> Assertion<T> {
        ...
    }
}
```

## Implementation
The main, and first, thing an operator implementation will do is call ``Assertion/evaluate(name:lineNumber:evaluator:)`` (or ``Assertion/asyncEvaluate(name:lineNumber:evaluator:)`` if calling async code). This takes a name, line number, and an evaluator closure. The function also returns a new `Assertion` which can be returned directly from the operator function.
  - `name`: This is the human readable name of the assertion. This will be included in failure messages recorded in the console and displayed in Xcode.
  - `lineNumber`: This is the line number that was captured using `#line` in the function definition and will let Xcode know where the failure occurred. It's important to capture this in the function signiature so that the line number comes from the calling code.

The evaluator closure is a closure that receives the Value of the receiving assertion and returns an ``AssertionResult`` describing the outcome of the operator. The closure will only be called if the receiving Assertion is a ``AssertionResult/pass(_:)``. If the assertion has already failed the closure will not be called and a new Result mapped to the expected Value type will be returned containing the existing `FailureReason`. The closure is expected to return an ``AssertionResult`` describing the outcome of the validation. ``AssertionResult/pass(_:)`` indicates the vlaidation was successful and provides the new value. ``AssertionResult/fail(message:)`` indicates the validation failed and provides a message describing the failure. ``AssertionResult/fail(thrownError:)`` indicates that an error was thrown during evaluation. 

Below is an example implementation of the `isType` operator:

``` swift
return evaluate(name: "isType", lineNumber: line) { value in
    // Attempt to cast the value to the expected type. If the cast succeeds then the validation has passed and we can return the cast value. 
    if let castValue = value as? T {
        return .pass(castValue)
    }

    // If the cast fails then we need to construct a message describing the failure and return the appropriate FailureReason.
    let typeDescription = String(describing: type(of: value))
    let expectedTypeDescription = String(describing: expectedType)
    let message = "Value of type \(typeDescription) does not conform to expected type \(expectedTypeDescription)"

    return .fail(message: message)
}
```

#### Things to keep in mind when writing custom operators:
Operators should always return a new assertion. The one exception to this is the `then` operator which terminates the chain. Think about what the appropriate value is to return in an operator so that subsequent operations can be run on it. The `isType` operator returns a value cast to the expected type. There are cases where returning `Assertion<Void>` makes sense, as the value has already been fully validated. Examples of this are the equality and bool operators.

The message returned for a failed assertion should be descriptive and helpful. The goal here is to provide the developer with helpful data so that they can begin to understand the failure without having to re-run the tests with breakpoints to inspect why the assertion failed. The `isType` operator does this by providing the expected type and the actual type. This message will be included in the logs and displayed within Xcode, alongside the name. When `isType` fails the following would show up in Xcode at the line where the assertion failed: `"isType failed - Value of type Int does not conform to expected type String"`

## Testing
Now that you have a custom assertion it's time to test it. Fully testing a custom assertion is critical, your unit tests will depend on it so you need to know that it will work as expected. Thankfully Gauntlet provides operators for Assertions that make testing operators easy. You'll want to validate that the operator passes in the conditions that it should, and that it fails as expected in cases where it should fail. You should also pass an explicit value for `lineNumber` so that you can validate that it's correctly being passed through to `evaluate`.

To test an operator you'll first need to create an assertion to use the operator on. Creating an Assertion like you would normally, using `Assert(that: )`, isn't what you want to do in this case. A normal assertion will generate test failures whenever the operator fails, and since we're writing tests to validate those failure conditions we don't want our tests to fail in those conditions. Gauntlet provides a function for this purpose: `TestAnAssertion(on: )`. This creates an assertion with some dummy data for the name and line, and importantly will not report any failures to XCTest. This allows you to run an operator on an Assertion that won't ever fail so that you can then run some Assertions on that Assertion to validate that it produced the expected result. Below is an example of a test validating a failure in the `isType` operator.

```swift
func testIsTypeFailure() {
    let assertion = TestAnAssertion(on: 8).isType(String.self, line: 321)

    Assert(that: assertion)
        .didFail(expectedName: "isType", expectedLine: 321)
        .isEqualTo(.message("Value of type Int does not conform to expected type String"))
}
```

There are two Assertion operators available: ``Assertion/didPass(expectedName:expectedLine:line:)`` and ``Assertion/didFail(expectedName:expectedLine:line:)`` to validate both pass and fail cases. In addition to these the associated values included in the ``AssertionResult/pass(_:)`` and ``AssertionResult/fail(_:)`` should be validated.
