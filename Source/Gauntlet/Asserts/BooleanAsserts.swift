//  BooleanAsserts.swift
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

// We want to allow asserting on optional `Bool` for situations where that can be useful.
// swiftlint:disable discouraged_optional_boolean

/// Asserts that the expression is not `nil` and is `true`.
///
///     // Given
///     let values: [String: Bool] = ...
///
///     // When, Then
///     XCTAssertTrue(values["Some Key"]) {
///         // Optionally perform additional conditional tests.
///     }
///
/// - Note:
///     This assert will fail if the result of the expression is `nil`.
///
/// - Parameters:
///   - expression: An expression of type `Bool`.
///   - message:    An optional description of the failure.
///   - reporter:   The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:       The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - line:       The line number on which failure occurred. Defaults to the line number on which this function was called.
///   - then:       A closure to be called if the value is `true`. This can be used to run additional tests on the values.
public func XCTAssertTrue(
    _ expression: @autoclosure () throws -> Bool?,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: () throws -> Void = { })
{
    let name = "XCTAssertTrue"
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
        reporter.reportFailure(
            description: "\(name) - (\"nil\") is not true\(suffix(from: message))",
            file: file,
            line: line
        )

        return
    }

    guard value == true else {
        reporter.reportFailure(
            description: "\(name) - (\"\(value)\") is not true\(suffix(from: message))",
            file: file,
            line: line
        )

        return
    }

    failIfThrows(try then(), message: message, name: name, reporter: reporter, file: file, line: line)
}

/// Asserts that the expression is not `nil` and is `true`.
///
///     // Given
///     func values() async -> [String: Bool] { ... }
///
///     // When, Then
///     await XCTAwaitAssertTrue(await values()["some-key"]) {
///         // Optionally perform additional conditional tests.
///     }
///
/// - Note:
///     This assert will fail if the result of the expression is `nil`.
///
/// - Parameters:
///   - expression: An expression of type `Bool`.
///   - message:    An optional description of the failure.
///   - reporter:   The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:       The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - line:       The line number on which failure occurred. Defaults to the line number on which this function was called.
///   - then:       A closure to be called if the value is `true`. This can be used to run additional tests on the values.
@available(iOS 13.0.0, tvOS 13.0.0, macOS 10.15.0, *)
public func XCTAwaitAssertTrue(
    _ expression: @autoclosure () async throws -> Bool?,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: () async throws -> Void = { }) async
{
    let name = "XCTAwaitAssertTrue"
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
        reporter.reportFailure(
            description: "\(name) - (\"nil\") is not true\(suffix(from: message))",
            file: file,
            line: line
        )

        return
    }

    guard value == true else {
        reporter.reportFailure(
            description: "\(name) - (\"\(value)\") is not true\(suffix(from: message))",
            file: file,
            line: line
        )

        return
    }

    await failIfThrows(try await then(), message: message, name: name, reporter: reporter, file: file, line: line)
}

/// Asserts that the expression is not `nil` and is `false`.
///
///     // Given
///     let values: [String: Bool] = ...
///
///     // When, Then
///     XCTAssertFalse(values["Some Key"]) {
///         // Optionally perform additional conditional tests.
///     }
///
/// - Note:
///     This assert will fail if the result of the expression is `nil`.
///
/// - Parameters:
///   - expression: An expression of type `Bool`.
///   - message:    An optional description of the failure.
///   - reporter:   The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:       The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - line:       The line number on which failure occurred. Defaults to the line number on which this function was called.
///   - then:       A closure to be called if the value is `false`. This can be used to run additional tests on the values.
public func XCTAssertFalse(
    _ expression: @autoclosure () throws -> Bool?,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: () throws -> Void = { })
{
    let name = "XCTAssertFalse"
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
        reporter.reportFailure(
            description: "\(name) - (\"nil\") is not false\(suffix(from: message))",
            file: file,
            line: line
        )

        return
    }

    guard value == false else {
        reporter.reportFailure(
            description: "\(name) - (\"\(value)\") is not false\(suffix(from: message))",
            file: file,
            line: line
        )

        return
    }

    failIfThrows(try then(), message: message, name: name, reporter: reporter, file: file, line: line)
}

/// Asserts that the expression is not `nil` and is `false`.
///
///     // Given
///     func values() async -> [String: Bool] { ... }
///
///     // When, Then
///     await XCTAwaitAssertFalse(await values()["some-key"]) {
///         // Optionally perform additional conditional tests.
///     }
///
/// - Note:
///     This assert will fail if the result of the expression is `nil`.
///
/// - Parameters:
///   - expression: An expression of type `Bool`.
///   - message:    An optional description of the failure.
///   - reporter:   The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:       The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - line:       The line number on which failure occurred. Defaults to the line number on which this function was called.
///   - then:       A closure to be called if the value is `false`. This can be used to run additional tests on the values.
@available(iOS 13.0.0, tvOS 13.0.0, macOS 10.15.0, *)
public func XCTAwaitAssertFalse(
    _ expression: @autoclosure () async throws -> Bool?,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: () async throws -> Void = { }) async
{
    let name = "XCTAwaitAssertFalse"
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
        reporter.reportFailure(
            description: "\(name) - (\"nil\") is not false\(suffix(from: message))",
            file: file,
            line: line
        )

        return
    }

    guard value == false else {
        reporter.reportFailure(
            description: "\(name) - (\"\(value)\") is not false\(suffix(from: message))",
            file: file,
            line: line
        )

        return
    }

    await failIfThrows(try await then(), message: message, name: name, reporter: reporter, file: file, line: line)
}
