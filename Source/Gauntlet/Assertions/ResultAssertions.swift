//
//  ResultAssertions.swift
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

extension Assertion where Value: ResultConvertible {
    /// Asserts that the result is a `success`, providing the `Success` value.
    ///
    /// - Returns: An ``Assertion`` containing the `Success` value.
    @discardableResult
    public func isSuccess(line: Int = #line) -> Assertion<Value.Success> {
        evaluate(name: "isSuccess", lineNumber: line) { value in
            value.asResult.mapError { error in
                .message("Result is a failure: \(error)")
            }
        }
    }

    /// Asserts that the result is a `failure`, providing the `Failure` value.
    ///
    /// - Returns: An ``Assertion`` containing the `Failure` value.
    @discardableResult
    public func isFailure(line: Int = #line) -> Assertion<Value.Failure> {
        evaluate(name: "isFailure", lineNumber: line) { value in
            switch value.asResult {
            case .success:
                return .failure(message: "Result is a success")

            case .failure(let error):
                return .success(error)
            }
        }
    }
}

// MARK: - Machinery

/// A type that can be converted to a `Result`.
///
/// This type is used to create ``Assertion`` extensions on the `Result` type.
public protocol ResultConvertible {
    associatedtype Success
    associatedtype Failure: Error

    /// A `Result` representing the receiver.
    var asResult: Result<Success, Failure> { get }
}

extension Result: ResultConvertible {
    public var asResult: Result<Success, Failure> { self }
}
