# Gauntlet

## What is Gauntlet?

Gauntlet is an extensible, functional API for writing unit test assertions in Swift, built on top of XCTest. It is only intended for inclusion in test cases. It has a dependency on `XCTest` but no external dependencies.

## Requirements

- XCode 14.2+
- Swift 5.7+

## Installation

The easiest way to install Gauntlet is by adding a dependency via SPM.

```swift
        .package(
            name: "Gauntlet",
            url: "https://github.com/krogerco/gauntlet-ios.git",
            .upToNextMajor(from: Version(2, 0, 0))
        )
```

… then reference in your test target.

```swift
        .testTarget(
            name: "MyTests",
            dependencies: ["MyFramework", "Gauntlet"],
            path: "MyFrameworkTests"
        )
```

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

Gauntlet includes a `then` operator which can be used to break an Assertion out into more assertions that are only run when the original Assertion passes.

```swift
let model = Model()

// When
let result: Result<Content, Error> = model.loadContent()

Assert(that: result).isSuccess().then { content in
    Assert(that: content.id).isEqualTo("expected id")
    ...
}
```

Gauntlet provides a number of operators, and is designed to be extensible so that you can build and test your own operators easily. Check the [docs](#documentation) for more details.

## Documentation

Gauntlet has full DocC documentation. After adding to your project, `Build Documentation` to add to your documentation viewer.

### Online Documentation

[Full Documentation](https://krogerco.github.io/Gauntlet-iOS/documentation/gauntlet)

## Migration

If you're migrating from Gauntlet 1.x check out the [migration guide](migration-guide.md) for details on how to upgrade to the new APIs.

## Communication

If you have issues or suggestions, please open an issue on GitHub.
