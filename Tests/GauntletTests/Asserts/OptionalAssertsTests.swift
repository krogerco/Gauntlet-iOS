//  OptionalAssertsTests.swift
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
import Foundation
import XCTest

class OptionalAssertsTestCase: XCTestCase {
    func testAssertNotNil() {
        // Given
        let value: Int? = 5
        var completionCalled = false
        var valuePassedToClosure: Int?

        // When
        XCTAssertNotNil(value) { nonNilValue in
            completionCalled = true
            valuePassedToClosure = nonNilValue
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(valuePassedToClosure, value)
    }

    // MARK: - Fail State Tests

    func testFailingAssertNotNil() {
        // Given
        let value: Int? = nil
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertNotNil(value, "custom message", reporter: mock, file: "some file", line: 123) { _ in
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, "XCTAssertNotNil - custom message")
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testThrowingOptionalAssert() {
        // Given
        let function: () throws -> Int? = { throw MockError() }
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertNotNil(try function(), "custom message", reporter: mock, file: "some file", line: 123) { _ in
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, "XCTAssertNotNil - threw error \"Mock Error\" - custom message")
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertNotNilWithThrowingThen() {
        // Given
        let value: Int? = 5
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertNotNil(value, "custom message", reporter: mock, file: "some file", line: 123) { _ in
            completionCalled = true
            throw MockError()
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(mock.message, "XCTAssertNotNil - then closure threw error \"Mock Error\" - custom message")
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertNotNilWithThrowingCallInAutoclosureInThen() {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        let value: Int? = 5
        var completionCalled = false

        // When
        XCTAssertNotNil(value) { _ in
            throwingAutoclosure(try functionThatCanThrow())
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
    }
}
