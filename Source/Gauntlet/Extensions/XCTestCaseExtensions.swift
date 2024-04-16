//
//  XCTestExtensions.swift
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

import XCTest

// We're ignoring the naming conventions here so that these isntance functions can have uppercase names.
// swiftlint:disable identifier_name

// MARK: - Assert

extension XCTestCase {

    /// Creates an ``Assertion`` on the specified value.
    ///
    /// - Parameters:
    ///   - value: The value to assert on.
    ///   - filePath: The path to the source file in which the assertion exists. This should not be provided manually.
    ///   - lineNumber: The line number of the asertion. This should not be provided manually.
    public func Assert<T>(
        that value: T,
        filePath: String = #filePath,
        lineNumber: Int = #line)
        -> Assertion<T>
    {
        let typeName = String(describing: T.self)
        let name = "Assert(that: \(typeName))"

        return Assertion(
            value: value,
            name: name,
            filePath: filePath,
            lineNumber: lineNumber,
            recorder: self,
            isRoot: true
        )
    }

    // MARK: - Throwing

    /// Creates an ``Assertion`` on the specified throwing expression.
    ///
    /// - Parameters:
    ///   - expression: The expression, which can throw an error, to assert on.
    ///   - filePath: The path to the source file in which the assertion exists. This should not be provided manually.
    ///   - lineNumber: The line number of the asertion. This should not be provided manually.
    public func Assert<T>(
        throwingExpression expression: @escaping @autoclosure () throws -> T,
        filePath: String = #filePath,
        lineNumber: Int = #line)
        -> Assertion<ThrowableExpression<T>>
    {
        let typeName = String(describing: T.self)
        let name = "Assert(throwingExpression: \(typeName))"

        return Assertion(
            value: ThrowableExpression(expression: expression),
            name: name,
            filePath: filePath,
            lineNumber: lineNumber,
            recorder: self,
            isRoot: true
        )
    }

    /// Creates an ``Assertion`` on the specified async throwing expression.
    ///
    /// - Parameters:
    ///   - expression: The async expression, which can throw an error, to assert on.
    ///   - filePath: The path to the source file in which the assertion exists. This should not be provided manually.
    ///   - lineNumber: The line number of the asertion. This should not be provided manually.
    public func Assert<T: Sendable>(
        asyncThrowingExpression expression: @escaping @autoclosure () async throws -> T,
        filePath: String = #filePath,
        lineNumber: Int = #line)
        async -> Assertion<AsyncThrowableExpression<T>>
    {
        let typeName = String(describing: T.self)
        let name = "Assert(throwingExpression: \(typeName))"

        return Assertion(
            value: AsyncThrowableExpression(expression: expression),
            name: name,
            filePath: filePath,
            lineNumber: lineNumber,
            recorder: self,
            isRoot: true
        )
    }

    // MARK: - Failure

    /// Creates an ``Assertion`` that fails immediately.
    ///
    /// - Parameters:
    ///   - message: A description of the failure.
    ///   - filePath: The path to the source file in which the assertion exists. This should not be provided manually.
    ///   - lineNumber: The line number of the asertion. This should not be provided manually.
    @discardableResult
    public func Assert(
        failure message: String,
        filePath: String = #filePath,
        lineNumber: Int = #line)
        -> Assertion<Void>
    {
        let assertion = Assertion<Void>(
            result: .fail(message: message),
            name: "Assert(failure: )",
            filePath: filePath,
            lineNumber: lineNumber,
            recorder: self,
            isRoot: true
        )

        assertion.recordFailure()

        return assertion
    }

    // MARK: - Test Assertions

    /// Creates an ``Assertion`` instance to be used for testing assertion extension functions.
    ///
    /// This assertion is configured to allow testing the assertions that are spawned off of it. It will begin as a success with the specified value. These assertions
    /// will fail silently allowing  testing failure results of custom assertions without failing tests.
    ///
    /// The Assertion will have a result of `.success` with the provide value. It will have a name of `"TestAssertion"` and a line number of `0`
    /// so that you can test you've provided the right values to ``Assertion/evaluate(name:lineNumber:evaluator:)``.
    ///
    /// - Parameters:
    ///   - value: The initial value
    ///   - recorder: The `FailureRecorder` to use. defaults to a recorder that does nothing and will not cause failures.
    ///
    /// - Returns: An ``Assertion`` configured for testing with the specified value.
    public func TestAnAssertion<T>(on value: T, recorder: FailureRecorder? = nil) -> Assertion<T> {
        Assertion(
            result: .pass(value),
            name: "TestAssertion",
            filePath: "/test/assertion/file/path",
            lineNumber: 0,
            recorder: recorder ?? SilentFailureRecorder(),
            isRoot: true
        )
    }

    /// Creates an ``Assertion`` instance to be used for testing assertion extension functions on an assertion that has already failed.
    ///
    /// This is not a scenario that typically needs to be tested for custom assertions, as the `evaluate(...)` function will only run an evaluator if the receiving
    /// assertion is a success.
    ///
    /// The Assertion will have a result of `.failure` with a message. It will have a name of `"TestFailedAssertion"` and a line number of `0`
    /// so that you can test you've provided the right values to ``Assertion/evaluate(name:lineNumber:evaluator:)``.
    ///
    /// - Returns: An ``Assertion`` configured for testing with the specified value.
    public func TestFailedAssertion() -> Assertion<Void> {
        Assertion(
            result: .fail(message: "expected failure"),
            name: "TestFailedAssertion",
            filePath: "/test/failed/assertion/file/path",
            lineNumber: 0,
            recorder: SilentFailureRecorder(),
            isRoot: true
        )
    }
}

// MARK: - FailureRecorder

extension XCTestCase: FailureRecorder {
    public func record(name: String, reason: FailureReason, filePath: String, lineNumber: Int) {
        let detail: String
        let error: Error?
        let type: XCTIssue.IssueType

        switch reason {
        case let .message(message):
            detail = message
            error = nil
            type = .assertionFailure

        case let .thrownError(thrownError):
            detail = "threw error \(thrownError)"
            error = thrownError
            type = .thrownError
        }

        let compactDescription = "\(name) failed - \(detail)"
        let detailedDescription = "\(name) failed - \(detail)"

        let location = XCTSourceCodeLocation(filePath: filePath, lineNumber: lineNumber)
        let context = XCTSourceCodeContext(location: location)
        let issue = XCTIssue(
            type: type,
            compactDescription: compactDescription,
            detailedDescription: detailedDescription,
            sourceCodeContext: context,
            associatedError: error,
            attachments: []
        )

        record(issue)
    }
}
