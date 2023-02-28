//
//  EquatableAsserts.swift
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

extension Assertion where Value: Equatable {

    /// Asserts that the value is equal to the specifed value.
    ///
    /// - Parameters:
    ///   - expectedValue: The value the receiver should be equal to.
    ///   
    /// - Returns: A `Void` ``Assertion`` describing the result.
    @discardableResult
    public func isEqualTo(_ expectedValue: Value, line: Int = #line) -> Assertion<Void> {
        evaluate(name: "isEqualTo", lineNumber: line) { value in
            if value == expectedValue {
                return .pass
            }

            return .fail(message: #""\#(value)" is not equal to the expected value "\#(expectedValue)""#)
        }
    }

    /// Asserts that the value is not equal to the specifed value.
    ///
    /// - Parameters:
    ///   - unexpectedValue: The value the receiver should be equal to.
    ///
    /// - Returns: A `Void` ``Assertion`` describing the result.
    @discardableResult
    public func isNotEqualTo(_ unexpectedValue: Value, line: Int = #line) -> Assertion<Void> {
        evaluate(name: "isNotEqualTo", lineNumber: line) { value in
            if value != unexpectedValue {
                return .pass
            }

            return .fail(message: #""\#(value)" is equal to the specified value"#)
        }
    }
}
