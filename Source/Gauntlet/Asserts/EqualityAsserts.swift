//  EqualityAsserts.swift
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

/// Asserts that two values are equal, then calls the provided optional closure if `true`.
///
///     // Given
///     let ford = Car(.ford)
///     let otherFord = Car(.ford)
///
///     // When, Then
///     XCTAssertEqual(ford, otherFord) {
///         // Perform additional conditional tests.
///     }
///
/// - Parameters:
///   - expression1: An expression of type `T?`.
///   - expression2: An expression of type `T?`.
///   - message:     An optional description of the failure.
///   - reporter:   The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:        The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - line:        The line number on which failure occurred. Defaults to the line number on which this function was called.
///   - then:        A closure to be called if the values are equal. This can be used to run additional tests on the values.
public func XCTAssertEqual<T>(
    _ expression1: @autoclosure () throws -> T?,
    _ expression2: @autoclosure () throws -> T?,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: () throws -> Void) where T: Equatable
{
    let name = "XCTAssertEqual"
    let result1 = catchErrors(
        in: expression1,
        message: message,
        name: name,
        reporter: reporter,
        file: file,
        line: line
    )

    let result2 = catchErrors(
        in: expression2,
        message: message,
        name: name,
        reporter: reporter,
        file: file,
        line: line
    )

    guard case let .success(value1) = result1 else { return }
    guard case let .success(value2) = result2 else { return }

    guard value1 == value2 else {
        let value1String: String
        let value2String: String

        if let value1 = value1 {
            value1String = String(describing: value1)
        } else {
            value1String = "nil"
        }

        if let value2 = value2 {
            value2String = String(describing: value2)
        } else {
            value2String = "nil"
        }

        reporter.reportFailure(
            description: "\(name) - (\"\(value1String)\") is not equal to (\"\(value2String)\")\(suffix(from: message))",
            file: file,
            line: line
        )

        return
    }

    failIfThrows(try then(), message: message, name: name, reporter: reporter, file: file, line: line)
}

/// Asserts that two object references are identical (`===`).
///
///     // Given
///     let view = UIView()
///
///     // When
///     let container = CustomContainerView(rootView: view))
///
///     // Then
///     XCTAssertIdentical(view, container.rootView, "The container's rootView should be the same object passed to the init.") { in
///         // Optionally perform additional conditional tests.
///     }
///
/// - Parameters:
///   - expression1: An expression of type `T?`.
///   - expression2: An expression of type `T?`.
///   - message:     An optional description of the failure.
///   - reporter:   The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:        The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - line:        The line number on which failure occurred. Defaults to the line number on which this function was called.
///   - then:        A closure to be called if the values are identical. This can be used to run additional tests on the value.
public func XCTAssertIdentical<T>(
    _ expression1: @autoclosure () throws -> T?,
    _ expression2: @autoclosure () throws -> T?,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: () throws -> Void = { }) where T: AnyObject
{
    let name = "XCTAssertIdentical"
    let result1 = catchErrors(
        in: expression1,
        message: message,
        name: name,
        reporter: reporter,
        file: file,
        line: line
    )

    let result2 = catchErrors(
        in: expression2,
        message: message,
        name: name,
        reporter: reporter,
        file: file,
        line: line
    )

    guard case let .success(value1) = result1 else { return }
    guard case let .success(value2) = result2 else { return }

    guard value1 === value2 else {
        reporter.reportFailure(description: "\(name)\(suffix(from: message))", file: file, line: line)
        return
    }

    failIfThrows(try then(), message: message, name: name, reporter: reporter, file: file, line: line)
}

/// Asserts that two object references are not identical (`!==`).
///
///     // Given
///     let ford = Car(.ford)
///     let otherFord = Car(.ford)
///
///     // When, Then
///     XCTAssertNotIdentical(ford, otherFord, "These cars should not be identical.") {
///         // Optionally perform additional conditional tests.
///     }
///
/// - Parameters:
///   - expression1: An expression of type `T?`.
///   - expression2: An expression of type `T?`.
///   - message:     An optional description of the failure.
///   - reporter:   The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:        The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - line:        The line number on which failure occurred. Defaults to the line number on which this function was called.
///   - then:        A closure to be called if the values are not identical. This can be used to run additional tests on the values.
public func XCTAssertNotIdentical<T>(
    _ expression1: @autoclosure () throws -> T?,
    _ expression2: @autoclosure () throws -> T?,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: () throws -> Void = { }) where T: AnyObject
{
    let name = "XCTAssertNotIdentical"
    let result1 = catchErrors(
        in: expression1,
        message: message,
        name: name,
        reporter: reporter,
        file: file,
        line: line
    )

    let result2 = catchErrors(
        in: expression2,
        message: message,
        name: name,
        reporter: reporter,
        file: file,
        line: line
    )

    guard case let .success(value1) = result1 else { return }
    guard case let .success(value2) = result2 else { return }

    guard value1 !== value2 else {
        reporter.reportFailure(description: "\(name)\(suffix(from: message))", file: file, line: line)
        return
    }

    failIfThrows(try then(), message: message, name: name, reporter: reporter, file: file, line: line)
}

/// Asserts that a value is zero.
///
///     // Given
///     let coordinator = ...
///
///     // When
///     coordinator.coordinateThings()
///
///     // Then
///     XCTAssertZero(coordinator.remainingTasks, "There should be no remaning tasks after coodinating things.") {
///         // Optionally perform additional conditional tests.
///     }
///
/// - Parameters:
///   - expression: An expression of type `T?`.
///   - message:    An optional description of the failure.
///   - reporter:   The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:       The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - line:       The line number on which failure occurred. Defaults to the line number on which this function was called.
///   - then:       A closure to be called if the value is zero. This can be used to perform additional conditional tests.
public func XCTAssertZero<T>(
    _ expression: @autoclosure () throws -> T,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: () throws -> Void = { }) where T: BinaryInteger
{
    let name = "XCTAssertZero"
    let result = catchErrors(
        in: expression,
        message: message,
        name: name,
        reporter: reporter,
        file: file,
        line: line
    )

    guard case let .success(value) = result else { return }

    guard value == 0 else {
        reporter.reportFailure(
            description: "\(name) - (\"\(value)\") is not 0\(suffix(from: message))",
            file: file,
            line: line
        )

        return
    }

    failIfThrows(try then(), message: message, name: name, reporter: reporter, file: file, line: line)
}
