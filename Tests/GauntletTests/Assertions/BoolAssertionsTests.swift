//
//  BoolAssertionsTests.swift
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

class BoolAssertionsTestCase: XCTestCase {
    func testIsTrueSuccess() {
        // Given
        let expectedLine = 456

        // When
        let assertion = TestAssertion(on: true).isTrue(line: expectedLine)

        // Then
        Assert(that: assertion).isSuccess(expectedName: "isTrue", expectedLine: expectedLine)
    }

    func testIsTrueFailure() {
        // Given
        let expectedLine = 654

        // When
        let assertion = TestAssertion(on: false).isTrue(line: expectedLine)

        // Then
        Assert(that: assertion)
            .isFailure(expectedName: "isTrue", expectedLine: expectedLine)
            .isEqualTo(.message("value is false"))
    }

    func testLiveIsTrue() {
        XCTExpectFailure("The assertion should fail when the value is false")
        Assert(that: false).isTrue()
    }

    func testIsFalseSuccess() {
        // Given
        let expectedLine = 456

        // When
        let assertion = TestAssertion(on: false).isFalse(line: expectedLine)

        // Then
        Assert(that: assertion).isSuccess(expectedName: "isFalse", expectedLine: expectedLine)
    }

    func testIsFalseFailure() {
        // Given
        let expectedLine = 654

        // When
        let assertion = TestAssertion(on: true).isFalse(line: expectedLine)

        // Then
        Assert(that: assertion)
            .isFailure(expectedName: "isFalse", expectedLine: expectedLine)
            .isEqualTo(.message("value is true"))
    }

    func testLiveIsFalse() {
        XCTExpectFailure("The assertion should fail when the value is false")
        Assert(that: false).isTrue()
    }
}
