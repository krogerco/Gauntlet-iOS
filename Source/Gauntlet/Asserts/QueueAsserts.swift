//  QueueAsserts.swift
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
import XCTest

/// Asserts that the queue that this function is called on is the expected queue. This is useful for validating APIs that take callback queues to ensure
/// that it always calls back on the provided queue.
///
///     // Given
///     let provider =  ...
///     let queue = DispatchQueue(label: "A Custom Queue")
///     let expectation = self.expectation(description: "Request should complete")
///
///     // When, Then
///     provider.getData(queue: queue) { result in
///         XCTAssertOnQueue(queue)
///         ...
///     }
///
///     waitForExpectations(timeout: 5)
///
/// - Note:
///     This function compares the label of the provided queue to the label of the queue that this function was called on. When using this to validate the behavior of
///     a piece of code is is recommended that you create your own queue for the test that you inject in to the code to be tested to ensure that you have a queue
///     with a unique label of your own creation.
///
/// - Parameters:
///   - expression: An expression that returns a `DispatchQueue` that this function is expected to be called on.
///   - message:    An optional description of the failure.
///   - reporter:   The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:       The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - line:       The line number on which failure occurred. Defaults to the line number on which this function was called.
///   - then:       A closure to be called if on the expected queue. This can be used to run additional conditional tests.
public func XCTAssertOnQueue(
    _ expression: @autoclosure () throws -> DispatchQueue,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: () throws -> Void = { })
{
    let name = "XCTAssertOnQueue"
    let result = catchErrors(
        in: expression,
        message: message,
        name: name,
        reporter: reporter,
        file: file,
        line: line
    )

    guard case let .success(expectedQueue) = result else { return }

    let currentLabel = DispatchQueue.currentQueueLabel ?? "unknown"

    guard expectedQueue.label == currentLabel else {
        let message = "\(name) - label of current queue (\"\(currentLabel)\") is not equal to (\"\(expectedQueue.label)\")" +
            suffix(from: message)

        reporter.reportFailure(
            description: message,
            file: file,
            line: line
        )

        return
    }

    failIfThrows(try then(), message: message, name: name, reporter: reporter, file: file, line: line)
}
