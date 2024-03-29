//
//  AssertionOperators.swift
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

extension Assertion where Value: AssertionConvertible {
    public typealias AssertionValue = Value.Value

    /// Asserts that the ``Assertion`` passed and has the expected name and line number.
    ///
    /// The `Assertion` returned from this will be based on the receiver's `result`. This assertion may generate failures, like the line or name not matching,
    /// but still return an assertion with a `pass` result if the receiving assertion was a `pass`.
    ///
    /// - Parameters:
    ///   - expectedName: The expected name for the passing assertion.
    ///   - expectedLine: The expected line for the passing assertion.
    /// - Returns: A new ``Assertion`` containing the value of the passing assertion.
    @discardableResult
    public func didPass(expectedName: String, expectedLine: Int, line: Int = #line) -> Assertion<AssertionValue> {
        let name = "didPass"
        validate(name: name, line: line, expectedName: expectedName, expectedLine: expectedLine)

        return evaluate(name: name, lineNumber: line) { convertible in
            convertible.asAssertion.result
        }
    }

    /// Asserts that the ``Assertion`` failed with the expected file, and line number.
    ///
    /// The `Assertion` returned from this will be based on the receiver's `result`. This assertion may generate failures, like the line or name not matching,
    /// but still return an assertion with a `pass` result if the receiving assertion was a `fail`.
    ///
    /// - Parameters:
    ///   - expectedName: The expected name for the failing assertion.
    ///   - expectedLine: The expected line for the failing assertion.
    /// - Returns: A new ``Assertion`` containing the failure reason for the failing assertion.
    @discardableResult
    public func didFail(expectedName: String, expectedLine: Int, line: Int = #line) -> Assertion<FailureReason> {
        let name = "didFail"
        validate(name: name, line: line, expectedName: expectedName, expectedLine: expectedLine)

        return evaluate(name: name, lineNumber: line) { convertible in
            let assertion = convertible.asAssertion

            guard case let .fail(failureReason) = assertion.result else {
                return .fail(message: "Result was a success")
            }

            return .pass(failureReason)
        }
    }

    private func validate(
        name: String,
        line: Int,
        expectedName: String,
        expectedLine: Int)
    {
        // We will evaluate assertions for both the name and the line numbers being the expected value.
        // These assertions will not be stored/returned, but instead will just generate failures if the values
        // don't match the expected values.
        let _: Assertion<Void> = evaluate(name: name, lineNumber: line) { convertible in
            let assertion = convertible.asAssertion

            guard assertion.name != expectedName else { return .pass }

            let message = #"Name "\#(assertion.name)" is not equal to expected name "\#(expectedName)""#

            return .fail(message: message)
        }

        let _: Assertion<Void> = evaluate(name: name, lineNumber: line) { convertible in
            let assertion = convertible.asAssertion

            guard assertion.lineNumber != expectedLine else { return .pass }

            let message = #"Line "\#(assertion.lineNumber)" is not equal to expected line "\#(expectedLine)""#

            return .fail(message: message)
        }
    }
}

// MARK: - Machinery

/// A type that can be converted to an ``Assertion``.
///
/// This type is used to create ``Assertion`` extensions on the `Assertion` type.
public protocol AssertionConvertible {
    associatedtype Value

    /// An `Assertion` representing the receiver.
    var asAssertion: Assertion<Value> { get }
}

extension Assertion: AssertionConvertible {
    public var asAssertion: Assertion<Value> { self }
}
