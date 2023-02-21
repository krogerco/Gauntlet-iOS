//
//  EqualWithAccuracyAsserts.swift
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

extension Assertion where Value: Numeric {

    /// Asserts that the value is equal to the specified value +/- the given accuracy range.
    ///
    /// - Parameters:
    ///   - expectedValue: The value the receiver should be equal to.
    ///   - accuracy: The maximum difference between the values for them to be considered equal.
    ///
    /// - Returns: A `Void` ``Assertion`` describing the result.
    @discardableResult
    public func isEqualTo(_ expectedValue: Value, accuracy: Value, line: Int = #line) -> Assertion<Void> {
        evaluate(name: "isEqualTo(, accuracy)", lineNumber: line) { value in
            if valuesAreEqual(value, expectedValue, accuracy: accuracy) {
                return .success
            } else {
                let message = #"\#(value) is not equal to the expected value \#(expectedValue). Accuracy: \#(accuracy)"#
                return .message(message)
            }
        }
    }

    /// Asserts that the value is not equal to the specified value +/- the given accuracy range.
    ///
    /// - Parameters:
    ///   - expectedValue: The value the receiver should be not equal to.
    ///   - accuracy: The maximum difference between the values for them to be considered equal.
    ///
    /// - Returns: A `Void` ``Assertion`` describing the result.
    @discardableResult
    public func isNotEqualTo(_ expectedValue: Value, accuracy: Value, line: Int = #line) -> Assertion<Void> {
        evaluate(name: "isNotEqualTo(, accuracy)", lineNumber: line) { value in
            if valuesAreEqual(value, expectedValue, accuracy: accuracy) {
                let message = #"\#(value) is equal to the expected value \#(expectedValue). Accuracy: \#(accuracy)"#
                return .message(message)
            } else {
                return .success

            }
        }
    }
}

// MARK: - Comparison

private func valuesAreEqual<T: Numeric>(_ lhs: T, _ rhs: T, accuracy: T) -> Bool {
    // If the equality comparison succeeds we're good.
    guard lhs != rhs else { return true }

    // Calculate the difference between the values. Not using abs here because we may have unsigned values.
    let difference = (lhs.magnitude > rhs.magnitude) ? lhs - rhs : rhs - lhs

    // NaN values are handled implicitly, since the <= operator returns false when comparing any value to NaN.
    return difference.magnitude <= accuracy.magnitude
}
