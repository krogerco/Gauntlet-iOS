//  OptionalAsserts.swift
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

/// Asserts the value is not `nil`.
///
/// This function provides the same behavior as the `XCTAssertNotNil` function provided in `XCTest` but adds a closure that's called when the value is not `nil`, providing a strongly typed non-optional reference to the property.
/// This simple addition makes tests around optional values much cleaner and easier to read by removing the need to add redundant conditional logic, guards that may prevent further tests from running, or optional chaining.
///
///     // Given
///     let jsonData = ...
///     let decoder = JSONDecoder()
///
///     // When
///     let product = try decoder.decode(Product.self, from: jsonData)
///
///     // Then
///     XCTAssertEqual(product.name, "Halibut")
///     XCTAssertNotNil(product.details) { details in
///         XCTAssertEqual(details.description, "Fresh halibut from Alaska.")
///         XCTAssertEqual(details.sku, "8111922120")
///     }
///
/// - Parameters:
///   - expression: An expression of type `T?` to compare against `nil`.
///   - message:    An optional description of the failure.
///   - reporter:   The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:       The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - line:       The line number on which failure occurred. Defaults to the line number on which this function was called.
///   - then:       A closure to be called if the `value` is not `nil`. This can be used to run additional tests on the value.
public func XCTAssertNotNil<T>(
    _ expression: @autoclosure () throws -> T?,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: (T) throws -> Void)
{
    let name = "XCTAssertNotNil"
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
        reporter.reportFailure(description: "\(name)\(suffix(from: message))", file: file, line: line)
        return
    }

    failIfThrows(try then(value), message: message, name: name, reporter: reporter, file: file, line: line)
}

/// Asserts the value is not `nil`.
///
/// This function provides the same behavior as the `XCTAssertNotNil` function provided in `XCTest` but adds a closure that's called when the value is not `nil`, providing a strongly typed non-optional reference to the property.
/// This simple addition makes tests around optional values much cleaner and easier to read by removing the need to add redundant conditional logic, guards that may prevent further tests from running, or optional chaining.
///
///     await XCTAwaitAssertNotNil(await getCurrentSession()) { session in
///         XCTAssertEqual(userId, session.userId)
///     }
///
/// - Parameters:
///   - expression: An expression of type `T?` to compare against `nil`.
///   - message:    An optional description of the failure.
///   - reporter:   The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:       The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - line:       The line number on which failure occurred. Defaults to the line number on which this function was called.
///   - then:       A closure to be called if the `value` is not `nil`. This can be used to run additional tests on the value.
@available(iOS 13.0.0, tvOS 13.0.0, macOS 10.15.0, *)
public func XCTAwaitAssertNotNil<T: Sendable>(
    _ expression: @autoclosure () async throws -> T?,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: (T) async throws -> Void = { _ in })
async {
    let name = "XCTAwaitAssertNotNil"
    let result = await catchErrors(
        in: expression,
        message: message,
        name: name,
        reporter: reporter,
        file: file,
        line: line
    )

    guard case let .success(optionalValue) = result else { return }
    guard let value = optionalValue else {
        reporter.reportFailure(description: "\(name)\(suffix(from: message))", file: file, line: line)
        return
    }

    await failIfThrows(try await then(value), message: message, name: name, reporter: reporter, file: file, line: line)
}
