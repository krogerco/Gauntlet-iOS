//
//  FailureReasonOperatorsTests.swift
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
@testable import Gauntlet
import XCTest

class FailureReasonOperatorsTestCase: XCTestCase {
    func testIsMessagePass() {
        // Given
        let expectedMessage = "some messge"
        let expectedLine = 321

        // When
        let assertion = TestAnAssertion(on: FailureReason.message(expectedMessage)).isMessage(line: expectedLine)

        // Then
        switch assertion.result {
        case .pass(let message):
            XCTAssertEqual(message, expectedMessage)
        case .fail(let reason):
            XCTFail("isMessage result is a fail: \(reason)")
        }

        XCTAssertEqual(assertion.name, "isMessage")
        XCTAssertEqual(assertion.lineNumber, expectedLine)
    }

    func testIsMessageFail() {
        // Given
        let expectedLine = 123

        // When
        let assertion = TestAnAssertion(on: FailureReason.thrownError(MockError.someOtherError)).isMessage(line: expectedLine)

        // Then
        if case let .fail(reason) = assertion.result, case let .message(message) = reason {
            XCTAssertEqual(message, "FailureReason is thrownError: Some Other Error")
        } else {
            XCTFail("isMessage result isn't a fail with a message")
        }

        XCTAssertEqual(assertion.name, "isMessage")
        XCTAssertEqual(assertion.lineNumber, expectedLine)
    }

    func testIsThrownErrorPass() {
        // Given
        let expectedError = MockError.someError
        let expectedLine = 321

        // When
        let assertion = TestAnAssertion(on: FailureReason.thrownError(expectedError)).isThrownError(line: expectedLine)

        // Then
        switch assertion.result {
        case .pass(let error):
            XCTAssert(error is MockError, "The value provided in the error should be the MockError")
        case .fail(let reason):
            XCTFail("isThrownError result is a fail: \(reason)")
        }

        XCTAssertEqual(assertion.name, "isThrownError")
        XCTAssertEqual(assertion.lineNumber, expectedLine)
    }

    func testIsThrownErrorFail() {
        // Given
        let expectedLine = 123

        // When
        let assertion = TestAnAssertion(on: FailureReason.message("some message")).isThrownError(line: expectedLine)

        // Then
        if case let .fail(reason) = assertion.result, case let .message(message) = reason {
            XCTAssertEqual(message, "FailureReason is message: some message")
        } else {
            XCTFail("isThrownError result isn't a fail with a message")
        }

        XCTAssertEqual(assertion.name, "isThrownError")
        XCTAssertEqual(assertion.lineNumber, expectedLine)
    }
}
