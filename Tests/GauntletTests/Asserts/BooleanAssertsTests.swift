//  BooleanAssertsTests.swift
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

// swiftlint:disable discouraged_optional_boolean

class BooleanAssertsTests: XCTestCase {

    // MARK: - XCTAssertTrue

    func testAssertTrueSuccess() {
        // Given
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertTrue(true, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
        XCTAssertTrue(completionCalled)
    }

    func testOptionalAssertTrueNoClosure() {
        // Given
        let mock = FailMock()
        let optionalBool: Bool? = true

        // When
        XCTAssertTrue(optionalBool, reporter: mock)

        // Then
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAssertTrueFail() {
        // Given
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertTrue(false, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertEqual(mock.message, #"XCTAssertTrue - ("false") is not true - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
        XCTAssertFalse(completionCalled)
    }

    func testAssertTrueOnNil() {
        // Given
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertTrue(nil, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertEqual(mock.message, #"XCTAssertTrue - ("nil") is not true - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
        XCTAssertFalse(completionCalled)
    }

    func testAssertTrueWithThrowingExpression() {
        // Given
        let mock = FailMock()
        var completionCalled = false
        let expression: () throws -> Bool = { throw MockError() }

        // When
        XCTAssertTrue(try expression(), "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertTrue - threw error "Mock Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertTrueWithThrowingCallInAutoclosureInThen() {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        var completionCalled = false

        // When
        XCTAssertTrue(true) {
            throwingAutoclosure(try functionThatCanThrow())
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
    }

    func testAssertTrueWithThrowingThen() {
        // Given
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertTrue(true, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
            throw MockError()
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertTrue - then closure threw error "Mock Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    // MARK: - XCTAssertFalse

    func testAssertFalseSuccess() {
        // Given
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertFalse(false, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
        XCTAssertTrue(completionCalled)
    }

    func testOptionalAssertFalseNoClosure() {
        // Given
        let mock = FailMock()
        let optionalBool: Bool? = false

        // When
        XCTAssertFalse(optionalBool, reporter: mock)

        // Then
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAssertFalseFail() {
        // Given
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertFalse(true, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertEqual(mock.message, #"XCTAssertFalse - ("true") is not false - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
        XCTAssertFalse(completionCalled)
    }

    func testAssertFalseOnNil() {
        // Given
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertFalse(nil, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertEqual(mock.message, #"XCTAssertFalse - ("nil") is not true - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
        XCTAssertFalse(completionCalled)
    }

    func testAssertFalseWithThrowingExpression() {
        // Given
        let mock = FailMock()
        var completionCalled = false
        let expression: () throws -> Bool = { throw MockError() }

        // When
        XCTAssertFalse(try expression(), "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertFalse - threw error "Mock Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertFalseWithThrowingCallInAutoclosureInThen() {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        var completionCalled = false

        // When
        XCTAssertFalse(false) {
            throwingAutoclosure(try functionThatCanThrow())
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
    }

    func testAssertFalseWithThrowingThen() {
        // Given
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertFalse(false, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
            throw MockError()
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertFalse - then closure threw error "Mock Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }
}
