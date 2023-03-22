//
//  ThenOperators.swift
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

    /// Terminates an assertion by calling the provided closure if the ``Assertion`` is a success.
    ///
    /// Errors thrown by the closure will result in an assertion failure.
    ///
    /// - Parameter closure: A closure to ge called if the ``Assertion`` is a success.
    public func then(line: Int = #line, _ closure: (Value) throws -> Void) {
        let _: Assertion<Void> = evaluate(name: "then", lineNumber: line) { value in
            do {
                try closure(value)
                return .pass
            } catch {
                return .fail(thrownError: error)
            }
        }
    }

    /// Terminates an assertion by calling the provided async closure if the ``Assertion`` is a success.
    ///
    /// Errors thrown by the closure will result in an assertion failure.
    ///
    /// - Parameter closure: A closure to ge called if the ``Assertion`` is a success.
    public func then(line: Int = #line, _ closure: (Value) async throws -> Void) async {
        let _: Assertion<Void> = await asyncEvaluate(name: "then", lineNumber: line) { value in
            do {
                try await closure(value)
                return .pass
            } catch {
                return .fail(thrownError: error)
            }
        }
    }
}
