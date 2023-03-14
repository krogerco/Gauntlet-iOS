//
//  OptionalOperators.swift
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

extension Assertion where Value: OptionalConvertible {

    /// Asserts that the value is not nil.
    ///
    /// - Returns: An ``Assertion`` containing the unwrapped value if successful.
    @discardableResult
    public func isNotNil(line: Int = #line) -> Assertion<Value.Wrapped> {
        evaluate(name: "isNotNil", lineNumber: line) { value in
            guard let unwrappedValue = value.asOptional else { return .fail(message: "value is nil") }

            return .pass(unwrappedValue)
        }
    }

    /// Asserts that the value is not nil.
    ///
    /// - Returns: An ``Assertion`` containing the unwrapped value if successful.
    @discardableResult
    public func isNil(line: Int = #line) -> Assertion<Void> {
        evaluate(name: "isNil", lineNumber: line) { value in
            guard value.asOptional == nil else { return .fail(message: "value is not nil") }

            return .pass
        }
    }
}

// MARK: - Machinery

/// A type that can be converted to an `Optional`.
///
/// This type is used to create ``Assertion`` extensions on the `Optional` type.
public protocol OptionalConvertible {
    associatedtype Wrapped

    /// An `Optional` representation of the receiver.
    var asOptional: Wrapped? { get }
}

extension Optional: OptionalConvertible {
    public var asOptional: Wrapped? { self }
}
