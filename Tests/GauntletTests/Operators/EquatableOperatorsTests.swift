//
//  EquatableOperatorsTests.swift
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

class EquatableOperatorsTestCase: XCTestCase {

    // MARK: - isEqualTo

    func testIsEqualSuccess() {
        // Given
        let value = 57
        let expectedLine = 123

        // When
        let assertion = TestAnAssertion(on: value).isEqualTo(value, line: expectedLine)

        // Then
        if case let .fail(reason) = assertion.result {
            XCTFail("isEqualTo result is a fail: \(reason)")
        }

        XCTAssertEqual(assertion.name, "isEqualTo")
        XCTAssertEqual(assertion.lineNumber, expectedLine)
    }

    func testIsEqualFailure() {
        // Given
        let expectedLine = 321

        // When
        let assertion = TestAnAssertion(on: 57).isEqualTo(95, line: expectedLine)

        // Then
        if case let .fail(reason) = assertion.result, case let .message(message) = reason {
            XCTAssertEqual(message, #""57" is not equal to the expected value "95""#)

        } else {
            XCTFail("isEqualTo result isn't a fail with a message")
        }

        XCTAssertEqual(assertion.name, "isEqualTo")
        XCTAssertEqual(assertion.lineNumber, expectedLine)
    }

    func testLiveIsEqual() {
        XCTExpectFailure("This assertion should generate a failure")
        Assert(that: 57).isEqualTo(95)
    }

    // MARK: - isNotEqual

    func testIsNotEqualSuccess() {
        // Given
        let expectedLine = 123

        // When
        let assertion = TestAnAssertion(on: 57).isNotEqualTo(95, line: expectedLine)

        // Then
        Assert(that: assertion).didPass(expectedName: "isNotEqualTo", expectedLine: expectedLine)
    }

    func testIsNotEqualFailure() {
        // Given
        let expectedLine = 321

        // When
        let assertion = TestAnAssertion(on: 57).isNotEqualTo(57, line: expectedLine)

        // Then
        Assert(that: assertion)
            .didFail(expectedName: "isNotEqualTo", expectedLine: expectedLine)
            .isMessage()
            .isEqualTo(#""57" is equal to the specified value"#)
    }

    func testLiveIsNotEqual() {
        XCTExpectFailure("This assertion should generate a failure")
        Assert(that: 95).isNotEqualTo(95)
    }
}
