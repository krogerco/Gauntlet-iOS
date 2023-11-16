//
//  CollectionOperatorsTests.swift
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

class CollectionOperatorsTestCase: XCTestCase {

    // MARK: - isEmpty
    func testIsEmptySuccess() {
        // Given
        let emptyArray = [Int]()
        let expectedLine = 321

        // When
        let assertion = TestAnAssertion(on: emptyArray).isEmpty(line: expectedLine)

        // Then
        Assert(that: assertion)
            .didPass(expectedName: "isEmpty", expectedLine: expectedLine)
    }

    func testIsEmptyFailureOneItem() {
        // Given
        let arrayWithItems = [4]
        let expectedLine = 975

        // When
        let assertion = TestAnAssertion(on: arrayWithItems).isEmpty(line: expectedLine)

        // Then
        Assert(that: assertion)
            .didFail(expectedName: "isEmpty", expectedLine: expectedLine)
            .isMessage()
            .isEqualTo("The collection has 1 item")
    }

    func testIsEmptyFailureMultipleItems() {
        // Given
        let arrayWithItems = ["two", "four", "six"]
        let expectedLine = 975

        // When
        let assertion = TestAnAssertion(on: arrayWithItems).isEmpty(line: expectedLine)

        // Then
        Assert(that: assertion)
            .didFail(expectedName: "isEmpty", expectedLine: expectedLine)
            .isMessage()
            .isEqualTo("The collection has 3 items")
    }

    // MARK: - isNotEmpty

    func testIsNotEmptySuccess() {
        // Given
        let array = [1, 2]
        let expectedLine = 321

        // When
        let assertion = TestAnAssertion(on: array).isNotEmpty(line: expectedLine)

        // Then
        Assert(that: assertion)
            .didPass(expectedName: "isNotEmpty", expectedLine: expectedLine)
            .isEqualTo(array)
    }

    func testIsNotEmptyFailure() {
        // Given
        let emptyArray = [Int]()
        let expectedLine = 975

        // When
        let assertion = TestAnAssertion(on: emptyArray).isNotEmpty(line: expectedLine)

        // Then
        Assert(that: assertion)
            .didFail(expectedName: "isNotEmpty", expectedLine: expectedLine)
            .isMessage()
            .isEqualTo("The collection is empty")
    }

    // MARK: - hasCount

    func testHasCountSuccess() {
        // Given
        let array = [4, 3, 2]
        let expectedLine = 435

        // When
        let assertion = TestAnAssertion(on: array).hasCount(3, line: expectedLine)

        // Then
        Assert(that: assertion)
            .didPass(expectedName: "hasCount", expectedLine: expectedLine)
            .isEqualTo(array)
    }

    func testHasCountFailure() {
        // Given
        let array = ["one", "two"]
        let expectedLine = 378

        // When
        let assertion = TestAnAssertion(on: array).hasCount(5, line: expectedLine)

        // Then
        Assert(that: assertion)
            .didFail(expectedName: "hasCount", expectedLine: expectedLine)
            .isMessage()
            .isEqualTo("Count of 2 is not equal to the expected count 5")
    }

    // MARK: - Contains

    func testContainsSuccess() {
        // Given
        let array = ["alpha", "bravo", "charlie"]
        let expectedLine = 645

        // When
        let assertion = TestAnAssertion(on: array).contains("bravo", line: expectedLine)

        // Then
        Assert(that: assertion)
            .didPass(expectedName: "contains", expectedLine: expectedLine)
            .isEqualTo(array)
    }

    func testContainsFailure() {
        // Given
        let array = ["alpha", "bravo", "charlie"]
        let expectedLine = 465

        // When
        let assertion = TestAnAssertion(on: array).contains("delta", line: expectedLine)

        // Then
        Assert(that: assertion)
            .didFail(expectedName: "contains", expectedLine: expectedLine)
            .isMessage()
            .isEqualTo(#"The collection does not contain "delta""#)
    }
}
