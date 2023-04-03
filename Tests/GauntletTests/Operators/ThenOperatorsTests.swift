//
//  ThenOperatorsTests.swift
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

class ThenOperatorsTestCase: XCTestCase {

    // MARK: - Then

    func testThenOnPassingAssertion() {
        // Given
        let recorder = MockFailureRecorder()
        let expectedValue = 57
        var valuePassedToClosure: Int?

        // When
        TestAnAssertion(on: expectedValue, recorder: recorder).then { inValue in
            valuePassedToClosure = inValue
        }

        // Then
        Assert(that: valuePassedToClosure).isEqualTo(expectedValue)
        Assert(that: recorder.recordedFailures).hasCount(0)
    }

    func testThenOnPassingAssertionWithThrowingClosure() {
        // Given
        let recorder = MockFailureRecorder()
        let line = 432

        // When
        TestAnAssertion(on: 57, recorder: recorder).then(line: line) { _ in
            throw MockError.someOtherError
        }

        // Then
        Assert(that: recorder.recordedFailures).hasCount(1)

        guard let failure = recorder.recordedFailures.first else { return }

        Assert(that: failure.name).isEqualTo("then")
        Assert(that: failure.lineNumber).isEqualTo(line)
        Assert(that: failure.reason)
            .isThrownError()
            .isOfType(MockError.self)
            .isEqualTo(.someOtherError)
    }

    func testThenOnFailingAssertion() {
        // Given
        var closureCalled = false

        // When
        TestFailedAssertion().then { _ in
            closureCalled = true
        }

        // Then
        Assert(that: closureCalled).isFalse()
    }

    // MARK: - Async Then

    func testAsyncThenOnPassingAssertion() async {
        // Given
        let asyncModel = AsyncModel()
        let recorder = MockFailureRecorder()
        let expectedValue = 57
        var valuePassedToClosure: Int?

        // When
        await TestAnAssertion(on: expectedValue, recorder: recorder).asyncThen { inValue in
            valuePassedToClosure = inValue
            // Vaidate that we can call async code from this closure
            _ = await asyncModel.getValue()
        }

        // Then
        Assert(that: valuePassedToClosure).isEqualTo(expectedValue)
        Assert(that: recorder.recordedFailures).hasCount(0)
    }

    func testAsyncThenOnPassingAssertionWithThrowingClosure() async {
        // Given
        let recorder = MockFailureRecorder()
        let line = 123

        // When
        await TestAnAssertion(on: 57, recorder: recorder).asyncThen(line: line) { _ in
            throw MockError.someError
        }

        // Then
        Assert(that: recorder.recordedFailures).hasCount(1)

        guard let failure = recorder.recordedFailures.first else { return }

        Assert(that: failure.name).isEqualTo("asyncThen")
        Assert(that: failure.lineNumber).isEqualTo(line)
        Assert(that: failure.reason)
            .isThrownError()
            .isOfType(MockError.self)
            .isEqualTo(.someError)
    }

    func testAsyncThenOnFailingAssertion() async {
        // Given
        var closureCalled = false

        // When
        await TestFailedAssertion().asyncThen { _ in
            closureCalled = true
        }

        // Then
        Assert(that: closureCalled).isFalse()
    }
}
