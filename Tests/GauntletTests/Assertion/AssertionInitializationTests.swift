//
//  AssertionTests.swift
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

class AssertionTestCase: XCTestCase {

    // MARK: - Initializers

    /// The `Result` initializer should store the provided values and should not record any failures when provided with a `success`.
    func testResultInitSuccess() {
        // Given
        let recorder = MockFailureRecorder()
        let value = "some value"
        let name = "Some Assertion Name"
        let filePath = "/some/file/path"
        let lineNumber = 1234
        let isRoot = true

        // When
        let assertion = Assertion(
            result: .success(value),
            name: name,
            filePath: filePath,
            lineNumber: lineNumber,
            recorder: recorder,
            isRoot: isRoot
        )

        // Then
        if case let .success(resultValue) = assertion.result {
            XCTAssertEqual(resultValue, value)
        } else {
            XCTFail("Result is not a success")
        }

        XCTAssertEqual(assertion.name, name)
        XCTAssertEqual(assertion.filePath, filePath)
        XCTAssertEqual(assertion.lineNumber, lineNumber)
        XCTAssert(assertion.recorder is MockFailureRecorder)
        XCTAssertEqual(assertion.isRoot, isRoot)
        XCTAssert(recorder.recordedFailures.isEmpty)

    }

    /// The `Result` initializer should store the provided values and should not record any failures when provided with a `failure`.
    func testResultInitFailure() {
        // Given
        let recorder = MockFailureRecorder()
        let failureMessage = "some failure message"
        let name = "Some Failed Assertion Name"
        let filePath = "/some/failed/file/path"
        let lineNumber = 4321
        let isRoot = false

        // When
        let assertion = Assertion<String>(
            result: .message(failureMessage),
            name: name,
            filePath: filePath,
            lineNumber: lineNumber,
            recorder: recorder,
            isRoot: isRoot
        )

        // Then
        if case let .failure(error) = assertion.result, case let .message(message) = error {
            XCTAssertEqual(message, failureMessage)
        } else {
            XCTFail("Result is not a failure with a message.")
        }

        XCTAssertEqual(assertion.name, name)
        XCTAssertEqual(assertion.filePath, filePath)
        XCTAssertEqual(assertion.lineNumber, lineNumber)
        XCTAssert(assertion.recorder is MockFailureRecorder)
        XCTAssertEqual(assertion.isRoot, isRoot)
        XCTAssert(recorder.recordedFailures.isEmpty)
    }

    /// The value initializer should have a `success` result, store the provided values, and not record any failures to the recorder.
    func testValueInit() {
        // Given
        let recorder = MockFailureRecorder()
        let value = 57
        let name = "Some Assertion Name"
        let filePath = "/some/file/path"
        let lineNumber = 3412
        let isRoot = true

        // When
        let assertion = Assertion(
            value: value,
            name: name,
            filePath: filePath,
            lineNumber: lineNumber,
            recorder: recorder,
            isRoot: isRoot
        )

        // Then
        if case let .success(resultValue) = assertion.result {
            XCTAssertEqual(resultValue, value)
        } else {
            XCTFail("Result is not a success")
        }

        XCTAssertEqual(assertion.name, name)
        XCTAssertEqual(assertion.filePath, filePath)
        XCTAssertEqual(assertion.lineNumber, lineNumber)
        XCTAssert(assertion.recorder is MockFailureRecorder)
        XCTAssertEqual(assertion.isRoot, isRoot)
        XCTAssert(recorder.recordedFailures.isEmpty)
    }

    /// The async value initializer should have a `success` result, store the provided values, and not record any failures to the recorder.
    func testAsyncValueInit() async {
        // Given
        let recorder = MockFailureRecorder()
        let name = "Some Assertion Name"
        let filePath = "/some/file/path"
        let lineNumber = 3412
        let isRoot = true
        let model = AsyncModel()

        // When
        let assertion = await Assertion(
            expression: { await model.getValue() },
            name: name,
            filePath: filePath,
            lineNumber: lineNumber,
            recorder: recorder,
            isRoot: isRoot
        )

        // Then
        if case let .success(resultValue) = assertion.result {
            XCTAssertEqual(resultValue, "async-value")
        } else {
            XCTFail("Result is not a success")
        }

        XCTAssertEqual(assertion.name, name)
        XCTAssertEqual(assertion.filePath, filePath)
        XCTAssertEqual(assertion.lineNumber, lineNumber)
        XCTAssert(assertion.recorder is MockFailureRecorder)
        XCTAssertEqual(assertion.isRoot, isRoot)
        XCTAssert(recorder.recordedFailures.isEmpty)
    }

    // MARK: - Deinit

    /// If an `Assertion` is root and was created on a value but no assertions were ever evaluated by the time it deiniitialized the assertion should record a failure
    /// indicating that no assertions were evaluated.
    func testUnevaluatedRootRecordsIssueOnDeinit() {
        // Given
        let recorder = MockFailureRecorder()
        let name = "SomeAssertion"
        let filePath = "/some/file/path"
        let lineNumber = 1234

        var assertion: Assertion? = Assertion(
            result: .success("some value"),
            name: name,
            filePath: filePath,
            lineNumber: lineNumber,
            recorder: recorder,
            isRoot: true
        )

        // Reference the assertion to silence a warning.
        _ = assertion

        // When the assertion is deallocated
        assertion = nil

        // Then
        let expectedFailure = RecordedFailure(
            name: name,
            reason: .message("This assertion was never evaluated."),
            filePath: filePath,
            lineNumber: lineNumber
        )

        XCTAssertEqual(recorder.recordedFailures, [expectedFailure])
    }

    /// If an `Assertion` is a failure and unevaluated, but not the root, it should not record any failures on deinit. This will occur when additional assertions
    /// are chained off of an early assertion that failed. That original failure recorded the failure so there's no need to re-record it.
    func testFailureNonRootDoesntRecordFailureOnDeinit() {
        // Given
        let recorder = MockFailureRecorder()
        let name = "SomeAssertion"
        let filePath = "/some/file/path"
        let lineNumber = 1234

        var assertion: Assertion? = Assertion<String>(
            result: .message("some failure"),
            name: name,
            filePath: filePath,
            lineNumber: lineNumber,
            recorder: recorder,
            isRoot: false
        )

        // Reference the assertion to silence a warning.
        _ = assertion

        // When the assertion is deallocated
        assertion = nil

        // Then
        XCTAssert(recorder.recordedFailures.isEmpty)
    }
}
