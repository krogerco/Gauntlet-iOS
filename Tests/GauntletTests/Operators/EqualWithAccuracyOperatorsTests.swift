//
//  EqualWithAccuracyOperatorsTests.swift
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

class EqualWithAccuracyOperatorsTestCase: XCTestCase {

    // MARK: - Equal

    /// Tests the basic success behavior using Assertion tests.
    func testIsEqualWithAccuracySuccess() {
        // Given
        let expectedLine = 321

        // When
        let equalAssertion = TestAnAssertion(on: 5).isEqualTo(5, accuracy: 1, line: expectedLine)
        let withAccuracyAssertion = TestAnAssertion(on: 5).isEqualTo(6, accuracy: 1, line: expectedLine)

        // Then
        Assert(that: equalAssertion).didPass(expectedName: "isEqualTo(, accuracy)", expectedLine: expectedLine)
        Assert(that: withAccuracyAssertion).didPass(expectedName: "isEqualTo(, accuracy)", expectedLine: expectedLine)
    }

    /// Tests the basic failure behavior using Assertion tests.
    func testIsEqualWithAccuracyFailure() {
        // Given
        let expectedLine = 123

        // When
        let assertion = TestAnAssertion(on: 4).isEqualTo(1, accuracy: 2, line: expectedLine)

        // Then
        Assert(that: assertion)
            .didFail(expectedName: "isEqualTo(, accuracy)", expectedLine: expectedLine)
            .isMessage()
            .isEqualTo("4 is not equal to the expected value 1. Accuracy: 2")
    }

    /// Runs a number of live assertions to validate the success behavior with a variety of values.
    /// These test cases are taken from the Open Source XCTest codebase.
    func testIsEqualWithAccuracySuccessCases() {
        Assert(that: 0).isEqualTo(0, accuracy: -0.1)
        Assert(that: 1).isEqualTo(1, accuracy: 0)
        Assert(that: 0).isEqualTo(0, accuracy: 0)
        Assert(that: 0).isEqualTo(1, accuracy: 1)
        Assert(that: 0).isEqualTo(1, accuracy: 1.01)
        Assert(that: 1).isEqualTo(1.09, accuracy: 0.1)
        Assert(that: 1 as Float).isEqualTo(1.09, accuracy: 0.1)
        Assert(that: 1 as Float32).isEqualTo(1.09, accuracy: 0.1)
        Assert(that: 1 as Float64).isEqualTo(1.09, accuracy: 0.1)
        Assert(that: 1 as CGFloat).isEqualTo(1.09, accuracy: 0.1)
        Assert(that: 1 as Double).isEqualTo(1.09, accuracy: 0.1)
        Assert(that: 1 as Int).isEqualTo(2, accuracy: 5)
        Assert(that: 1 as UInt).isEqualTo(4, accuracy: 5)
        Assert(that: 1).isEqualTo(-1, accuracy: 2)
        Assert(that: -2).isEqualTo(-4, accuracy: 2)
        Assert(that: Double.infinity).isEqualTo(.infinity, accuracy: 0)
        Assert(that: Double.infinity).isEqualTo(.infinity, accuracy: 1)
        Assert(that: Double.infinity).isEqualTo(.infinity, accuracy: 1e-6)
        Assert(that: -Double.infinity).isEqualTo(-.infinity, accuracy: 1)
        Assert(that: Double.infinity).isEqualTo(.infinity, accuracy: 1e6)
        Assert(that: Double.infinity).isEqualTo(.infinity, accuracy: .infinity)
        Assert(that: Double.infinity).isEqualTo(-.infinity, accuracy: .infinity)
        Assert(that: Float.infinity).isEqualTo(.infinity, accuracy: 1e-6)
        Assert(that: Double.infinity).isEqualTo(.infinity - 1, accuracy: 0)
    }

    /// Runs a number of live assertiosn to validate the failure behavior with a variety of values.
    /// These test cases are taken from the Open Source XCTest codebase.
    func testIsEqualWithAccuracyFailureCases() {
        _ = XCTExpectFailure {
            Assert(that: 0).isEqualTo(0.2, accuracy: -0.1)
        }

        _ = XCTExpectFailure {
            Assert(that: 10).isEqualTo(8, accuracy: 1)
        }

        _ = XCTExpectFailure {
            Assert(that: -Double.infinity).isEqualTo(.infinity, accuracy: 1e-6)
        }

        _ = XCTExpectFailure {
            Assert(that: Double.nan).isEqualTo(.nan, accuracy: 0)
        }
    }

    // MARK: - Not Equal

    /// Tests the basic success behavior using Assertion tests.
    func testIsNotEqualWithAccuracySuccess() {
        // Given
        let expectedLine = 321

        // When
        let assertion = TestAnAssertion(on: 5).isNotEqualTo(7, accuracy: 1, line: expectedLine)

        // Then
        Assert(that: assertion).didPass(expectedName: "isNotEqualTo(, accuracy)", expectedLine: expectedLine)
    }

    /// Tests the basic failure behavior using Assertion tests.
    func testIsNotEqualWithAccuracyFailure() {
        // Given
        let expectedLine = 123

        // When
        let assertion = TestAnAssertion(on: 4).isNotEqualTo(3, accuracy: 2, line: expectedLine)

        // Then
        Assert(that: assertion)
            .didFail(expectedName: "isNotEqualTo(, accuracy)", expectedLine: expectedLine)
            .isMessage()
            .isEqualTo("4 is equal to the expected value 3. Accuracy: 2")
    }

    /// Runs a number of live assertions to validate the success behavior with a variety of values.
    /// These test cases are taken from the Open Source XCTest codebase.
    func testIsNotEqualWithAccuracySuccessCases() {
        Assert(that: 1.0).isNotEqualTo(2.0, accuracy: -0.5)
        Assert(that: 0).isNotEqualTo(1, accuracy: 0.1)
        Assert(that: 1).isNotEqualTo(1.11, accuracy: 0.1)
        Assert(that: -1).isNotEqualTo(5, accuracy: 5)
        Assert(that: 1 as Float).isNotEqualTo(1.11, accuracy: 0.1)
        Assert(that: 1 as Float32).isNotEqualTo(1.11, accuracy: 0.1)
        Assert(that: 1 as Float64).isNotEqualTo(1.11, accuracy: 0.1)
        Assert(that: 1 as CGFloat).isNotEqualTo(1.11, accuracy: 0.1)
        Assert(that: 1 as Int).isNotEqualTo(10, accuracy: 5)
        Assert(that: 1 as UInt).isNotEqualTo(10, accuracy: 5)
        Assert(that: 1).isNotEqualTo(-1, accuracy: 1)
        Assert(that: -2).isNotEqualTo(-4, accuracy: 1)
        Assert(that: Double.nan).isNotEqualTo(Double.nan, accuracy: 0)
        Assert(that: 1).isNotEqualTo(Double.nan, accuracy: 0)
        Assert(that: Double.nan).isNotEqualTo(1, accuracy: 0)
        Assert(that: Double.nan).isNotEqualTo(1, accuracy: .nan)
        Assert(that: Double.infinity).isNotEqualTo(-.infinity, accuracy: 0)
        Assert(that: Double.infinity).isNotEqualTo(-.infinity, accuracy: 1)
        Assert(that: Double.infinity).isNotEqualTo(-.infinity, accuracy: 1e-6)
        Assert(that: Double.infinity).isNotEqualTo(-.infinity, accuracy: 1e6)
    }

    /// Runs a number of live assertiosn to validate the failure behavior with a variety of values.
    /// /// These test cases are taken from the Open Source XCTest codebase.
    func testIsNotEqualWithAccuracyFailureCases() {
        _ = XCTExpectFailure {
            Assert(that: 1.0).isNotEqualTo(2.0, accuracy: -1.0)
        }

        _ = XCTExpectFailure {
            Assert(that: 0).isNotEqualTo(5, accuracy: 5)
        }

        _ = XCTExpectFailure {
            Assert(that: -Double.infinity).isNotEqualTo(-.infinity, accuracy: 1e-6)
        }
    }
}
