//  XCTQueueAssertTests.swift
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

import Gauntlet
import XCTest

class XCTQueueAssertTestCase: XCTestCase {
    func testAssertOnQueueSuccess() {
        // Given
        let mock = FailMock()
        let queue = DispatchQueue(label: "Test Queue")
        var completionCalled = false

        // When
        queue.sync {
            XCTAssertOnQueue(queue, reporter: mock) {
                completionCalled = true
            }
        }

        // Then
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
        XCTAssertTrue(completionCalled)
    }

    func testAssertOnQueueNoClosure() {
        // Given
        let mock = FailMock()
        let queue = DispatchQueue(label: "Test Queue")

        // When
        queue.sync {
            XCTAssertOnQueue(queue, reporter: mock)
        }

        // Then
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAssertOnQueueFail() {
        // Given
        let mock = FailMock()
        let actualQueue = DispatchQueue(label: "Actual Queue")
        let expectedQueue = DispatchQueue(label: "Expected Queue")
        var completionCalled = false

        // When
        actualQueue.sync {
            XCTAssertOnQueue(expectedQueue, "custom message", reporter: mock, file: "some file", line: 123) {
                completionCalled = true
            }
        }

        // Then
        XCTAssertEqual(
            mock.message,
            #"XCTAssertOnQueue - label of current queue ("Actual Queue") is not equal to ("Expected Queue") - custom message"#
        )
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
        XCTAssertFalse(completionCalled)
    }

    func testAssertOnQueueWithThrowingExpression() {
        // Given
        let mock = FailMock()
        let expression: () throws -> DispatchQueue = { throw MockError() }
        var completionCalled = false

        // When
        XCTAssertOnQueue(try expression(), "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertEqual(mock.message, #"XCTAssertOnQueue - threw error "Mock Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
        XCTAssertFalse(completionCalled)
    }

    func testAssertOnQueueWithThrowingThen() {
        // Given
        let mock = FailMock()
        let queue = DispatchQueue(label: "Test Queue")
        var completionCalled = false

        // When
        queue.sync {
            XCTAssertOnQueue(queue, "custom message", reporter: mock, file: "some file", line: 123) {
                completionCalled = true
                throw MockError()
            }
        }

        // Then
        XCTAssertEqual(mock.message, #"XCTAssertOnQueue - then closure threw error "Mock Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
        XCTAssertTrue(completionCalled)
    }

    func testAssertOnQueueWithThrowingCallInAutoclosureInThen() {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        let queue = DispatchQueue(label: "Test Queue")
        var completionCalled = false

        // When
        queue.sync {
            XCTAssertOnQueue(queue) {
                throwingAutoclosure(try functionThatCanThrow())
                completionCalled = true
            }
        }

        // Then
        XCTAssertTrue(completionCalled)
    }
}
