//  XCTSubstringAssertsTests.swift
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
import GauntletLegacy
import XCTest

class XCTSubstringAssertsTestCase: XCTestCase {

    // MARK: - Assert(_, contains:)

    func testSubstringAssert() {
        // Given
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssert("some string", contains: "some", reporter: mock) {
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testSubstringAssertNoClosure() {
        // Given
        let mock = FailMock()

        // When
        XCTAssert("some string", contains: "some", reporter: mock)

        // Then
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testFailingSubstringAssertOnNil() {
        // Given
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssert(nil, contains: "something", "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(
            mock.message,
            #"XCTAssert(_, contains:) - nil string does not contain "something" - custom message"#
        )

        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testFailingSubstringAssert() {
        // Given
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssert("some string", contains: "fail", "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(
            mock.message,
            #"XCTAssert(_, contains:) - "fail" not found in "some string" - custom message"#
        )

        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testThrowingSubstringAssert() {
        // Given
        let expression: () throws -> String = { throw MockError.someError }
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssert(try expression(), contains: "fail", "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssert(_, contains:) - threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testSubstringAssertWithThrowingThen() {
        // Given
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssert("some string", contains: "some", "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
            throw MockError.someError
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssert(_, contains:) - then closure threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testSubstringAssertWithThrowingCallInAutoclosureInThen() {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        var completionCalled = false

        // When
        XCTAssert("some string", contains: "some") {
            throwingAutoclosure(try functionThatCanThrow())
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
    }
}
