//  DispatchQueueExtensions.swift
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

extension DispatchQueue {

    /// Returns the label of the current DispatchQueue. This can be used in testing to ensure that a completion passed to some code was called on the expected queue.
    ///
    ///     struct DataProvider {
    ///         func loadData(at path: String, queue: DisaptchQueue, completion: @escaping     (Result<Data, Error>) -> Void) {
    ///             ...
    ///         }
    ///     }
    ///
    ///     ...
    ///
    ///     func testDataProviderCompletesOnCorrectQueue() {
    ///         // Given
    ///         let provider = DataProvider()
    ///         let testPath = ...
    ///         let testQueue = DispatchQueue(label: "custom test label")
    ///         let expectation = self.expectation(description: "Completion should be called")
    ///         var labelOfQueueCompletionWasCalledOn: String?
    ///
    ///         // When
    ///         provider.loadData(at: testPath, queue: testQueue) { result in
    ///             labelOfQueueCompletionWasCalledOn = DispatchQueue.labelOfCurrentQueue
    ///             expectation.fulfill()
    ///         }
    ///
    ///         waitForExpectations(timeout: 5)
    ///
    ///         // Then
    ///         XCTAssertEqual(labelOfQueueCompletionWasCalledOn, testQueue.label))
    ///     }
    ///
    public static var currentQueueLabel: String? {
        String(cString: __dispatch_queue_get_label(nil), encoding: .utf8)
    }
}
