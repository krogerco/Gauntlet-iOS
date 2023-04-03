# ``GauntletLegacy``

A set of methods that extend and enhance the functionality of XCTest.

## Overview

Gauntlet is a collection of testing utility methods that aims to make writing great tests easier and with more helpful and descriptive failure states. It is only intended for inclusion in test cases. It has a dependency on `XCTest` but no external dependencies.

Gauntlet augments the standard XCTest unit testing methods to make unit tests more expressive and easier to read. Many of the methods in Gauntlet mirror those present in XCTest (e.g. `XCTAsserEqual`) but additionally include a closure that will be called if the assert passes.

For example, a typical unit test might look like:

```swift
func testSomething() throws {
    // Given
    let model = Model()

    // When
    model.doSomething()

    // Then
    XCTAssertNotNil(model.file)
    if let file = model.file {
        XCTAssertNotNil(file.url)

        if let url = file.url {
            XCTAssertEqual(url.lastPathComponent, "myFile.json")
        }

        XCTAssertFalse(file.exists())
    }
}
```

Unit tests involving optionals are commonly written like the above, either relying on force-unwraps or manual unwrapping of optionals to write all of the needed asserts. This leads to the following problems:
- Force unwraps make the tests fragile. If the conditions are not met, the test will crash and no other tests will be run. You cannot know how many other tests would have passed or failed.
- Manual unwrapping clutters up the code, and can lead to needing to write inline ternary statements to get the type needed for an assert.
- You may need to disable swiftlint rules for your unit tests.
- The expectation tree cannot be easily understood. if the first assert fails, there is no point in testing the following asserts.

A better version of this might look like the following:

```swift
import Gauntlet
import XCTest

func testSomething() throws {
    // Given
    let model = Model()

    // When
    model.doSomething()

    // Then
    XCTAssertNotNil(model.file) { file in
        XCTAssertNotNil(file.url) { url in
            XCTAssertEqual(url.lastPathComponent, "myFile.json")
        }
        XCTAssertFalse(file.exists())
    }
}
```

The fragility of the force unwraps has been eliminated, at the cost of readability of the code. Control flow is now intermingled with asserts.

Using Gauntlet and the addition of assert closures that are only executed on success, the meaning and expectations of the test become significantly more clear. When `XCTAssertNotNil` succeeds, the closure is called with the unwrapped value, ready to use in the next assert.

This leads to the following benefits:
- You can tell at a glance what are the expectations of the test.
- Optionals are safely unwrapped with minimal visual clutter.
- Follow-on asserts are only executed when appropriate.
- Code is compact and readable.

This functionality is made available to many of the assert methods you use today, and can be taken advantage of simply by adding a trailing closure.

For example, this code ensures you can test the contents of specific array indicies without crashing if the array is underfilled.

```swift
XCTAssertEqual(myArray.count, 2) {
    XCTAssertEqual(myArray[0], "Hello")
    XCTAssertEqual(myArray[1], "World")
}
```

Other asserts also help remove boilerplate code when working with types like `Result`.

```swift
// Given, When
let result: Result<Any, Error> = ...

// Then
XCTAssertSuccess(result, is: String.self) { value in
    XCTAssertFalse(value.isEmpty)
}
```

In this case, `XCTAssertSuccess` eliminates the boilerplate code needed to convert the success type to the desired type and the switch statement that would subsequently needed for `.success` and `.failure`.

There are assert additions for a variety of cases, including: true, false, empty collections, equality, optionals, results, types, and more.

> Note: Each function includes optional parameters for `reporter`, `file`, and `line`. These are hooks to test the functions themselves and in 99% of cases should be left to their default values for best results.

## Why are they named like the XCTest provided methods?

We debated this very point quite a bit when writing Gauntlet. By sticking with the existing method prefixes we gain substantial benefits:

- The discoverability of the enhanced methods is greatly increased. As you type the normal `XCT` prefix, auto-complete will list all possible variations that are available, including the new methods.
- Readability at the call site is greatly increased. They look and read like the XCTest methods a developer is already familiar with.

In the unlikely event of a name collision in the future , the namespace of the module (either `XCTest` or `Gaunlet`) can be prepended at the callsite to disambiguate. If this were to happen, we would obviously strive to resolve this in a subsequent version of Gauntlet.

## Extensions

Gauntlet also includes some extensions that can be useful when writing tests.

A static property `currentQueueLabel` has been added to `DispatchQueue`. This is useful when testing code that takes a queue that it calls a completion on to verify that the completion was called on the queue that was passed to that code.

## Topics

### Async/Await

These functions provide asserts for working with async code.

- ``XCTAwaitAssertEqual(_:_:_:reporter:file:line:then:)-6e67i``
- ``XCTAwaitAssertEqual(_:_:_:reporter:file:line:then:)-26cea``
- ``XCTAwaitAssertFalse(_:_:reporter:file:line:then:)``
- ``XCTAwaitAssertNoThrow(_:_:reporter:file:line:then:)``
- ``XCTAwaitAssertNotNil(_:_:reporter:file:line:then:)``
- ``XCTAwaitAssertThrowsError(_:equalTo:_:reporter:file:line:then:)``
- ``XCTAwaitAssertThrowsError(_:ofType:_:reporter:file:line:then:)``
- ``XCTAwaitAssertTrue(_:_:reporter:file:line:then:)``

### Booleans

- ``XCTAssertTrue(_:_:reporter:file:line:then:)``
- ``XCTAssertFalse(_:_:reporter:file:line:then:)``

### Collections

These functions add additional asserts for `Collection` type.

- ``XCTAssertIsEmpty(_:_:reporter:file:line:then:)``
- ``XCTAssertIsNotEmpty(_:_:reporter:file:line:then:)``

### Dispatch Queues

A static property `currentQueueLabel` has been added to `DispatchQueue`. This is useful when testing code that takes a queue that it calls a completion on to verify that the completion was called on the queue that was passed to that code.

- ``XCTAssertOnQueue(_:_:reporter:file:line:then:)``

### Equality

These functions add additional asserts for `Equatable`, `AnyObject` and `BinaryInteger` types.

- ``XCTAssertEqual(_:_:_:reporter:file:line:then:)``
- ``XCTAssertIdentical(_:_:_:reporter:file:line:then:)``
- ``XCTAssertNotIdentical(_:_:_:reporter:file:line:then:)``
- ``XCTAssertZero(_:_:reporter:file:line:then:)``

### Optionals

These functions add additional asserts for `Optional` values and provide closures for the unwrapped value if available.

- ``XCTAssertNotNil(_:_:reporter:file:line:then:)``

### Result Failure

- ``XCTAssertFailure(_:_:reporter:file:line:then:)``
- ``XCTAssertFailure(_:equalTo:_:reporter:file:line:then:)``
- ``XCTAssertFailure(_:is:_:reporter:file:line:then:)``
- ``XCTAssertFailure(_:is:equalTo:_:reporter:file:line:then:)``

### Result Success

- ``XCTAssertSuccess(_:_:reporter:file:line:then:)``
- ``XCTAssertSuccess(_:is:_:reporter:file:line:then:)``
- ``XCTAssertSuccess(_:equalTo:_:reporter:file:line:then:)``
- ``XCTAssertSuccess(_:is:equalTo:_:reporter:file:line:then:)``
- ``XCTAssertSuccess(_:keyPath:isEqualTo:_:reporter:file:line:then:)``


### Substrings

These functions add asserts for `String` types.

- ``XCTAssert(_:contains:_:reporter:file:line:then:)``

### Throws

These functions add asserts for validating errors thrown from functions.

- ``XCTAssertThrowsError(_:ofType:_:reporter:file:line:then:)``
- ``XCTAssertThrowsError(_:equalTo:_:reporter:file:line:then:)``
- ``XCTAssertNoThrow(_:_:reporter:file:line:then:)``

### Type Conformance

These functions add asserts for validating type conformance.

- ``XCTAssert(_:is:_:reporter:file:line:then:)``
- ``XCTAssert(_:is:equalTo:_:reporter:file:line:then:)``

### Failure Reporting
- ``FailureReporter``
- ``XCTestReporter``
