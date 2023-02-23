//
//  ThenAssertionsTests.swift
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

class ThenAssertionsTestCase: XCTestCase {
    func testThenOnSuccessfulAssertion() {
        // Given
        let recorder = MockFailureRecorder()
        let expectedValue = 57
        var valuePassedToClosure: Int?

        // When
        TestAssertion(on: expectedValue, recorder: recorder).then { inValue in
            valuePassedToClosure = inValue
        }

        // Then
        Assert(that: valuePassedToClosure).isEqualTo(expectedValue)
        Assert(that: recorder.recordedFailures.count).isEqualTo(0)
    }

    func testThenOnSuccessfulAssertionWithThrowingClosure() {
        // Given
        let recorder = MockFailureRecorder()
        let thrownError = MockError.someOtherError
        let line = 432
        // When
        TestAssertion(on: 57, recorder: recorder).then(line: line) { _ in
            throw thrownError
        }

        // Then
        Assert(that: recorder.recordedFailures.count).isEqualTo(1)

        guard let failure = recorder.recordedFailures.first else { return }

        Assert(that: failure.name).isEqualTo("then")
        Assert(that: failure.lineNumber).isEqualTo(line)
        Assert(that: failure.reason).isEqualTo(.thrownError(thrownError))
    }

    func testThenOnUnsuccessfulAssertion() {
        // Given
        var closureCalled = false

        // When
        TestFailedAssertion().then { _ in
            closureCalled = true
        }

        // Then
        Assert(that: closureCalled).isFalse()
    }
}
