//  XCTCustomAssertHelpers.swift
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

/// Takes a throwing autoclosure expression from a custom test and turns it in to a result. If the expression
/// throws `XCTFail` will be called so you can safely return early from your custom test knowing that a failure was
/// generated.
///
/// - Parameters:
///   - expression: An expression of type `T` that can throw.
///   - message:    A closure that returns a custom failure message passed from the user.
///   - name:       The name of the assert calling. This will be added to the front of the failure message.
///   - reporter:   The `FailureReporter` to report a failure to.
///   - file:       The file in which the failure occurred.
///   - line:       The line number on which the failure occurred.
///
/// - Returns: A result of type `T` indicating whether the expression was successful.
func catchErrors<T>(
    in expression: () throws -> T,
    message: () -> String,
    name: String,
    reporter: FailureReporter,
    file: StaticString,
    line: UInt)
    -> Result<T, Error>
{
    do {
        let value = try expression()
        return .success(value)

    } catch {
        reporter.reportFailure(
            description: "\(name) - threw error \"\(error)\"\(suffix(from: message))",
            file: file,
            line: line
        )

        return .failure(error)
    }
}

/// Takes an asynchronous throwable expression from a custom test and turns it in to a result. If the expression
/// throws `XCTFail` will be called so you can safely return early from your custom test knowing that a failure was
/// generated.
///
/// - Parameters:
///   - expression: An asynchronous expression of type `T` that can throw.
///   - message:    A closure that returns a custom failure message passed from the user.
///   - name:       The name of the assert calling. This will be added to the front of the failure message.
///   - reporter:   The `FailureReporter` to report a failure to.
///   - file:       The file in which the failure occurred.
///   - line:       The line number on which the failure occurred.
///
/// - Returns: A result of type `T` indicating whether the expression was successful.
func catchErrors<T: Sendable>(
    in expression: () async throws -> T,
    message: () -> String,
    name: String,
    reporter: FailureReporter,
    file: StaticString,
    line: UInt)
    async -> Result<T, Error>
{
    do {
        let value = try await expression()
        return .success(value)

    } catch {
        reporter.reportFailure(
            description: "\(name) - threw error \"\(error)\"\(suffix(from: message))",
            file: file,
            line: line
        )

        return .failure(error)
    }
}

/// Evaluates a throwing expression failing the test if an error is thrown. This is intended to be used with `then` closures in assert functions and the messaging
/// is specific to that.
///
/// - Parameters:
///   - expression: An expression that can throw.
///   - message:    A closure that returns a custom failure message passed from the user.
///   - name:       The name of the assert calling. This will be added to the front of the failure message.
///   - reporter:   The `FailureReporter` to report a failure to.
///   - file:       The file in which the failure occurred.
///   - line:       The line number on which the failure occurred.
func failIfThrows(
    _ expression: @autoclosure () throws -> Void,
    message: () -> String,
    name: String,
    reporter: FailureReporter,
    file: StaticString,
    line: UInt)
{
    do {
        try expression()
    } catch {
        reporter.reportFailure(
            description: "\(name) - then closure threw error \"\(error)\"\(suffix(from: message))",
            file: file,
            line: line
        )
    }
}

/// Evaluates an async throwing expression failing the test if an error is thrown. This is intended to be used with `then` closures in assert functions and the messaging
/// is specific to that.
///
/// - Parameters:
///   - expression: An expression that can throw asynchronously.
///   - message:    A closure that returns a custom failure message passed from the user.
///   - name:       The name of the assert calling. This will be added to the front of the failure message.
///   - reporter:   The `FailureReporter` to report a failure to.
///   - file:       The file in which the failure occurred.
///   - line:       The line number on which the failure occurred.
func failIfThrows(
    _ expression: @autoclosure () async throws -> Void,
    message: () -> String,
    name: String,
    reporter: FailureReporter,
    file: StaticString,
    line: UInt) async
{
    do {
        try await expression()
    } catch {
        reporter.reportFailure(
            description: "\(name) - then closure threw error \"\(error)\"\(suffix(from: message))",
            file: file,
            line: line
        )
    }
}

/// This function will take the message autoclosure from a assert function and turn it in to a suffix for your failure
/// message.
///
/// - Parameter message: The message autoclosure passed in to your assert function.
/// 
/// - Returns: A well formatted suffix string that can be put on the end of your failure message.
func suffix(from message: () -> String) -> String {
    let messageString = message()
    return messageString.isEmpty ? "" : " - \(messageString)"
}
