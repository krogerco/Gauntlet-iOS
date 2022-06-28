//  ThrowsAsserts.swift
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

/// Asserts that the expression throws the expected `Error` type.
///
/// This function simplifies testing throwing code. When asserting that some code throws, you often care about the type of error that was thrown.
/// This allows enforcing that type as part of the assert with the provided closure getting the error that has ben cast to the expected type.
///
///     // Given, When
///     let file = File(named: "some file")
///
///     // Then
///     XCTAssertThrowsError(try file.load(), ofType: FileError.self) { error in
///         ...
///     }
/// 
/// - Parameters:
///   - expression: An expression expected to throw an error.
///   - errorType:  The type of error expected to be thrown.
///   - message:    An optional description of the failure.
///   - reporter:   The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:       The file in which failure occurred. Defaults to the file name of the test case in which this
///                 function was called.
///   - line:       The line number on which failure occurred. Defaults to the line number on which this function was
///                 called.
///   - then:       A closure to be called if the thrown `Error` is the expected type.
///                 This can be used to run additional tests with the error.
public func XCTAssertThrowsError<T: Error>(
    _ expression: @autoclosure () throws -> Any?,
    ofType errorType: T.Type,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: (T) throws -> Void = { _ in })
{
    let name = "XCTAssertThrowsError"
    do {
        _ = try expression()
        reporter.reportFailure(
            description: "\(name) - expression did not throw an error\(suffix(from: message))",
            file: file,
            line: line
        )

    } catch {
        guard let castError = error as? T else {
            let failureMessage = """
            \(name) - error of type \(String(describing: type(of: error))) is not expected type \
            \(String(describing: T.self))\(suffix(from: message))
            """

            reporter.reportFailure(description: failureMessage, file: file, line: line)
            return
        }

        failIfThrows(try then(castError), message: message, name: name, reporter: reporter, file: file, line: line)
    }
}

/// Asserts that the asynchronous expression throws the expected `Error` type.
///
/// This function simplifies testing throwing code. When asserting that some code throws, you often care about the type of error that was thrown.
/// This allows enforcing that type as part of the assert with the provided closure getting the error that has ben cast to the expected type.
///
///     // Given, When
///     let file = File(named: "some file")
///
///     // Then
///     await XCTAssertThrowsError(try await file.load(), ofType: FileError.self) { error in
///         ...
///     }
///
/// - Parameters:
///   - expression: An asynchronous expression expected to throw an error.
///   - errorType:  The type of error expected to be thrown.
///   - message:    An optional description of the failure.
///   - reporter:   The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:       The file in which failure occurred. Defaults to the file name of the test case in which this
///                 function was called.
///   - line:       The line number on which failure occurred. Defaults to the line number on which this function was
///                 called.
///   - then:       A closure to be called if the thrown `Error` is the expected type.
///                 This can be used to run additional tests with the error.
@available(iOS 13.0.0, tvOS 13.0.0, macOS 10.15.0, *)
public func XCTAssertThrowsError<T: Sendable, E: Error>(
    _ expression: @autoclosure () async throws -> T,
    ofType errorType: E.Type,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: (E) throws -> Void = { _ in }
) async {
    let name = "XCTAssertThrowsError"
    do {
        _ = try await expression()
        reporter.reportFailure(
            description: "\(name) - expression did not throw an error\(suffix(from: message))",
            file: file,
            line: line
        )

    } catch let expectedError as E {
        failIfThrows(try then(expectedError), message: message, name: name, reporter: reporter, file: file, line: line)
    } catch {
        let failureMessage = """
        \(name) - error of type \(String(describing: type(of: error))) is not expected type \
        \(String(describing: E.self))\(suffix(from: message))
        """

        reporter.reportFailure(description: failureMessage, file: file, line: line)
    }
}

/// Asserts that the expression throws the expected `Error`.
///
/// This function simplifies testing throwing code. When asserting that some code throws, you often care about the type of error that was thrown.
/// When that type is equatable this provides an easy one line assert to ensure that the code throws exactly the error you expect.
///
///     // Given, When
///     let file = File(named: "missing file")
///
///     // Then
///     XCTAssertThrowsError(try file.load(), equalTo: FileError.notFound)
///
/// - Parameters:
///   - expression:     An expression expected to throw an error.
///   - expectedError:  The specific error expected to be thrown.
///   - message:        An optional description of the failure.
///   - reporter:       The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:           The file in which failure occurred. Defaults to the file name of the test case in which this
///                     function was called.
///   - line:           The line number on which failure occurred. Defaults to the line number on which this function was
///                     called.
///   - then:           A closure to be called if the thrown `Error` is the expected type and equal to the provided error.
///                     This can be used to run additional tests with the error.
public func XCTAssertThrowsError<T: Error & Equatable>(
    _ expression: @autoclosure () throws -> Any?,
    equalTo expectedError: T,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: () throws -> Void = { })
{
    let name = "XCTAssertThrowsError"
    XCTAssertThrowsError(try expression(), ofType: T.self, message(), reporter: reporter, file: file, line: line) { error in
        guard error == expectedError else {
            reporter.reportFailure(
                description: "\(name) - (\"\(error)\") is not equal to (\"\(expectedError)\")\(suffix(from: message))",
                file: file,
                line: line
            )

            return
        }

        try then()
    }
}

/// Asserts that the asynchronous expression throws the expected `Error`.
///
/// This function simplifies testing throwing code. When asserting that some code throws, you often care about the type of error that was thrown.
/// When that type is equatable this provides an easy one line assert to ensure that the code throws exactly the error you expect.
///
///     // Given, When
///     let file = File(named: "missing file")
///
///     // Then
///     await XCTAssertThrowsError(try await file.load(), equalTo: FileError.notFound)
///
/// - Parameters:
///   - expression:     An asynchronous expression expected to throw an error.
///   - expectedError:  The specific error expected to be thrown.
///   - message:        An optional description of the failure.
///   - reporter:       The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:           The file in which failure occurred. Defaults to the file name of the test case in which this
///                     function was called.
///   - line:           The line number on which failure occurred. Defaults to the line number on which this function was
///                     called.
///   - then:           A closure to be called if the thrown `Error` is the expected type and equal to the provided error.
///                     This can be used to run additional tests with the error.
@available(iOS 13.0.0, tvOS 13.0.0, macOS 10.15.0, *)
public func XCTAssertThrowsError<T: Sendable, E: Error & Equatable>(
    _ expression: @autoclosure () async throws -> T,
    equalTo expectedError: E,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: () throws -> Void = { }
) async {
    let name = "XCTAssertThrowsError"
    await XCTAssertThrowsError(try await expression(), ofType: E.self, message(), reporter: reporter, file: file, line: line) { error in
        guard error == expectedError else {
            reporter.reportFailure(
                description: "\(name) - (\"\(error)\") is not equal to (\"\(expectedError)\")\(suffix(from: message))",
                file: file,
                line: line
            )

            return
        }

        try then()
    }
}

/// Asserts that the expression does not throw an error. The `then` closure is called with the result of the expression.
///
///     // Given, When
///     let file = File(named: "configuration")
///
///     // Then
///     XCTAssertNoThrow(try file.load()) { contents in
///         XCTAssertFalse(contents.isEmpty)
///     }
///
/// - Parameters:
///   - expression: An expression expected to not throw an error.
///   - message:    An optional description of the failure.
///   - reporter:   The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:       The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - line:       The line number on which failure occurred. Defaults to the line number on which this function was called.
///   - then:       A closure to be called if the expression does not throw with the result of the expression.
///                 This can be used to run additional tests with the result.
public func XCTAssertNoThrow<T>(
    _ expression: @autoclosure () throws -> T,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: (T) throws -> Void)
{
    let name = "XCTAssertNoThrow"
    let result = catchErrors(
        in: expression,
        message: message,
        name: name,
        reporter: reporter,
        file: file,
        line: line
    )

    guard case let .success(value) = result else { return }

    failIfThrows(try then(value), message: message, name: name, reporter: reporter, file: file, line: line)
}

/// Asserts that the asynchronous expression does not throw an error. The `then` closure is called with the result of the expression.
///
///     // Given, When
///     let file = File(named: "configuration")
///
///     // Then
///     await XCTAssertNoThrow(try await file.load()) { contents in
///         XCTAssertFalse(contents.isEmpty)
///     }
///
/// - Parameters:
///   - expression: An asynchronous expression expected to not throw an error.
///   - message:    An optional description of the failure.
///   - reporter:   The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:       The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - line:       The line number on which failure occurred. Defaults to the line number on which this function was called.
///   - then:       A closure to be called if the expression does not throw with the result of the expression.
///                 This can be used to run additional tests with the result.
@available(iOS 13.0.0, tvOS 13.0.0, macOS 10.15.0, *)
public func XCTAssertNoThrow<T: Sendable>(
    _ expression: @autoclosure () async throws -> T,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: (T) throws -> Void
) async {
    let name = "XCTAssertNoThrow"
    let result = await catchErrors(
        in: expression,
        message: message,
        name: name,
        reporter: reporter,
        file: file,
        line: line
    )

    guard case let .success(value) = result else { return }

    failIfThrows(try then(value), message: message, name: name, reporter: reporter, file: file, line: line)
}
