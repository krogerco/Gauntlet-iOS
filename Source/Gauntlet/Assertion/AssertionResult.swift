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

/// The result of an evaluated ``Assertion``.
public typealias AssertionResult<Value> = Result<Value, FailureReason>

// MARK: - Convenience Constructors

extension AssertionResult where Success == Void {
    /// A successful result with no value.
    public static var success: AssertionResult<Void> { .success(()) }
}

extension AssertionResult {
    /// Creates an ``AssertionResult`` that is a `failure` with a `message` reason.
    ///
    /// - Parameter message: The message describing the failure reason..
    /// - Returns: An ``AssertionResult`` that is a failure with the specified message.
    public static func failure<T>(message: String) -> AssertionResult<T> {
        .failure(.message(message))
    }

    /// Creates an ``AssertionResult`` that is a `failure` with a `thrownError` reason.
    ///
    /// - Parameter error: The `Error` that was thrown.
    /// - Returns: An ``AssertionResult`` that is a failure with the specified error.
    public static func failure<T>(thrownError error: Error) -> AssertionResult<T> {
        .failure(.thrownError(error))
    }
}
