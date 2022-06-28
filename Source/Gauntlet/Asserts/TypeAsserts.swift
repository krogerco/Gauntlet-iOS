//  TypeAsserts.swift
//
//  MIT License
//
//  Copyright (c) [2020] The Kroger Co. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import XCTest

/// Asserts that the value is not `nil` and is the `expectedType`.
///
/// This function provides the ability to do type checking in tests with useful failure messaging. Additionally you can provide a closure to be called if the value is of the expected type.
/// The closure is a great way to help make these tests cleaner by removing the need to add redundant casting, guards that may prevent further tests from running, or optional chaining.
///
///     // Given
///     let product = Product(name: "Halibut", ...)
///
///     // When
///     let userInfo: [String: Any] = product.asUserInfo
///
///     // Then
///     XCTAssert(userInfo["name"], is: String.self) { name in
///         XCTAssertEqual(name, "Halibut")
///     }
///
///
/// - Parameters:
///   - expression:   An expression of type `Any?`.
///   - expectedType: The type `value` is expected to be.
///   - message:      An optional description of the failure.
///   - reporter:     The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:         The file in which failure occurred. Defaults to the file name of the test case in which this
///                   function was called.
///   - line:         The line number on which failure occurred. Defaults to the line number on which this function was
///                   called.
///   - then:         A closure to be called if `value` can be cast to the `expectedType`. This can be used
///                   to run additonal tests when the value is the `expectedType`.
public func XCTAssert<ExpectedType>(
    _ expression: @autoclosure () throws -> Any?,
    is expectedType: ExpectedType.Type,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: (ExpectedType) throws -> Void = { _ in })
{
    let name = "XCTAssert(_, is:)"
    assert(try expression(), is: expectedType, message, name: name, reporter: reporter, file: file, line: line, then: then)
}

/// Asserts that the value is not `nil`, is the `expectedType`, and is equal to the provided value.
///
/// This function provides the ability to do type checking and equality comparison in tests with useful failure messaging.
///
///     // Given
///     let product = Product(name: "Halibut", ...)
///
///     // When
///     let userInfo: [String: Any] = product.asUserInfo
///
///     // Then
///     XCTAssert(userInfo["name"], is: String.self, equalTo: "Halibut")
///
/// - Parameters:
///   - expression:    An expression of type `Any?`.
///   - expectedType:  The type `value` is expected to be, must be `Equatable`.
///   - expectedValue: The expected value of the expression.
///   - message:       An optional description of the failure.
///   - reporter:      The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:          The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - line:          The line number on which failure occurred. Defaults to the line number on which this function was called.
///   - then:          A closure to be called if `value` can be cast to the `expectedType` and equal to the expected value. This can be used
///                    to run additonal tests on the value..
public func XCTAssert<ExpectedType: Equatable>(
    _ expression: @autoclosure () throws -> Any?,
    is expectedType: ExpectedType.Type,
    equalTo expectedValue: ExpectedType,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: () throws -> Void = { })
{
    let name = "XCTAssert(_, is:, equalTo:)"
    assert(try expression(), is: expectedType, message, name: name, reporter: reporter, file: file, line: line) { value in
        guard value == expectedValue else {
            reporter.reportFailure(
                description: "\(name) - \(value) is not equal to \(expectedValue)\(suffix(from: message))",
                file: file,
                line: line
            )

            return
        }

        try then()
    }
}

// MARK: - Internal

/// This function contains the implementation for XCTAssert(_, is: ) and is meant for internal use by other Assert functions that want to do
/// type checking as part of the assert. This has no default values and adds the `name` parameter so that calling functions can pass theier name
/// for correct error messaging.
func assert<ExpectedType>(
    _ expression: @autoclosure () throws -> Any?,
    is expectedType: ExpectedType.Type,
    _ message: () -> String,
    name: String,
    reporter: FailureReporter,
    file: StaticString,
    line: UInt,
    then: (ExpectedType) throws -> Void)
{
    let result = catchErrors(
        in: expression,
        message: message,
        name: name,
        reporter: reporter,
        file: file,
        line: line
    )

    guard case let .success(optionalValue) = result else { return }
    guard let value = optionalValue else {
        let failureMessage = """
        \(name) - value is nil and cannot be checked for conformance to type \
        \(String(describing: ExpectedType.self))\(suffix(from: message))
        """

        reporter.reportFailure(description: failureMessage, file: file, line: line)

        return
    }

    if let castValue = value as? ExpectedType {
        failIfThrows(try then(castValue), message: message, name: name, reporter: reporter, file: file, line: line)
    } else {
        let failureMessage = """
        \(name) - value of type \(String(describing: type(of: value))) is not expected type \
        \(String(describing: ExpectedType.self))\(suffix(from: message))
        """

        reporter.reportFailure(description: failureMessage, file: file, line: line)
    }
}
