//
//  TypeAssertions.swift
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

extension Assertion {

    /// Asserts that the value is of the specified type.
    ///
    /// - Parameters:
    ///   - expectedType: The type the value is expected to conform to.
    ///
    /// - Returns: An ``Assertion`` containing the value cast to the specified type.
    @discardableResult
    public func isType<T>(_ expectedType: T.Type, line: Int = #line) -> Assertion<T> {
        evaluate(name: "isType", lineNumber: line) { value in
            if let castValue = value as? T {
                return .pass(castValue)
            }

            let typeDescription = String(describing: type(of: value))
            let expectedTypeDescription = String(describing: expectedType)
            let message = "Value of type \(typeDescription) does not conform to expected type \(expectedTypeDescription)"

            return .fail(message: message)
        }
    }
}
