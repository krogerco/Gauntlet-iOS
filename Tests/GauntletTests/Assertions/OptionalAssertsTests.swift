//
//  OptionalAssertsTests.swift
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

class OptionalAssertsTestCase: XCTestCase {

    // MARK: - isNotNil

    func testIsNotNilSuccess() {
        // Given
        let line = 123
        let value: String? = "some value"

        // When
        let assertion = TestAssertion(on: value).isNotNil(line: line)

        // Then
        Assert(that: assertion)
            .isSuccess(expectedName: "isNotNil", expectedLine: line)
            .isEqualTo("some value")
    }

    func testIsNotNilFailure() {
        // Given
        let line = 321
        let value: String? = nil

        // When
        let assertion = TestAssertion(on: value).isNotNil(line: line)

        // Then
        Assert(that: assertion)
            .isFailure(expectedName: "isNotNil", expectedLine: line)
            .isEqualTo(.message("value is nil"))
    }

    // MARK: - isNil

    func testIsNilSuccess() {
        // Given
        let line = 123
        let value: String? = nil

        // When
        let assertion = TestAssertion(on: value).isNil(line: line)

        // Then
        Assert(that: assertion)
            .isSuccess(expectedName: "isNil", expectedLine: line)
    }

    func testIsNilFailure() {
        // Given
        let line = 321
        let value: String? = "some value"

        // When
        let assertion = TestAssertion(on: value).isNil(line: line)

        // Then
        Assert(that: assertion)
            .isFailure(expectedName: "isNil", expectedLine: line)
            .isEqualTo(.message("value is not nil"))
    }
}