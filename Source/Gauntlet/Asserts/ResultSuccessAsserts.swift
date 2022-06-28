//  ResultSuccessAsserts.swift
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

import Foundation
import XCTest

/// Asserts that the `Result` is not `nil` and is `.success`.
///
/// This function simplifies testing `Result`. It will validate that the result is not `nil`, and that it's a `.success`.
/// If those conditions are met it will call the optionally provided closure with the associated value of the success so that you can conditionally perform additional tests on that value.
///
///     // Given, When
///     let result: Result<String, Error> = ...
///
///     // Then
///     XCTAssertSuccess(result) { value in
///         XCTAssertFalse(value.isEmpty)
///     }
///
/// - Parameters:
///   - expression: An expression of type `Result<Success, Failure>?`.
///   - message:    An optional description of the failure.
///   - reporter:   The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:       The file in which failure occurred. Defaults to the file name of the test case in which this
///                 function was called.
///   - line:       The line number on which failure occurred. Defaults to the line number on which this function was
///                 called.
///   - then:       A closure to be called if the `Result` is `.success`. This can be used to run additional tests with
///                 the associated value.
public func XCTAssertSuccess<Success, Failure>(
    _ expression: @autoclosure () throws -> Result<Success, Failure>?,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: (Success) throws -> Void = { _ in })
{
    let name = "XCTAssertSuccess"
    let catchResult = catchErrors(
        in: expression,
        message: message,
        name: name,
        reporter: reporter,
        file: file,
        line: line
    )

    guard case let .success(optionalResult) = catchResult else { return }
    guard let result = optionalResult else {
        reporter.reportFailure(description: "\(name) - Result is nil\(suffix(from: message))", file: file, line: line)

        return
    }

    switch result {
    case .success(let value):
        failIfThrows(try then(value), message: message, name: name, reporter: reporter, file: file, line: line)

    case .failure(let error):
        reporter.reportFailure(
            description: "\(name) - Result is .failure(\"\(error)\")\(suffix(from: message))",
            file: file,
            line: line
        )
    }
}

/// Asserts that the `Result`is `.success` and the associated `Success` value is equal to the provided value.
///
/// This function simplifies testing `Result` where the `Success` value is `Equatable`. It will validate that the result is not `nil`, and that it's a success case.
/// If those conditions are met it will then compare the associated success value with the provided value.
///
///     // Given, When
///     let result: Result<String, Error> = ...
///
///     // Then
///     XCTAssertSuccess(result, equalTo: "expected value")
///
/// - Parameters:
///   - expression:      An expression of type `Result<Success, Failure>?` where `Success` is `Equatable`.
///   - expectedSuccess: The value equal to the associated value in the `.success` case.
///   - message:         An optional description of the failure.
///   - reporter:        The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:            The file in which failure occurred. Defaults to the file name of the test case in which this
///                      function was called.
///   - line:            The line number on which failure occurred. Defaults to the line number on which this function
///                      was called.
///   - then:            A closure to be called if the `Result` is `.success` and the value is equal to the provided value. This can be used to run
///                      additional tests with the `Success` value.
public func XCTAssertSuccess<Success: Equatable, Failure>(
    _ expression: @autoclosure () throws -> Result<Success, Failure>?,
    equalTo expectedSuccess: Success,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: () throws -> Void = { })
{
    let name = "XCTAssertSuccess"
    XCTAssertSuccess(try expression(), message(), reporter: reporter, file: file, line: line) { value in
        guard value == expectedSuccess else {
            reporter.reportFailure(
                description: "\(name) - (\"\(value)\") is not equal to (\"\(expectedSuccess)\")\(suffix(from: message))",
                file: file,
                line: line
            )
            return
        }

        try then()
    }
}

/// Asserts that the `Result`is `.success` and the specified `KeyPath` of the associated `Success` value is equal to the provided value.
///
/// This function simplifies testing `Result` where you want to check the value of one property on the `Success` value. It will validate that the result is not `nil`, and that it's a success case.
/// If those conditions are met it will then compare the value of the keyPath on the associated success value with the provided value.
///
///     // Given, When
///     let result: Result<User, Error> = ...
///
///     // Then
///     XCTAssertSuccess(result, keyPath: \.name, isEqualTo: "expected name")
///
/// - Parameters:
///   - expression:    An expression of type `Result<Success, Failure>?` where `Success` is `Equatable`.
///   - keyPath:       The KeyPath on `Success` to compare against the `expectedValue`.
///   - expectedValue: The value equal to the associated value in the `.success` case.
///   - message:       An optional description of the failure.
///   - reporter:      The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:          The file in which failure occurred. Defaults to the file name of the test case in which this
///                    function was called.
///   - line:          The line number on which failure occurred. Defaults to the line number on which this function
///                    was called.
///   - then:          A closure to be called if the `Result` is `.success` and the value at the keypath is equal to the provided value. This can be used to run
///                    additional tests with the `Success` value.
public func XCTAssertSuccess<Success, Failure, Value: Equatable>(
    _ expression: @autoclosure () throws -> Result<Success, Failure>?,
    keyPath: KeyPath<Success, Value>,
    isEqualTo expectedValue: Value,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: () throws -> Void = { })
{
    let name = "XCTAssertSuccess"
    XCTAssertSuccess(try expression(), message(), reporter: reporter, file: file, line: line) { successValue in
        let value = successValue[keyPath: keyPath]
        guard value == expectedValue else {
            reporter.reportFailure(
                description: "\(name) - (\"\(value)\") is not equal to (\"\(expectedValue)\")\(suffix(from: message))",
                file: file,
                line: line
            )

            return
        }

        try then()
    }
}

/// Asserts that the `Result` is not `nil`, is `.success`, and that the associated `Success` is the expected type.
///
/// This function simplifies testing `Result` when you need to also validate the type of the `Success` value.
/// It will validate that the result is not `nil`, that it's a success case, and that the associated success value is of the specified type.
/// If those conditions are met it will call the optionally provided closure with the success value cast to the specified type so that you can conditionally perform additional tests on the value.
///
///     // Given, When
///     let result: Result<Any, Error> = ...
///
///     // Then
///     XCTAssertSuccess(result, is: String.self) { value in
///         XCTAssertFalse(value.isEmpty)
///     }
///
/// - Parameters:
///   - expression:   An expression of type `Result<Success, Failure>?`.
///   - expectedType: The expected type of the `Success`.
///   - message:      An optional description of the failure.
///   - reporter:     The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:         The file in which failure occurred. Defaults to the file name of the test case in which this
///                   function was called.
///   - line:         The line number on which failure occurred. Defaults to the line number on which this function was
///                   called.
///   - then:         A closure to be called if the `Result` is `.success` and the `Success` is of the expected type.
///                   This can be used to run additional tests with the `Success` value.
public func XCTAssertSuccess<Success, Failure, ExpectedSuccess>(
    _ expression: @autoclosure () throws -> Result<Success, Failure>?,
    is expectedType: ExpectedSuccess.Type,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: (ExpectedSuccess) throws -> Void = { _ in })
{
    XCTAssertSuccess(try expression(), message(), reporter: reporter, file: file, line: line) { value in
        assert(value, is: expectedType, message, name: "XCTAssertSuccess", reporter: reporter, file: file, line: line, then: then)
    }
}

/// Asserts that the `Result` is not `nil`, is `.success`, the associated `Success` is the expected type, and is equal to the expectedSuccess.
///
/// This function simplifies testing `Result` when you need to also validate the type of the `Success` value, and that type is `Equatable`.
/// It will validate that the result is not `nil`, that it's a `.success`, and that the associated success value is of the specified type.
/// If those conditions are met it will then compare the associated value with the provided value.
///
///     // Given, When
///     let result: Result<Any, Error> = ...
///
///     // Then
///     XCTAssertSuccess(result, is: String.self, equalTo: "expected value")
///
/// - Parameters:
///   - expression:      An expression of type `Result<Success, Failure>?`.
///   - expectedType:    The expected type of the `Success`.
///   - expectedSuccess: The value to be compared to the associated value in the `.success` case.
///   - message:         An optional description of the failure.
///   - reporter:        The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:            The file in which failure occurred. Defaults to the file name of the test case in which this
///                      function was called.
///   - line:            The line number on which failure occurred. Defaults to the line number on which this function was
///                      called.
///   - then:            A closure to be called if the `Result` is `.success` and the `Success` is of the expected type and equal to the provided value.
///                      This can be used to run additional tests with the `Success` value.
public func XCTAssertSuccess<Success, Failure, ExpectedSuccess: Equatable>(
    _ expression: @autoclosure () throws -> Result<Success, Failure>?,
    is expectedType: ExpectedSuccess.Type,
    equalTo expectedSuccess: ExpectedSuccess,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: () throws -> Void = { })
{
    let name = "XCTAssertSuccess"
    XCTAssertSuccess(try expression(), is: expectedType, message(), reporter: reporter, file: file, line: line) { value in
        guard value == expectedSuccess else {
            reporter.reportFailure(
                description: "\(name) - (\"\(value)\") is not equal to (\"\(expectedSuccess)\")\(suffix(from: message))",
                file: file,
                line: line
            )

            return
        }

        try then()
    }
}
