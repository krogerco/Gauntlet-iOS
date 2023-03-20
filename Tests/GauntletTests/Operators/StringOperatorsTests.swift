//
//  StringOperatorsTests.swift
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
import Gauntlet
import XCTest

class StringOperatorsTestCase: XCTestCase {
    // MARK: - Default

    func testContainsPassDefault() {
        // Given
        let line = 123

        // When
        let assertion = TestAnAssertion(on: "14 Halibut in stock").contains("Halibut", line: line)

        // Then
        Assert(that: assertion)
            .didPass(expectedName: "contains", expectedLine: line)
    }

    func testContainsFailDefault() {
        // Given
        let line = 321

        // When
        let assertion = TestAnAssertion(on: "14 Halibut in stock").contains("halibut", line: line)

        // Then
        Assert(that: assertion)
            .didFail(expectedName: "contains", expectedLine: line)
            .isMessage()
    }

    // MARK: - Case Sensitive

    func testContainsPassCaseSensitive() {
        // Given
        let line = 123

        // When
        let assertion = TestAnAssertion(on: "14 Halibut in stock").contains("4 Ha", ignoringCase: false, line: line)

        // Then
        Assert(that: assertion)
            .didPass(expectedName: "contains", expectedLine: line)
            .isEqualTo("14 Halibut in stock")
    }

    func testContainsFailCaseSensitive() {
        // Given
        let line = 321

        // When
        let assertion = TestAnAssertion(on: "14 Halibut in stock").contains("halibut IN", ignoringCase: false, line: line)

        // Then
        Assert(that: assertion)
            .didFail(expectedName: "contains", expectedLine: line)
            .isMessage()
            .isEqualTo(#""14 Halibut in stock" does not contain "halibut IN" (case sensitive)"#)
    }

    // MARK: - Ingoring Case

    func testContainsPassIgnoringCase() {
        // Given
        let line = 123

        // When
        let assertion = TestAnAssertion(on: "14 Halibut in stock").contains("halibut", ignoringCase: true, line: line)

        // Then
        Assert(that: assertion)
            .didPass(expectedName: "contains", expectedLine: line)
            .isEqualTo("14 Halibut in stock")
    }

    func testContainsFailIgnoringCase() {
        // Given
        let line = 321

        // When
        let assertion = TestAnAssertion(on: "14 Halibut in stock").contains("fail", ignoringCase: true, line: line)

        // Then
        Assert(that: assertion)
            .didFail(expectedName: "contains", expectedLine: line)
            .isMessage()
            .isEqualTo(#""14 Halibut in stock" does not contain "fail" (ignoring case)"#)
    }
}
