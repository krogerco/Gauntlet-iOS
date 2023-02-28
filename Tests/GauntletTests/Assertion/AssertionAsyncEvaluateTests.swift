//
//  AssertionAsyncEvaluateTests.swift
//
//  MIT License
//
//  Copyright (c) [2020] The Kroger Co. All rights reserved.
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
@testable import Gauntlet
import XCTest

class AssertionAsyncEvaluateTestCase: XCTestCase {
    /// Evaluating an async expression on an `Assertion` should result in a new `Assertion` containing a success with the new value.
    /// The name and line number should be the values provided to `evaluate()`. No failures should be recorded. The new `Assertion` should not be root.
    func testAsyncEvaluate() async {
        // Given
        let recorder = MockFailureRecorder()
        let assertion = Assertion(
            result: .pass("initial value"),
            name: "Initial Name",
            filePath: "/some/file/path",
            lineNumber: 0,
            recorder: recorder,
            isRoot: true
        )

        let newName = "Evaluated"
        let newLine = 44
        let model = AsyncModel()

        // When a successful assertion is evaluated.
        let evalutedAssertion = await assertion.asyncEvaluate(name: newName, lineNumber: newLine) { _ in
            let value = await model.getValue()
            return .pass(value)
        }

        // Then
        if case let .pass(resultValue) = evalutedAssertion.result {
            XCTAssertEqual(resultValue, "async-value")
        } else {
            XCTFail("Result is not a pass")
        }

        XCTAssertEqual(evalutedAssertion.name, newName)
        XCTAssertEqual(evalutedAssertion.filePath, assertion.filePath)
        XCTAssertEqual(evalutedAssertion.lineNumber, newLine)
        XCTAssert(evalutedAssertion.recorder is MockFailureRecorder)
        XCTAssertFalse(evalutedAssertion.isRoot)
        XCTAssert(recorder.recordedFailures.isEmpty)
    }

    /// Evaluating an async expression that throws an error should result in a new `Assertion` containing a failure with the thrown error.
    /// The name and line number should be the values provided to `evaluate()`. A failure should be recorded with these values and the thrown error.
    /// The new `Assertion` should not be root.
    func testAsyncEvaluateThatThrows() async {
        // Given
        let recorder = MockFailureRecorder()
        let assertion = Assertion(
            result: .pass("initial value"),
            name: "Initial Name",
            filePath: "/some/file/path",
            lineNumber: 0,
            recorder: recorder,
            isRoot: true
        )

        let newName = "Evaluated Failure"
        let newLine = 92

        // When a successful assertion is evaluated.
        let evalutedAssertion: Assertion<String> = await assertion.asyncEvaluate(name: newName, lineNumber: newLine) { _ in
            throw MockError.someError
        }

        // Then
        if case let .fail(reason) = evalutedAssertion.result, case let .thrownError(error) = reason {
            XCTAssert(error is MockError)
        } else {
            XCTFail("Result is not a fail with a thrown error.")
        }

        XCTAssertEqual(evalutedAssertion.name, newName)
        XCTAssertEqual(evalutedAssertion.filePath, assertion.filePath)
        XCTAssertEqual(evalutedAssertion.lineNumber, newLine)
        XCTAssert(evalutedAssertion.recorder is MockFailureRecorder)
        XCTAssertFalse(evalutedAssertion.isRoot)

        let expectedFailure = RecordedFailure(
            name: newName,
            reason: .thrownError(MockError.someError),
            filePath: evalutedAssertion.filePath,
            lineNumber: newLine
        )

        XCTAssertEqual(recorder.recordedFailures, [expectedFailure])
    }

    /// Evaluating an async expression that returns aa failure should result in a new `Assertion` containing that failure.
    /// The name and line number should be the values provided to `evaluate()`. A failure should be recorded with these values and the specified failure.
    /// The new `Assertion` should not be root.
    func testAsyncEvaluateThatReturnsFailure() async {
        // Given
        let recorder = MockFailureRecorder()
        let assertion = Assertion(
            result: .pass("initial value"),
            name: "Initial Name",
            filePath: "/some/file/path",
            lineNumber: 0,
            recorder: recorder,
            isRoot: true
        )

        let newName = "Evaluated Failure"
        let newLine = 96
        let failureMessage = "some failure message"

        // When a successful assertion is evaluated.
        let evalutedAssertion: Assertion<String> = await assertion.asyncEvaluate(name: newName, lineNumber: newLine) { _ in
            .fail(message: failureMessage)
        }

        // Then
        if case let .fail(reason) = evalutedAssertion.result, case let .message(message) = reason {
            XCTAssertEqual(message, failureMessage)
        } else {
            XCTFail("Result is not a fail with a message.")
        }

        XCTAssertEqual(evalutedAssertion.name, newName)
        XCTAssertEqual(evalutedAssertion.filePath, assertion.filePath)
        XCTAssertEqual(evalutedAssertion.lineNumber, newLine)
        XCTAssert(evalutedAssertion.recorder is MockFailureRecorder)
        XCTAssertFalse(evalutedAssertion.isRoot)

        let expectedFailure = RecordedFailure(
            name: newName,
            reason: .message(failureMessage),
            filePath: evalutedAssertion.filePath,
            lineNumber: newLine
        )

        XCTAssertEqual(recorder.recordedFailures, [expectedFailure])
    }

    /// Evaluating an async expression on an `Assertion` that has already failed should return the same assert and record no new failures.
    /// The new `Assertion` should not be root. The expression should not be evaluated.
    func testAsyncEvaluateOnFailure() async {
        // Given
        let recorder = MockFailureRecorder()
        let initialMessage = "Initial Failure"
        let initialAssertion = Assertion<String>(
            result: .fail(message: initialMessage),
            name: "Initial Name",
            filePath: "/some/file/path",
            lineNumber: 57,
            recorder: recorder,
            isRoot: true
        )

        var expressionWasEvaluated = false

        // When a successful assertion is evaluated.
        let evalutedAssertion: Assertion<String> = await initialAssertion.asyncEvaluate(name: "New Name", lineNumber: 96) { _ in
            expressionWasEvaluated = true
            return .fail(message: "New Failure Message")
        }

        // Then
        if case let .fail(reason) = evalutedAssertion.result, case let .message(message) = reason {
            XCTAssertEqual(message, initialMessage)
        } else {
            XCTFail("Result is not a fail with a message.")
        }

        XCTAssertEqual(evalutedAssertion.name, initialAssertion.name)
        XCTAssertEqual(evalutedAssertion.filePath, initialAssertion.filePath)
        XCTAssertEqual(evalutedAssertion.lineNumber, initialAssertion.lineNumber)
        XCTAssert(evalutedAssertion.recorder is MockFailureRecorder)
        XCTAssertFalse(evalutedAssertion.isRoot)
        XCTAssert(recorder.recordedFailures.isEmpty)
        XCTAssertFalse(expressionWasEvaluated)
    }
}
