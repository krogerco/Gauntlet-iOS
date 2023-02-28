//
//  AssertionResult.swift
//
//  MIT License
//
//  Copyright (c) [2023] The Kroger Co. All rights reserved.
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

/// Represents the result of an Assertion.
public enum AssertionResult<Value> {
    /// The assertion passed, supplying a value for future assertions.
    case pass(Value)

    /// The assertion failed, including a reason describing the type of failure.
    case fail(FailureReason)
}

extension AssertionResult where Value == Void {
    /// A successful result with no value.
    public static var pass: AssertionResult<Void> { .pass(()) }
}

extension AssertionResult {
    /// Creates an ``AssertionResult`` that is a `fail` case with a `message` reason.
    ///
    /// - Parameter message: The message describing the failure reason..
    /// - Returns: An ``AssertionResult`` that is a failure with the specified message.
    public static func fail<T>(message: String) -> AssertionResult<T> {
        .fail(.message(message))
    }

    /// Creates an ``AssertionResult`` that is a `fail` case with a `thrownError` reason.
    ///
    /// - Parameter error: The `Error` that was thrown.
    /// - Returns: An ``AssertionResult`` that is a failure with the specified error.
    public static func fail<T>(thrownError error: Error) -> AssertionResult<T> {
        .fail(.thrownError(error))
    }
}
