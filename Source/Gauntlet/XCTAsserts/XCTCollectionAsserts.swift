//  XCTCollectionAsserts.swift
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

/// Asserts the provided collection is empty.
///
///     // Given
///     let array = [Int]()
///
///     // When, Then
///     XCTAssertIsEmpty(array) {
///         // Optionally perform additional conditional tests.
///     }
///
/// - Parameters:
///   - expression: An expression of type Collection to compare against empty.
///   - message:    An optional description of the failure.
///   - reporter:   The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:       The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - line:       The line number on which failure occurred. Defaults to the line number on which this function was called.
///   - then:       An optional closure to be called if the Collection is empty. This can be used to run additional tests on the collection.
public func XCTAssertIsEmpty<T: Collection>(
    _ expression: @autoclosure () throws -> T,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: () throws -> Void = { })
{
    let name = "XCTAssertIsEmpty"
    let result = catchErrors(
        in: expression,
        message: message,
        name: name,
        reporter: reporter,
        file: file,
        line: line
    )

    guard case let .success(value) = result else { return }
    guard value.isEmpty else {
        reporter.reportFailure(description: "\(name)\(suffix(from: message))", file: file, line: line)
        return
    }

    failIfThrows(try then(), message: message, name: name, reporter: reporter, file: file, line: line)
}

/// Asserts the collection is not empty, if `true` calls the provided closure.
///
///     // Given
///     let powerLevels = [9001]
///
///     // When, Then
///     XCTAssertIsNotEmpty(powerLevels) { array in
///         // Optionally perform additional conditional tests.
///     }
///
/// - Parameters:
///   - expression: An expression of type Collection to compare against empty.
///   - message:    An optional description of the failure.
///   - reporter:   The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:       The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - line:       The line number on which failure occurred. Defaults to the line number on which this function was called.
///   - then:       An optional closure to be called if the Collection is not `nil` and not empty. This can be used to run additional tests on the Collection.
public func XCTAssertIsNotEmpty<T: Collection>(
    _ expression: @autoclosure () throws -> T?,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: (T) throws -> Void = { _ in })
{
    let name = "XCTAssertIsNotEmpty"
    let result = catchErrors(
        in: expression,
        message: message,
        name: name,
        reporter: reporter,
        file: file,
        line: line
    )

    guard case let .success(optionalValue) = result else { return }
    guard let collection = optionalValue, !collection.isEmpty else {
        reporter.reportFailure(description: "\(name)\(suffix(from: message))", file: file, line: line)
        return
    }

    failIfThrows(try then(collection), message: message, name: name, reporter: reporter, file: file, line: line)
}
