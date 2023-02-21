//
//  MockIssueRecorder.swift
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
import Gauntlet
import XCTest

// MARK: - Tests

class MockIssueRecorderTestCase: XCTestCase {
    func testInitializer() {
        // Given, When
        let recorder = MockIssueRecorder()

        // Then
        XCTAssert(recorder.recordedFailures.isEmpty)
    }

    func testRecord() {
        // Given
        let firstFailure = RecordedFailure(
            name: "First",
            reason: .message("first"),
            filePath: "/first/path",
            lineNumber: 123
        )

        let secondFailure = RecordedFailure(
            name: "Second",
            reason: .message("second"),
            filePath: "/first/path",
            lineNumber: 123
        )
        let recorder = MockIssueRecorder()

        // When
        recorder.record(
            name: firstFailure.name,
            reason: firstFailure.reason,
            filePath: firstFailure.filePath,
            lineNumber: firstFailure.lineNumber
        )

        recorder.record(
            name: secondFailure.name,
            reason: secondFailure.reason,
            filePath: secondFailure.filePath,
            lineNumber: secondFailure.lineNumber
        )

        // Then
        XCTAssertEqual(recorder.recordedFailures, [firstFailure, secondFailure])
    }

    func testClear() {
        // Given
        let recorder = MockIssueRecorder()
        recorder.record(name: "some name", reason: .message(""), filePath: "/some/path", lineNumber: 123)

        // When
        recorder.clear()

        // Then
        XCTAssert(recorder.recordedFailures.isEmpty)
    }
}
