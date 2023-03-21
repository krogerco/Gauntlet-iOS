//
//  DispatchQueueOperators.swift
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

extension Assertion<DispatchQueue> {

    /// Asserts that this operator is called on the queue.
    ///
    /// This works by comparing the label of the queue contained in the receiver with the label of the queue this code is being run on. This is intended for use
    /// in tests where you want to validate that a completion is being called on the queue you specify, or on a wel known queue with a unique ID. Keep in mind
    /// that this depends on the queue label being unique and construct test data accordingly.
    ///
    /// ```swift
    /// func testCallsOnExpectedQueue() {
    ///     // Given
    ///     let expectedQueue = DispatchQueue(label: "com.myOrg.myProject.unitTestQueue")
    ///     let model = ...
    ///     let expectation = ...
    ///
    ///     // When
    ///     model.fetchData(queue: expectedQueue) { value in
    ///         Assert(that: expectedQueue).isTheCurrentQueue()
    ///         expectation.fulfill()
    ///         ...
    ///     }
    ///
    ///     // Then
    ///     ...
    /// }
    /// ```
    ///
    /// - Returns: An ``Assertion`` containing the queue describing the result.
    @discardableResult
    public func isTheCurrentQueue(line: Int = #line) -> Assertion<DispatchQueue> {
        evaluate(name: "isTheCurrentQueue", lineNumber: line) { queue in
            let currentQueueLabel = String(cString: __dispatch_queue_get_label(nil), encoding: .utf8)

            if currentQueueLabel == queue.label {
                return .pass(queue)
            }

            let message = "The label of the current queue (\(currentQueueLabel ?? "nil")) does not match the " +
                "expected queue label (\(queue.label))"

            return .fail(message: message)
        }
    }
}
