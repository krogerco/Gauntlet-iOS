//
//  IdenticalOperatorsTests.swift
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

class IdenticalOperatorsTestCase: XCTestCase {

    // MARK: - isIdentical

    func testIsIdenticalSuccess() {
        // Given
        let line = 123
        let object = SomeObject()
        let sameObject = object

        // When
        let assertion = TestAnAssertion(on: object).isIdentical(to: sameObject, line: line)

        // Then
        Assert(that: assertion)
            .didPass(expectedName: "isIdentical", expectedLine: line)
    }

    func testIsIdenticalFailure() {
        // Given
        let line = 123
        let object = SomeObject()
        let differentObject = SomeObject()

        // When
        let assertion = TestAnAssertion(on: object).isIdentical(to: differentObject, line: line)

        // Then
        Assert(that: assertion)
            .didFail(expectedName: "isIdentical", expectedLine: line)
            .isMessage()
            .isEqualTo("The objects are not identical")
    }

    // MARK: - isNotIdentical

    func testIsNotIdenticalSuccess() {
        // Given
        let line = 123
        let object = SomeObject()
        let differentObject = SomeObject()


        // When
        let assertion = TestAnAssertion(on: object).isNotIdentical(to: differentObject, line: line)

        // Then
        Assert(that: assertion)
            .didPass(expectedName: "isNotIdentical", expectedLine: line)
    }

    func testIsNotIdenticalFailure() {
        // Given
        let line = 123
        let object = SomeObject()
        let sameObject = object

        // When
        let assertion = TestAnAssertion(on: object).isNotIdentical(to: sameObject, line: line)

        // Then
        Assert(that: assertion)
            .didFail(expectedName: "isNotIdentical", expectedLine: line)
            .isMessage()
            .isEqualTo("The objects are identical")
    }
}

// MARK: -

private class SomeObject {
    init() {}
}
