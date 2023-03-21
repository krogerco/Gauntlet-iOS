//  XCTEqualityAssertsTests.swift
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

import GauntletLegacy
import XCTest

// swiftlint:disable type_body_length file_length
class XCTEqualityAssertsTests: XCTestCase {

    // MARK: - XCTAssertEqual

    func testAssertEqualWithEqualValues() {
        // Given
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertEqual(5, 5, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAssertEqualWithUnequalValues() {
        // Given
        let one = 1
        let two = 2
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertEqual(one, two, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertEqual(mock.message, #"XCTAssertEqual - ("1") is not equal to ("2") - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
        XCTAssertFalse(completionCalled)
    }

    func testAssertEqualWithNilFirstValue() {
        // Given
        let nilInt: Int? = nil
        let two = 2
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertEqual(nilInt, two, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertEqual(mock.message, #"XCTAssertEqual - ("nil") is not equal to ("2") - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
        XCTAssertFalse(completionCalled)
    }

    func testAssertEqualWithNilSecondValue() {
        // Given
        let one = 1
        let nilInt: Int? = nil
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertEqual(one, nilInt, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertEqual(mock.message, #"XCTAssertEqual - ("1") is not equal to ("nil") - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
        XCTAssertFalse(completionCalled)
    }

    func testAssertEqualWithThrowingFirstValue() {
        // Given
        let expression: () throws -> Int = { throw MockError.someError }
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertEqual(try expression(), 2, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertEqual(mock.message, #"XCTAssertEqual - threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
        XCTAssertFalse(completionCalled)
    }

    func testAssertEqualWithThrowingSecondValue() {
        // Given
        let expression: () throws -> Int = { throw MockError.someError }
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertEqual(1, try expression(), "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertEqual(mock.message, #"XCTAssertEqual - threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
        XCTAssertFalse(completionCalled)
    }

    func testAssertEqualWithThrowingThen() {
        // Given
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertEqual(1, 1, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
            throw MockError.someError
        }

        // Then
        XCTAssertEqual(mock.message, #"XCTAssertEqual - then closure threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
        XCTAssertTrue(completionCalled)
    }

    func testAssertEqualWithThrowingCallInAutoclosureInThen() {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        var completionCaled = false

        // When
        XCTAssertEqual(1, 1) {
            throwingAutoclosure(try functionThatCanThrow())
            completionCaled = true
        }

        // Then
        XCTAssertTrue(completionCaled)
    }

    // MARK: - XCTAssertIdential

    func testAssertIdentical() {
        // Given
        let object = NSObject()
        let mock = FailMock()
        var closureCalled = false

        XCTAssertIdentical(object, object, "custom message", reporter: mock, file: "some file", line: 123) {
            closureCalled = true
        }

        // Then
        XCTAssertTrue(closureCalled)
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAssertIdenticalNoClosure() {
        // Given
        let object = NSObject()
        let mock = FailMock()

        XCTAssertIdentical(object, object, "custom message", reporter: mock, file: "some file", line: 123)

        // Then
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testFailingAssertIdential() {
        // Given
        let one = NSObject()
        let two = NSObject()
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertIdentical(one, two, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, "XCTAssertIdentical - custom message")
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertIdentialWithThrowingFirstValue() {
        // Given
        let expression: () throws -> NSObject = { throw MockError.someError }
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertIdentical(try expression(), NSObject(), "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertIdentical - threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertIdentialWithThrowingSecondValue() {
        // Given
        let expression: () throws -> NSObject = { throw MockError.someError }
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertIdentical(NSObject(), try expression(), "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertIdentical - threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertIdentialWithThrowingThen() {
        // Given
        let object = NSObject()
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertIdentical(object, object, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
            throw MockError.someError
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertIdentical - then closure threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertIdenticalWithThrowingCallInAutoclosureInThen() {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        let object = NSObject()
        var completionCalled = false

        // When
        XCTAssertIdentical(object, object) {
            throwingAutoclosure(try functionThatCanThrow())
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
    }

    // MARK: - XCTAssertNotIdentical

    func testAssertNotIdentical() {
        // Given
        let lhs = NSObject()
        let rhs = NSObject()
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertNotIdentical(lhs, rhs, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAssertNotIdenticalNoClosure() {
        // Given
        let lhs = NSObject()
        let rhs = NSObject()
        let mock = FailMock()

        // When
        XCTAssertNotIdentical(lhs, rhs, "custom message", reporter: mock, file: "some file", line: 123)

        // Then
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testFailingAssertNotIdential() {
        // Given
        let object = NSObject()
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertNotIdentical(object, object, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, "XCTAssertNotIdentical - custom message")
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertNotIdentialWithThrowingFirstValue() {
        // Given
        let expression: () throws -> NSObject = { throw MockError.someError }
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertNotIdentical(try expression(), NSObject(), "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertNotIdentical - threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertNotIdenticalWithThrowingSecondValue() {
        // Given
        let expression: () throws -> NSObject = { throw MockError.someError }
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertNotIdentical(NSObject(), try expression(), "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertNotIdentical - threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertNotIdenticalWithThrowingThen() {
        // Given
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertNotIdentical(NSObject(), NSObject(), "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
            throw MockError.someError
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertNotIdentical - then closure threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertNotIdenticalWithThrowingCallInAutoclosureInThen() {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        var completionCalled = false

        // When
        XCTAssertNotIdentical(NSObject(), NSObject()) {
            throwingAutoclosure(try functionThatCanThrow())
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
    }

    // MARK: - XCTAssertZero

    func testAssertZero() {
        // Given
        let mock = FailMock()
        var closureCalled = false

        // When
        XCTAssertZero(UInt(0), "custom message", reporter: mock, file: "some file", line: 123) {
            closureCalled = true
        }

        // Then
        XCTAssertTrue(closureCalled)
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAssertZeroNoClosure() {
        // Given
        let mock = FailMock()

        // When
        XCTAssertZero(UInt(0), "custom message", reporter: mock, file: "some file", line: 123)

        // Then
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testFailingAssertZero() {
        // Given
        let mock = FailMock()
        var closureCalled = false

        // When
        XCTAssertZero(UInt(1), "custom message", reporter: mock, file: "some file", line: 123) {
            closureCalled = true
        }

        // Then
        XCTAssertFalse(closureCalled)
        XCTAssertEqual(mock.message, #"XCTAssertZero - ("1") is not 0 - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testThrowingAssertZero() {
        // Given
        let expression: () throws -> UInt = { throw MockError.someError }
        let mock = FailMock()
        var closureCalled = false

        // When
        XCTAssertZero(try expression(), "custom message", reporter: mock, file: "some file", line: 123) {
            closureCalled = true
        }

        // Then
        XCTAssertFalse(closureCalled)
        XCTAssertEqual(mock.message, #"XCTAssertZero - threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)

    }

    func testAssertZeroWithThrowingThen() {
        // Given
        let mock = FailMock()
        var closureCalled = false

        // When
        XCTAssertZero(UInt(0), "custom message", reporter: mock, file: "some file", line: 123) {
            closureCalled = true
            throw MockError.someError
        }

        // Then
        XCTAssertTrue(closureCalled)
        XCTAssertEqual(mock.message, #"XCTAssertZero - then closure threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertZeroWithThrowingCallInAutoclosureInThen() {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        var closureCalled = false

        // When
        XCTAssertZero(UInt(0)) {
            throwingAutoclosure(try functionThatCanThrow())
            closureCalled = true
        }

        // Then
        XCTAssertTrue(closureCalled)
    }

    // MARK: - XCTAwaitAssertEqual

    func testAwaitAssertEqualWithEqualValues() async {
        // Given
        let mock = FailMock()
        var completionCallCount = 0
        let stringValue = "string value"
        func expression() async throws -> String { stringValue }

        // When
        await XCTAwaitAssertEqual(stringValue, try await expression(), reporter: mock, file: "fake file", line: 123) {
            completionCallCount += 1
        }

        await XCTAwaitAssertEqual(try await expression(), stringValue, reporter: mock, file: "fake file", line: 123) {
            completionCallCount += 1
        }

        // Then
        XCTAssertEqual(2, completionCallCount)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
        XCTAssertNil(mock.message)
    }

    func testAwaitAssertEqualWithEqualOptionalValues() async {
        // Given
        let mock = FailMock()
        var completionCallCount = 0
        let stringValue = "string value"
        func expression() async throws -> String? { stringValue }

        // When
        await XCTAwaitAssertEqual(stringValue, try await expression(), reporter: mock, file: "fake file", line: 123) {
            completionCallCount += 1
        }

        await XCTAwaitAssertEqual(try await expression(), stringValue, reporter: mock, file: "fake file", line: 123) {
            completionCallCount += 1
        }

        // Then
        XCTAssertEqual(2, completionCallCount)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
        XCTAssertNil(mock.message)
    }

    func testAwaitAssertEqualWithThrowingExpression() async {
        // Given
        let expression: () async throws -> Int = { throw MockError.someError }

        // And
        let mock1 = FailMock()
        var firstCompletionCalled = false

        // And
        let mock2 = FailMock()
        var secondCompletionCalled = false

        // When
        await XCTAwaitAssertEqual(try await expression(), 2, "custom message", reporter: mock1, file: "fake file", line: 123) {
            firstCompletionCalled = true
        }

        // Then
        XCTAssertEqual(mock1.message, #"XCTAwaitAssertEqual - threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock1.file, "fake file")
        XCTAssertEqual(mock1.line, 123)
        XCTAssertFalse(firstCompletionCalled)

        // When
        await XCTAwaitAssertEqual(2, try await expression(), "custom message", reporter: mock2, file: "fake file", line: 123) {
            secondCompletionCalled = true
        }

        // Then
        XCTAssertEqual(mock2.message, #"XCTAwaitAssertEqual - threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock2.file, "fake file")
        XCTAssertEqual(mock2.line, 123)
        XCTAssertFalse(secondCompletionCalled)
    }

    func testAwaitAssertEqualReportingNotEqual() async {
        // Given
        let mock = FailMock()
        var completionCalled = false
        let someValue = "some value"
        let anotherValue = "another value"
        func expression() async throws -> String { anotherValue }

        // When
        await XCTAwaitAssertEqual(someValue, try await expression(), "fake message", reporter: mock, file: "fake file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.line, 123)
        XCTAssertEqual(mock.file, "fake file")
        XCTAssertEqual(mock.message, #"XCTAwaitAssertEqual - ("some value") is not equal to ("another value") - fake message"#)
    }

    func testAwaitAssertEqualReportingNotEqualNil() async {
        // Given
        let mock = FailMock()
        var completionCalled = false
        let someValue = "some value"
        func expression() async throws -> String? { nil }

        // When
        await XCTAwaitAssertEqual(someValue, try await expression(), "fake message", reporter: mock, file: "fake file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.line, 123)
        XCTAssertEqual(mock.file, "fake file")
        XCTAssertEqual(mock.message, #"XCTAwaitAssertEqual - ("some value") is not equal to ("nil") - fake message"#)
    }
}
