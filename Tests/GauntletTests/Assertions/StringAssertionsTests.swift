//
//  StringAssertionsTestCase.swift
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

class StringAssertionsTestCase: XCTestCase {

    func testContainsStringSuccess_caseInsensistive() {
        // Given
        let expectedLine = 456

        // When
        let assertion = TestAssertion(on: "Hello World")
            .contains(
                string: "hello",
                ignoringCase: true,
                line: expectedLine
            )

        // Then
        Assert(that: assertion)
            .isSuccess(
                expectedName: "contains(string:ignoringCase:line:)",
                expectedLine: expectedLine
            )
    }

    func testContainsStringSuccess_caseSensistive() {
        // Given
        let expectedLine = 456

        // When
        let assertion = TestAssertion(on: "Hello World")
            .contains(
                string: "World",
                ignoringCase: false,
                line: expectedLine
            )

        // Then
        Assert(that: assertion)
            .isSuccess(
                expectedName: "contains(string:ignoringCase:line:)",
                expectedLine: expectedLine
            )
    }

    func testContainsString_Fails_caseInsensistive() {
        // Given
        let expectedLine = 456
        let expectedMessage = #"Value "Hello World" does not contain "¿que honda, mundo?" (case insensitve)."#

        // When
        let assertion = TestAssertion(on: "Hello World")
            .contains(
                string: "¿que honda, mundo?",
                ignoringCase: true,
                line: expectedLine
            )

        // Then
        Assert(that: assertion)
            .isFailure(expectedName: "contains(string:ignoringCase:line:)", expectedLine: expectedLine)
            .isEqualTo(.message(expectedMessage))
    }

    func testContainsString_Fails_caseSensistive() {
        // Given
        let expectedLine = 456
        let expectedMessage = #"Value "Hello World" does not contain "world" (case sensitive)."#

        // When
        let assertion = TestAssertion(on: "Hello World")
            .contains(
                string: "world",
                ignoringCase: false,
                line: expectedLine
            )

        // Then
        Assert(that: assertion)
            .isFailure(expectedName: "contains(string:ignoringCase:line:)", expectedLine: expectedLine)
            .isEqualTo(.message(expectedMessage))
    }

}
