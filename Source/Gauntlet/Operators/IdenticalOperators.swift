//
//  IdenticalOperators.swift
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

extension Assertion where Value: AnyObject {

    /// Asserts that the object is the same object as the expected object.
    ///
    /// - Parameters:
    ///   - expectedObject: The object the receiver's value should be identical to.
    ///
    /// - Returns: A `Void` ``Assertion`` describing the result.
    @discardableResult
    public func isIdentical(to expectedObject: Value, line: Int = #line) -> Assertion<Void> {
        evaluate(name: "isIdentical", lineNumber: line) { object in
            if object === expectedObject {
                return .pass
            }

            return .fail(message: "The objects are not identical")
        }
    }

    /// Asserts that the object is not the same object as the expected object.
    ///
    /// - Parameters:
    ///   - expectedObject: The object the receiver's value should be different than.
    ///
    /// - Returns: A `Void` ``Assertion`` describing the result.
    @discardableResult
    public func isNotIdentical(to expectedObject: Value, line: Int = #line) -> Assertion<Void> {
        evaluate(name: "isNotIdentical", lineNumber: line) { object in
            if object !== expectedObject {
                return .pass
            }

            return .fail(message: "The objects are identical")
        }
    }
}
