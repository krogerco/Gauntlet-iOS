//
//  DispatchQueueOperatorTests.swift
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

class DispatchQueueOperatorsTestCase: XCTestCase {
    func testPassingIsTheCurrentQueue() {
        // Given
        let line = 123
        let queue = DispatchQueue(label: "com.krogerco.gauntlet.unitTestQueue")
        var assertion: Assertion<DispatchQueue>!

        // When
        queue.sync {
            assertion = TestAnAssertion(on: queue).isTheCurrentQueue(line: line)
        }

        // Then
        Assert(that: assertion)
            .didPass(expectedName: "isTheCurrentQueue", expectedLine: line)
            .isIdentical(to: queue)

    }

    func testFailingIsTheCurrentQueue() {
        // Given
        let line = 123
        let queue = DispatchQueue(label: "com.krogerco.gauntlet.unitTestQueue")
        let wrongQueue = DispatchQueue(label: "com.actual.queue")
        var assertion: Assertion<DispatchQueue>!

        // When
        wrongQueue.sync {
            assertion = TestAnAssertion(on: queue).isTheCurrentQueue(line: line)
        }

        // Then
        let expectedFailureMessage = "The label of the current queue (com.actual.queue) does not match " +
            "the expected queue label (com.krogerco.gauntlet.unitTestQueue)"

        Assert(that: assertion)
            .didFail(expectedName: "isTheCurrentQueue", expectedLine: line)
            .isMessage()
            .isEqualTo(expectedFailureMessage)
    }
}
