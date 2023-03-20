//
//  StringOperators.swift
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

extension Assertion<String> {

    /// Asserts that the string constains the specified substring.
    ///
    /// - Parameters:
    ///   - string: The substring the string is expected to contain.
    ///   - ignoringCase: Optoin to ignore case when comparing strings.
    ///
    /// - Returns: An ``Assertion`` containing the unmofidied string.
    @discardableResult
    public func contains(_ string: String, ignoringCase: Bool = false, line: Int = #line) -> Assertion<String> {
        evaluate(name: "contains", lineNumber: line) { value in

            let sourceString = ignoringCase ? value.lowercased() : value
            let subString = ignoringCase ? string.lowercased() : string

            guard sourceString.contains(subString) else {
                let options = ignoringCase ? "ignoring case" : "case sensitive"
                return .fail(message: #""\#(value)" does not contain "\#(string)" (\#(options))"#)
            }

            return .pass(value)
        }
    }
}
