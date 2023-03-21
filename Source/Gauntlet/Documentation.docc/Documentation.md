# ``Gauntlet``

Gauntlet is an extensible, functional API for writing unit test assertions in Swift, built on top of XCTest.

## Using Gauntlet

Gauntlet assertions are used in place of the `XCTAssert` functions. You start by creating an assertion:

```swift
// Given
let model = Model()

// When
let result: Result<String, Error> = model.loadContent()

Assert(that: result)
```

However this assertion doesn't do anything yet. To actually validate the value you need to call an operator on it:

```swift
let model = Model()

// When
let result: Result<String, Error> = model.loadContent()

Assert(that: result).isSuccess().isEqualTo("expected content")
```

An operator is a function defined on an `Assertion` which performs validation on a value and then returns a new Assertion. If an operator's validation fails a test failure will be generated and no subsequent operators on that assertion will be evaluated. In the above example the `isSuccess()` operator validates that the result is a success and provides the associated success value in the returned Assertion.

Gauntlet includes a number of operators in the box, see ``Assertion`` for a listing of all the included operators. The API is also designed to be easily extensible, see <doc:creating-custom-operators> for details.

## Topics

### Articles
- <doc:creating-custom-operators>

### Assertion
These are the main types that power the Gauntlet API.
- ``Assertion``
- ``AssertionResult``
- ``FailureReason``
- ``FailureRecorder``

### Convertibles
These protocols are used to create extensions on Assertion for a generic type while preserving the generic values.
- ``AssertionConvertible``
- ``ResultConvertible``
- ``OptionalConvertible``

### Throwing
These types allow explicitly handling throwing code in assertions.
- ``ThrowableExpression``
- ``ThrowableExpressionProtocol``
- ``AsyncThrowableExpression``
- ``AsyncThrowableExpressionProtocol``

### Testing
These are types used in unit tests for Gauntlet, and can be used for testing custom assertion operators.
- ``MockFailureRecorder``
- ``RecordedFailure``
