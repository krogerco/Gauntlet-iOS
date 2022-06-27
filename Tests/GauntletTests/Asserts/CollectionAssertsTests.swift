//  CollectionAssertsTests.swift
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

// swiftlint:disable discouraged_optional_collection

class CollectionAssertsTestCase: XCTestCase {

    // MARK: - XCTAssertIsEmpty

    func testAssertIsEmpty() {
        // Given
        let array: [Int] = []
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertIsEmpty(array, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAssertIsEmptyNoClosure() {
        // Given
        let array: [Int] = []
        let mock = FailMock()

        // When
        XCTAssertIsEmpty(array, "custom message", reporter: mock, file: "some file", line: 123)

        // Then
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testFailingAssertIsEmpty() {
        // Given
        let array = [1, 2, 3]
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertIsEmpty(array, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, "XCTAssertIsEmpty - custom message")
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testThrowingAssertIsEmpty() {
        // Given
        let mock = FailMock()
        let expression: () throws -> [Int] = { throw MockError() }
        var completionCalled = false

        // When
        XCTAssertIsEmpty(try expression(), "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertIsEmpty - threw error "Mock Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertIsEmptyThrowingInThen() {
        // Given
        let mock = FailMock()
        let expression: () throws -> [Int] = { throw MockError() }
        var completionCalled = false

        // When
        XCTAssertIsEmpty(try expression(), "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertIsEmpty - threw error "Mock Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertIsEmptyWithThrowingCallInAutoclosureInThen() {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        let emptyArray: [Int] = []
        var completionCalled = false

        XCTAssertIsEmpty(emptyArray) {
            throwingAutoclosure(try functionThatCanThrow())
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
    }

    // MARK: - XCTAssertIsNotEmpty

    func testAssertIsNotEmpty() {
        // Given
        let array = [1, 2, 3]
        let mock = FailMock()
        var completionCalled = false
        var arrayPassedToClosure: [Int]?

        // When
        XCTAssertIsNotEmpty(array, "custom message", reporter: mock, file: "some file", line: 123) { array in
            arrayPassedToClosure = array
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(arrayPassedToClosure, array)
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAssertIsNotEmptyNoClosure() {
        // Given
        let array = [1, 2, 3]
        let mock = FailMock()

        // When
        XCTAssertIsNotEmpty(array, "custom message", reporter: mock, file: "some file", line: 123)

        // Then
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testFailingAssertIsNotEmpty() {
        // Given
        let array: [Int] = []
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertIsNotEmpty(array, "custom message", reporter: mock, file: "some file", line: 123) { _ in
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, "XCTAssertIsNotEmpty - custom message")
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testFailingAssertIsNotEmptyWithNil() {
        // Given
        let array: [Int]? = nil
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertIsNotEmpty(array, "custom message", reporter: mock, file: "some file", line: 123) { _ in
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, "XCTAssertIsNotEmpty - custom message")
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testThrowingAssertIsNotEmpty() {
        // Given
        let expression: () throws -> [Int] = { throw MockError() }
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertIsNotEmpty(try expression(), "custom message", reporter: mock, file: "some file", line: 123) { _ in
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertIsNotEmpty - threw error "Mock Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertIsNotEmptyWithThrowingThen() {
        // Given
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertIsNotEmpty([1, 2, 3], "custom message", reporter: mock, file: "some file", line: 123) { _ in
            completionCalled = true
            throw MockError()
        }

        // Then
        XCTAssert(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertIsNotEmpty - then closure threw error "Mock Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertIsNotEmptyWithThrowingCallInAutoclosureInThen() {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        var completionCalled = false

        XCTAssertIsNotEmpty([1, 2, 3]) { _ in
            throwingAutoclosure(try functionThatCanThrow())
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
    }
}
