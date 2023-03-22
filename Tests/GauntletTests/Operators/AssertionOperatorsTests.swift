//
//  AssertionOperatorsTests.swift
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

class AssertionOperatorsTestCase: XCTestCase {
    // MARK: - Success

    func testIsSuccessSuccess() {
        // Given
        let recorder = MockFailureRecorder()
        let expectedName = "someAssert"
        let expectedLine = 123
        let expectedValue = "assertion value"
        let passingAssertion = TestAnAssertion(on: "initial value")
            .evaluate(name: expectedName, lineNumber: expectedLine) { _ in
                .pass(expectedValue)
            }

        // When
        let assertionLine = #line + 2
        let assertion = TestAnAssertion(on: passingAssertion, recorder: recorder)
            .didPass(expectedName: expectedName, expectedLine: expectedLine)

        // Then
        XCTAssert(recorder.recordedFailures.isEmpty)
        XCTAssertEqual(assertion.name, "didPass")
        XCTAssertEqual(assertion.lineNumber, assertionLine)

        if case let .pass(value) = assertion.result {
            XCTAssertEqual(value, expectedValue)
        } else {
            XCTFail("isSuccess result is not pass")
        }
    }

    func testIsSuccessMixedSuccess() {
        // Given
        let recorder = MockFailureRecorder()
        let actualName = "actualName"
        let expectedName = "expectedName"
        let actualLine = 789
        let expectedLine = 123
        let expectedValue = "assertion value"
        let passingAssertion = TestAnAssertion(on: "initial value")
            .evaluate(name: actualName, lineNumber: actualLine) { _ in
                .pass(expectedValue)
            }

        // When
        let assertionLine = #line + 2
        let assertion = TestAnAssertion(on: passingAssertion, recorder: recorder)
            .didPass(expectedName: expectedName, expectedLine: expectedLine)

        // Then
        XCTAssertEqual(assertion.name, "didPass")
        XCTAssertEqual(assertion.lineNumber, assertionLine)

        if case let .pass(value) = assertion.result {
            XCTAssertEqual(value, expectedValue)
        } else {
            XCTFail("didPass result is not pass")
        }

        XCTAssertEqual(recorder.recordedFailures.count, 2)

        guard recorder.recordedFailures.count == 2 else { return }

        let expectedNameFailure = RecordedFailure(
            name: "didPass",
            reason: .message(#"Name "\#(actualName)" is not equal to expected name "\#(expectedName)""#),
            filePath: assertion.filePath,
            lineNumber: assertionLine
        )

        let expectedLineFailure = RecordedFailure(
            name: "didPass",
            reason: .message(#"Line "\#(actualLine)" is not equal to expected line "\#(expectedLine)""#),
            filePath: assertion.filePath,
            lineNumber: assertionLine
        )

        XCTAssertEqual(recorder.recordedFailures, [expectedNameFailure, expectedLineFailure])
    }

    func testIsSuccessFullFailure() {
        // Given
        let recorder = MockFailureRecorder()
        let actualName = "actualName"
        let expectedName = "expectedName"
        let actualLine = 789
        let expectedLine = 123
        let expectedReason = FailureReason.message("some failure")
        let passingAssertion: Assertion<String> = TestAnAssertion(on: "initial value")
            .evaluate(name: actualName, lineNumber: actualLine) { _ in
                .fail(expectedReason)
            }

        // When
        let assertionLine = #line + 2
        let assertion = TestAnAssertion(on: passingAssertion, recorder: recorder)
            .didPass(expectedName: expectedName, expectedLine: expectedLine)

        // Then
        XCTAssertEqual(assertion.name, "didPass")
        XCTAssertEqual(assertion.lineNumber, assertionLine)

        if case let .fail(reason) = assertion.result {
            XCTAssertEqual(reason, expectedReason)
        } else {
            XCTFail("didPass result is not fail")
        }

        XCTAssertEqual(recorder.recordedFailures.count, 3)

        guard recorder.recordedFailures.count == 3 else { return }

        let expectedNameFailure = RecordedFailure(
            name: "didPass",
            reason: .message(#"Name "\#(actualName)" is not equal to expected name "\#(expectedName)""#),
            filePath: assertion.filePath,
            lineNumber: assertionLine
        )

        let expectedLineFailure = RecordedFailure(
            name: "didPass",
            reason: .message(#"Line "\#(actualLine)" is not equal to expected line "\#(expectedLine)""#),
            filePath: assertion.filePath,
            lineNumber: assertionLine
        )

        let expectedResultFailure = RecordedFailure(
            name: "didPass",
            reason: expectedReason,
            filePath: assertion.filePath,
            lineNumber: assertionLine
        )

        XCTAssertEqual(recorder.recordedFailures, [expectedNameFailure, expectedLineFailure, expectedResultFailure])
    }

    func testLiveIsSuccess() {
        // Given
        let assertion: Assertion<String> = TestAnAssertion(on: 57).evaluate(name: "some name", lineNumber: 123) { _ in
            .fail(message: "some failure")
        }

        // When, Then
        XCTExpectFailure("This assertion should generate failures")
        Assert(that: assertion).didPass(expectedName: "wrong name", expectedLine: 54321)
    }

    // MARK: - Failure

    func testIsFailureSuccess() {
        // Given
        let recorder = MockFailureRecorder()
        let expectedName = "someAssert"
        let expectedLine = 123
        let expectedReason = FailureReason.message("some failure reason")
        let passingAssertion: Assertion<String> = TestAnAssertion(on: "initial value")
            .evaluate(name: expectedName, lineNumber: expectedLine) { _ in
                .fail(expectedReason)
            }

        // When
        let assertionLine = #line + 2
        let assertion = TestAnAssertion(on: passingAssertion, recorder: recorder)
            .didFail(expectedName: expectedName, expectedLine: expectedLine)

        // Then
        XCTAssert(recorder.recordedFailures.isEmpty)
        XCTAssertEqual(assertion.name, "didFail")
        XCTAssertEqual(assertion.lineNumber, assertionLine)

        if case let .pass(value) = assertion.result {
            XCTAssertEqual(value, expectedReason)
        } else {
            XCTFail("didPass result is not pass")
        }
    }

    func testIsFailureMixedSuccess() {
        // Given
        let recorder = MockFailureRecorder()
        let actualName = "actualName"
        let expectedName = "expectedName"
        let actualLine = 789
        let expectedLine = 123
        let expectedReason = FailureReason.message("some failure reason")
        let passingAssertion: Assertion<String> = TestAnAssertion(on: "initial value")
            .evaluate(name: actualName, lineNumber: actualLine) { _ in
                    .fail(expectedReason)
            }

        // When
        let assertionLine = #line + 2
        let assertion = TestAnAssertion(on: passingAssertion, recorder: recorder)
            .didFail(expectedName: expectedName, expectedLine: expectedLine)

        // Then
        XCTAssertEqual(assertion.name, "didFail")
        XCTAssertEqual(assertion.lineNumber, assertionLine)

        if case let .pass(value) = assertion.result {
            XCTAssertEqual(value, expectedReason)
        } else {
            XCTFail("didPass result is not pass")
        }

        XCTAssertEqual(recorder.recordedFailures.count, 2)

        guard recorder.recordedFailures.count == 2 else { return }

        let expectedNameFailure = RecordedFailure(
            name: "didFail",
            reason: .message(#"Name "\#(actualName)" is not equal to expected name "\#(expectedName)""#),
            filePath: assertion.filePath,
            lineNumber: assertionLine
        )

        let expectedLineFailure = RecordedFailure(
            name: "didFail",
            reason: .message(#"Line "\#(actualLine)" is not equal to expected line "\#(expectedLine)""#),
            filePath: assertion.filePath,
            lineNumber: assertionLine
        )

        XCTAssertEqual(recorder.recordedFailures, [expectedNameFailure, expectedLineFailure])
    }

    func testIsFailureFullFailure() {
        // Given
        let recorder = MockFailureRecorder()
        let actualName = "actualName"
        let expectedName = "expectedName"
        let actualLine = 789
        let expectedLine = 123
        let expectedReason = FailureReason.message("Result was a success")
        let passingAssertion = TestAnAssertion(on: "initial value")
            .evaluate(name: actualName, lineNumber: actualLine) { _ in
                .pass("some value")
            }

        // When
        let assertionLine = #line + 2
        let assertion = TestAnAssertion(on: passingAssertion, recorder: recorder)
            .didFail(expectedName: expectedName, expectedLine: expectedLine)

        // Then
        XCTAssertEqual(assertion.name, "didFail")
        XCTAssertEqual(assertion.lineNumber, assertionLine)

        if case let .fail(reason) = assertion.result {
            XCTAssertEqual(reason, expectedReason)
        } else {
            XCTFail("didPass result is not fail")
        }

        XCTAssertEqual(recorder.recordedFailures.count, 3)

        guard recorder.recordedFailures.count == 3 else { return }

        let expectedNameFailure = RecordedFailure(
            name: "didFail",
            reason: .message(#"Name "\#(actualName)" is not equal to expected name "\#(expectedName)""#),
            filePath: assertion.filePath,
            lineNumber: assertionLine
        )

        let expectedLineFailure = RecordedFailure(
            name: "didFail",
            reason: .message(#"Line "\#(actualLine)" is not equal to expected line "\#(expectedLine)""#),
            filePath: assertion.filePath,
            lineNumber: assertionLine
        )

        let expectedResultFailure = RecordedFailure(
            name: "didFail",
            reason: expectedReason,
            filePath: assertion.filePath,
            lineNumber: assertionLine
        )

        XCTAssertEqual(recorder.recordedFailures, [expectedNameFailure, expectedLineFailure, expectedResultFailure])
    }

    func testLiveIsFailure() {
        // Given
        let assertion = TestAnAssertion(on: 95)

        // When, Then
        XCTExpectFailure("This assertion should generate failures")
        Assert(that: assertion).didFail(expectedName: "wrong name", expectedLine: 54321)
    }
}
