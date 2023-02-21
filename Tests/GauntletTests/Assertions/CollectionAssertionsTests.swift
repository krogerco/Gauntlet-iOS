//
//  CollectionAssertionsTests.swift
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

class CollectionAssertionsTestCase: XCTestCase {
    func testIsEmptySuccess() {
        // Given
        let emptyArray = [Int]()
        let expectedLine = 321

        // When
        let assertion = TestAssertion(on: emptyArray).isEmpty(line: expectedLine)

        // Then
        Assert(that: assertion)
            .isSuccess(expectedName: "isEmpty", expectedLine: expectedLine)
    }

    func testIsEmptyFailureOneItem() {
        // Given
        let arrayWithItems = [4]
        let expectedLine = 975

        // When
        let assertion = TestAssertion(on: arrayWithItems).isEmpty(line: expectedLine)

        // Then
        Assert(that: assertion)
            .isFailure(expectedName: "isEmpty", expectedLine: expectedLine)
            .isEqualTo(.message("collection has 1 item"))
    }

    func testIsEmptyFailureMultipleItems() {
        // Given
        let arrayWithItems = ["two", "four", "six"]
        let expectedLine = 975

        // When
        let assertion = TestAssertion(on: arrayWithItems).isEmpty(line: expectedLine)

        // Then
        Assert(that: assertion)
            .isFailure(expectedName: "isEmpty", expectedLine: expectedLine)
            .isEqualTo(.message("collection has 3 items"))
    }

    func testLiveIsEmpty() {
        // Given
        let arrayWithItems = [1, 2, 3]

        // When, Then
        XCTExpectFailure("This assertion should generate a failure")
        Assert(that: arrayWithItems).isEmpty()
    }

    func testHasCountSuccess() {
        // Given
        let array = [4, 3, 2]
        let expectedLine = 435

        // When
        let assertion = TestAssertion(on: array).hasCount(3, line: expectedLine)

        // Then
        Assert(that: assertion)
            .isSuccess(expectedName: "hasCount", expectedLine: expectedLine)
            .isEqualTo(array)
    }

    func testHasCountFailure() {
        // Given
        let array = ["one", "two"]
        let expectedLine = 378

        // When
        let assertion = TestAssertion(on: array).hasCount(5, line: expectedLine)

        // Then
        Assert(that: assertion)
            .isFailure(expectedName: "hasCount", expectedLine: expectedLine)
            .isEqualTo(.message("Count of 2 is not equal to the expected count 5"))
    }

    func testLiveHasCount() {
        // Given
        let array = [1, 2]

        // When, Then
        XCTExpectFailure("This asssertion should generate a failure")
        Assert(that: array).hasCount(5)
    }
}
