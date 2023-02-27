//
//  XCTestCaseExtensionsTests.swift
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

class XCTestCaseExtensionsTestCase: XCTestCase {

    // MARK: - Test Asserts

    /// A TestAssertion should be created with the appropriate default values.
    func testCreatingTestAssertion() {
        // Given, When
        let value = "some value"
        let assertion = TestAnAssertion(on: value)

        // Then
        if case let .success(resultValue) = assertion.result {
            XCTAssertEqual(resultValue, value)
        } else {
            XCTFail("Result is not a success")
        }

        XCTAssertEqual(assertion.name, "TestAssertion")
        XCTAssertEqual(assertion.filePath, "/test/assertion/file/path")
        XCTAssertEqual(assertion.lineNumber, 0)
        XCTAssertTrue(assertion.isRoot)
    }

    /// A TestAssertion should be created using the specified recorder. This triggers a failure to cause an failure to be recorded to validate this.
    func testCreatingTestAssertionWithMockRecorder() {
        // Given, When
        let recorder = MockFailureRecorder()
        let assertion: Assertion<String> = TestAnAssertion(on: "", recorder: recorder)

        // When
        let _: Assertion<Void> = assertion.evaluate(name: "name", lineNumber: 123) { _ in
            .failure(message: "some failure")
        }

        // Then
        XCTAssertEqual(recorder.recordedFailures.count, 1)
    }

    /// A TestAssertion should not fail a test when it evaluates a failure. It should fail silently.
    func testEvaluatingFailureOnTestAssertion() {
        // Given
        let assertion = TestAnAssertion(on: "some value")

        // When, Then
        let newAssert: Assertion<String> = assertion.evaluate(
            name: "Failure",
            lineNumber: 123,
            evaluator: { _ in throw MockError.someError }
        )

        // Reference the value to silence a warning
        _ = newAssert
    }

    /// A TestAssertion should be created with the appropriate default values.
    func testCreatingTestFailedAssertion() {
        // Given, When
        let assertion = TestFailedAssertion()

        // Then
        if case let .failure(reason) = assertion.result {
            XCTAssertEqual(reason, .message("expected failure"))
        } else {
            XCTFail("Result is not a failure")
        }

        XCTAssertEqual(assertion.name, "TestFailedAssertion")
        XCTAssertEqual(assertion.filePath, "/test/failed/assertion/file/path")
        XCTAssertEqual(assertion.lineNumber, 0)
        XCTAssertTrue(assertion.isRoot)
    }

    /// A TestAssertion should not fail a test when it deallocates. It should fail silently.
    func testEvaluatingFailureOnTestFailedAssertion() {
        // Given
        var assertion: Assertion<Void>? = TestFailedAssertion()

        // Silence a warning
        _ = assertion

        // When, Then
        assertion = nil
    }

    /// A failure assertion should be initialized with a failure.
    func testAssertionFailure() {
        // Given
        let expectedMessage = "some failure message"
        var assertion: Assertion<Void>!
        let expectedLine = #line + 4

        // When
        XCTExpectFailure("This Assertion should generate a failure.") {
            assertion = Assert(failure: expectedMessage)
        }

        // Then
        if case let .failure(error) = assertion.result, case let .message(message) = error {
            XCTAssertEqual(message, expectedMessage)
        } else {
            XCTFail("Result is not a failure with a message.")
        }

        XCTAssertEqual(assertion.name, "Assert(failure: )")
        XCTAssertEqual(assertion.filePath, #filePath)
        XCTAssertEqual(assertion.lineNumber, expectedLine)
        XCTAssertTrue(assertion.isRoot)
    }

    // MARK: - Assert

    /// Ensure assertions created via `Assert(that: )` are correctly configured.
    func testAssertValueInitializer() {
        // Given
        let value = "some value"

        // When
        let assertion = Assert(that: value, filePath: "some/file", lineNumber: 123)

        // Evaluate the assertion before leaving to prevent failures for not evaluating.
        defer { assertion.evaluate() }

        // Then
        if case let .success(resultValue) = assertion.result {
            XCTAssertEqual(resultValue, value)
        } else {
            XCTFail("Result is not a success")
        }

        XCTAssertEqual(assertion.name, "Assert(that: String)")
        XCTAssertEqual(assertion.filePath, "some/file")
        XCTAssertEqual(assertion.lineNumber, 123)
        XCTAssertTrue(assertion.isRoot)
    }

    /// Ensure async assertions created via `Assert(that: )` are correctly configured.
    func testAssertAsyncInitializer() async {
        // Given
        let model = AsyncModel()

        // When
        let assertion = await Assert(that: await model.getValue(), filePath: "some/file", lineNumber: 123)

        // Evaluate the assertion before leaving to prevent failures for not evaluating.
        defer { assertion.evaluate() }

        // Then
        if case let .success(resultValue) = assertion.result {
            XCTAssertEqual(resultValue, "async-value")
        } else {
            XCTFail("Result is not a success")
        }

        XCTAssertEqual(assertion.name, "Assert(that: String)")
        XCTAssertEqual(assertion.filePath, "some/file")
        XCTAssertEqual(assertion.lineNumber, 123)
        XCTAssertTrue(assertion.isRoot)

        /// Validate that this test case is the recorder.
        XCTAssert(assertion.recorder as? Self === self)
    }

    /// Ensure throwing assertions created via `Assert(throwingExpression: )` are correctly configured.
    func testAssertThrowingInitializer() {
        // Given
        func canThrow() throws -> String { "did not throw" }

        // When
        let assertion = Assert(throwingExpression: try canThrow(), filePath: "some/file", lineNumber: 123)

        // Evaluate the assertion before leaving to prevent failures for not evaluating.
        defer { assertion.evaluate() }

        // Then
        if case .success = assertion.result {
            // Nothing really to validate. The value is the expected type, ThrowableExpression<String>, and it would be pointless to check.
        } else {
            XCTFail("Result is not a success")
        }

        XCTAssertEqual(assertion.name, "Assert(throwingExpression: String)")
        XCTAssertEqual(assertion.filePath, "some/file")
        XCTAssertEqual(assertion.lineNumber, 123)
        XCTAssertTrue(assertion.isRoot)

        /// Validate that this test case is the recorder.
        XCTAssert(assertion.recorder as? Self === self)
    }

    /// Ensure async throwing assertions created via `Assert(throwingExpression: )` are correctly configured.
    func testAssertAsyncThrowingInitializer() async {
        // Given
        let model = ThrowingAsyncModel(result: .success("awaited-no-throw") )

        // When
        let assertion = await Assert(throwingExpression: try await model.getValue(), filePath: "some/file", lineNumber: 123)

        // Evaluate the assertion before leaving to prevent failures for not evaluating.
        defer { assertion.evaluate() }

        // Then
        if case .success = assertion.result {
            // Nothing really to validate. The value is the expected type, ThrowableExpression<String>, and it would be pointless to check.
        } else {
            XCTFail("Result is not a success")
        }

        XCTAssertEqual(assertion.name, "Assert(throwingExpression: String)")
        XCTAssertEqual(assertion.filePath, "some/file")
        XCTAssertEqual(assertion.lineNumber, 123)
        XCTAssertTrue(assertion.isRoot)

        /// Validate that this test case is the recorder.
        XCTAssert(assertion.recorder as? Self === self)
    }
}

// MARK: - FailureRecorder

class XCTestCaseFailureRecorderTestCase: XCTestCase {
    class MockTestCase: XCTestCase {
        private(set) var recordedIssues: [XCTIssue] = []

        override func record(_ issue: XCTIssue) {
            recordedIssues.append(issue)
        }
    }

    func testRecordingFailureWithMessage() {
        // Given
        let name = "Some Assertion"
        let reason = FailureReason.message("Failure Reason Message")
        let filePath = "/path/to/file"
        let lineNumber = 1234
        let mockRecorder = MockTestCase()

        // When
        mockRecorder.record(name: name, reason: reason, filePath: filePath, lineNumber: lineNumber)

        // Then
        // Ensure exactly one issue was recorded.
        XCTAssertEqual(mockRecorder.recordedIssues.count, 1)

        guard let issue = mockRecorder.recordedIssues.first else { return }

        XCTAssertEqual(issue.type, .assertionFailure)
        XCTAssertEqual(issue.compactDescription, "Some Assertion failed - Failure Reason Message")
        XCTAssertEqual(issue.detailedDescription, "Some Assertion failed - Failure Reason Message")
        XCTAssertEqual(issue.sourceCodeContext.location?.fileURL.path, filePath)
        XCTAssertEqual(issue.sourceCodeContext.location?.lineNumber, lineNumber)
        XCTAssertNil(issue.associatedError)
        XCTAssert(issue.attachments.isEmpty)
    }

    func testRecordingFailureWithThrownError() {
        // Given
        let name = "Some Assertion"
        let reason = FailureReason.thrownError(MockError.someError)
        let filePath = "/path/to/file"
        let lineNumber = 1234
        let mockRecorder = MockTestCase()

        // When
        mockRecorder.record(name: name, reason: reason, filePath: filePath, lineNumber: lineNumber)

        // Then
        XCTAssertEqual(mockRecorder.recordedIssues.count, 1)

        // Ensure exactly one issue was recorded.
        guard let issue = mockRecorder.recordedIssues.first else { return }

        XCTAssertEqual(issue.type, .thrownError)
        XCTAssertEqual(issue.compactDescription, "Some Assertion failed - threw error Some Error")
        XCTAssertEqual(issue.detailedDescription, "Some Assertion failed - threw error Some Error")
        XCTAssertEqual(issue.sourceCodeContext.location?.fileURL.path, filePath)
        XCTAssertEqual(issue.sourceCodeContext.location?.lineNumber, lineNumber)
        XCTAssertEqual(issue.associatedError as? MockError, .someError)
        XCTAssert(issue.attachments.isEmpty)
    }
}

// MARK: - Helper

extension Assertion {
    // This evaluates the expression and returns the original value. This can be used at the end of test to ensure
    // an assertion doesn't fail because it was never evaluated.
    @discardableResult
    func evaluate() -> Assertion<Value> {
        evaluate(name: name, lineNumber: lineNumber, evaluator: { value in
            .success(value)
        })
    }
}
