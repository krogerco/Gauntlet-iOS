//  XCTResultFailureAsserts.swift
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

/// Asserts that the `Result` is not `nil` and is `.failure`.
///
/// This function simplifies testing `Result`. It will validate that the result is not `nil`, and that it is a `.failure`.
/// If those conditions are met it will call the optionally provided closure with the associated value of the failure so that you can conditionally perform additional tests on that value.
///
///     // Given, When
///     let result: Result<String, CustomError> = ...
///
///     // Then
///     XCTAssertFailure(result) { value in
///         XCTAssertEqual(value.debugDescription, "expected error description")
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
///   - then:       A closure to be called if the `Result` is `.failure`. This can be used to run additional tests with
///                 the `Failure` value.
public func XCTAssertFailure<Success, Failure>(
    _ expression: @autoclosure () throws -> Result<Success, Failure>?,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: (Failure) throws -> Void = { _ in })
{
    let name = "XCTAssertFailure"
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
    case .success:
        reporter.reportFailure(description: "\(name) - Result is .success\(suffix(from: message))", file: file, line: line)

    case .failure(let error):
        failIfThrows(try then(error), message: message, name: name, reporter: reporter, file: file, line: line)
    }
}

/// Asserts that the `Result`is `.failure` and the associated `Failure` value is equal to the provided value.
///
/// This function simplifies testing `Result` where the `Failure` value is `Equatable`. It will validate that the result is not `nil`, and that it's a `.failure`.
/// If those conditions are met it will then compare the associated failure value with the provided value.
///
///     // Given, When
///     let result: Result<String, CustomError> = ...
///
///     // Then
///     XCTAssertFailure(result, equalTo: .someSpecificError)
///
/// - Parameters:
///   - expression:      An expression of type `Result<Success, Failure>?` where `Failure` is `Equatable`.
///   - expectedFailure: The value equal to the associated value in the `.failure` case.
///   - message:         An optional description of the failure.
///   - reporter:        The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:            The file in which failure occurred. Defaults to the file name of the test case in which this
///                      function was called.
///   - line:            The line number on which failure occurred. Defaults to the line number on which this function
///                      was called.
///   - then:            A closure to be called if the `Result` is `.failure` and the error is equal to the expectedFailure.
///                      This can be used to run additional tests with the `Failure` value.
public func XCTAssertFailure<Success, Failure: Equatable>(
    _ expression: @autoclosure () throws -> Result<Success, Failure>?,
    equalTo expectedFailure: Failure,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: () throws -> Void = { })
{
    let name = "XCTAssertFailure"
    XCTAssertFailure(try expression(), message(), reporter: reporter, file: file, line: line) { value in
        guard value == expectedFailure else {
            reporter.reportFailure(
                description: "\(name) - (\"\(value)\") is not equal to (\"\(expectedFailure)\")\(suffix(from: message))",
                file: file,
                line: line
            )

            return
        }

        try then()
    }
}

/// Asserts that the `Result` is not `nil`, is a `.failure`, and that the associated `Failure` is the expected type.
///
/// This function simplifies testing `Result` when you need to also validate the type of the `Failure` value.
/// It will validate that the result is not `nil`, that it's a `.failure`, and that the associated failure value is of the specified type.
/// If those conditions are met it will call the optionally provided closure with the failure value cast to the specified type so that you can conditionally perform additional tests on the value.
///
///     // Given, When
///     let result: Result<String, Error> = ...
///
///     // Then
///     XCTAssertFailure(result, is: CustomError.self) { value in
///         XCTAssertEqual(value.debugDescription, "expected error description")
///     }
///

/// - Parameters:
///   - expression:   An expression of type `Result<Success, Failure>?`.
///   - expectedType: The expected type of the `Failure`.
///   - message:      An optional description of the failure.
///   - reporter:     The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:         The file in which failure occurred. Defaults to the file name of the test case in which this
///                   function was called.
///   - line:         The line number on which failure occurred. Defaults to the line number on which this function was
///                   called.
///   - then:         A closure to be called if the `Result` is `.failure` and the `Failure` is of the expected type.
///                   This can be used to run additional tests with the `Failure` value.
public func XCTAssertFailure<Success, Failure, ExpectedFailure>(
    _ expression: @autoclosure () throws -> Result<Success, Failure>?,
    is expectedType: ExpectedFailure.Type,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: (ExpectedFailure) throws -> Void = { _ in })
{
    let name = "XCTAssertFailure"
    XCTAssertFailure(try expression(), message(), reporter: reporter, file: file, line: line) { value in
        assert(value, is: expectedType, message, name: name, reporter: reporter, file: file, line: line, then: then)
    }
}

/// Asserts that the `Result` is not `nil`, is a `.failure`, the associated `Failure` is the expected type, and is equal to the expectedFailure.
///
/// This function simplifies testing `Result` when you need to also validate the type of the `Failure` value, and that type is `Equatable`.
/// It will validate that the result is not `nil`, that it's a `.failure`, and that the associated failure value is of the specified type.
/// If those conditions are met it will then compare the associated failure value with the provided value.
///
///     // Given, When
///     let result: Result<String, Error> = ...
///
///     // Then
///     XCTAssertFailure(result, is: CustomError.self, equalTo: .someSpecificError)
///
/// - Parameters:
///   - expression:      An expression of type `Result<Success, Failure>?`.
///   - expectedType:    The expected type of the `Failure`. Must be `Equatable`.
///   - expectedFailure: The value to be compared to the associated value in the `.failure` case.
///   - message:         An optional description of the failure.
///   - reporter:        The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:            The file in which failure occurred. Defaults to the file name of the test case in which this
///                      function was called.
///   - line:            The line number on which failure occurred. Defaults to the line number on which this function
///                      was called.
///   - then:            A closure to be called if the `Result` is `.failure` and the `Failure` is of the expected type and equal to the expectedFailre.
///                      This can be used to run additional tests with the `Failure` value.
public func XCTAssertFailure<Success, Failure, ExpectedFailure: Equatable>(
    _ expression: @autoclosure () throws -> Result<Success, Failure>?,
    is expectedType: ExpectedFailure.Type,
    equalTo expectedFailure: ExpectedFailure,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: () throws -> Void = { })
{
    let name = "XCTAssertFailure"
    XCTAssertFailure(try expression(), is: expectedType, message(), reporter: reporter, file: file, line: line) { value in
        guard value == expectedFailure else {
            reporter.reportFailure(
                description: "\(name) - (\"\(value)\") is not equal to (\"\(expectedFailure)\")\(suffix(from: message))",
                file: file,
                line: line
            )

            return
        }

        try then()
    }
}
