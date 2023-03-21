//  XCTThrowsAssertTests.swift
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

class XCTThrowAssertsTestCase: XCTestCase {

    // MARK: - XCTAssertThrowsError(_, ofType:) | await XCTAssertThrowsError(_, ofType:)

    func testAssertThrowsErrorOfType() {
        // Given
        let mock = FailMock()
        var completionCalled = false
        let errorToThrow = EquatableError.someError
        let thrower = Thrower(error: errorToThrow)
        var thrownError: EquatableError?

        // When
        XCTAssertThrowsError(try thrower.throw(), ofType: EquatableError.self, reporter: mock) { error in
            completionCalled = true
            thrownError = error
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(thrownError, errorToThrow)
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAsyncAssertThrowsErrorOfType() async {
        // Given
        let mock = FailMock()
        var completionCalled = false
        let errorToThrow = EquatableError.someError
        let thrower = Thrower(error: errorToThrow)
        var thrownError: EquatableError?

        // When
        await XCTAwaitAssertThrowsError(try await thrower.asyncThrow(), ofType: EquatableError.self, reporter: mock) { error in
            completionCalled = true
            thrownError = error
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(thrownError, errorToThrow)
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAssertThrowsErrorOfTypeNoClosure() {
        // Given
        let mock = FailMock()
        let errorToThrow = EquatableError.someError
        let thrower = Thrower(error: errorToThrow)

        // When
        XCTAssertThrowsError(try thrower.throw(), ofType: EquatableError.self, reporter: mock)

        // Then
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAsyncAssertThrowsErrorOfTypeNoClosure() async {
        // Given
        let mock = FailMock()
        let errorToThrow = EquatableError.someError
        let thrower = Thrower(error: errorToThrow)

        // When
        await XCTAwaitAssertThrowsError(try await thrower.asyncThrow(), ofType: EquatableError.self, reporter: mock)

        // Then
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAssertThrowsErrorOfTypeWithNonThrowingExpression() {
        // Given
        let mock = FailMock()

        // When
        XCTAssertThrowsError(
            "no throw",
            ofType: EquatableError.self,
            "custom message",
            reporter: mock,
            file: "some file",
            line: 123
        )

        // Then
        XCTAssertEqual(mock.message, "XCTAssertThrowsError - expression did not throw an error - custom message")
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAsyncAssertThrowsErrorOfTypeWithNonThrowingExpression() async {
        // Given
        let mock = FailMock()

        // When
        await XCTAwaitAssertThrowsError(
            "no throw",
            ofType: EquatableError.self,
            "custom message",
            reporter: mock,
            file: "some file",
            line: 123
        )

        // Then
        XCTAssertEqual(mock.message, "XCTAwaitAssertThrowsError - expression did not throw an error - custom message")
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertThrowsErrorOfTypeWithIncorrectType() {
        // Given
        let mock = FailMock()
        let thrower = Thrower(error: WrongError())
        var completionCalled = false

        // When
        XCTAssertThrowsError(
            try thrower.throw(),
            ofType: EquatableError.self,
            "custom message",
            reporter: mock,
            file: "some file",
            line: 123,
            then: { _ in
                completionCalled = true
            }
        )

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(
            mock.message,
            "XCTAssertThrowsError - error of type WrongError is not expected type EquatableError - custom message"
        )
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAsyncAssertThrowsErrorOfTypeWithIncorrectType() async {
        // Given
        let mock = FailMock()
        let thrower = Thrower(error: WrongError())
        var completionCalled = false

        // When
        await XCTAwaitAssertThrowsError(
            try await thrower.asyncThrow(),
            ofType: EquatableError.self,
            "custom message",
            reporter: mock,
            file: "some file",
            line: 123,
            then: { _ in
                completionCalled = true
            }
        )

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(
            mock.message,
            "XCTAwaitAssertThrowsError - error of type WrongError is not expected type EquatableError - custom message"
        )
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertThrowsErrorOfTypeWithThrowingThen() {
        // Given
        let mock = FailMock()
        let thrower = Thrower(error: EquatableError.someError)
        var completionCalled = false

        // When
        XCTAssertThrowsError(
            try thrower.throw(),
            ofType: EquatableError.self,
            "custom message",
            reporter: mock,
            file: "some file",
            line: 123,
            then: { _ in
                completionCalled = true
                throw MockError.someError
            }
        )

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertThrowsError - then closure threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAsyncAssertThrowsErrorOfTypeWithThrowingThen() async {
        // Given
        let mock = FailMock()
        let thrower = Thrower(error: EquatableError.someError)
        var completionCalled = false

        // When
        await XCTAwaitAssertThrowsError(
            try await thrower.asyncThrow(),
            ofType: EquatableError.self,
            "custom message",
            reporter: mock,
            file: "some file",
            line: 123,
            then: { _ in
                completionCalled = true
                throw MockError.someError
            }
        )

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAwaitAssertThrowsError - then closure threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertThrowsErrorOfTypeWithThrowingCallInAutoclosureInThen() {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        var completionCalled = false
        let thrower = Thrower(error: MockError.someError)

        // When
        XCTAssertThrowsError(try thrower.throw(), ofType: MockError.self) { _ in
            throwingAutoclosure(try functionThatCanThrow())
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
    }

    func testAsyncAssertThrowsErrorOfTypeWithThrowingCallInAutoclosureInThen() async {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        var completionCalled = false
        let thrower = Thrower(error: MockError.someError)

        // When
        await XCTAwaitAssertThrowsError(try await thrower.asyncThrow(), ofType: MockError.self) { _ in
            throwingAutoclosure(try functionThatCanThrow())
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
    }

    // MARK: - XCTAssertThrowsError(_, equalTo:) | await XCTAssertThrowsError(_, equalTo:)

    func testAssertThrowsErrorEqualTo() {
        // Given
        let mock = FailMock()
        let errorToThrow = EquatableError.someError
        let thrower = Thrower(error: errorToThrow)
        var completionCalled = false

        // When
        XCTAssertThrowsError(try thrower.throw(), equalTo: EquatableError.someError, reporter: mock) {
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAsyncAssertThrowsErrorEqualTo() async {
        // Given
        let mock = FailMock()
        let errorToThrow = EquatableError.someError
        let thrower = Thrower(error: errorToThrow)
        var completionCalled = false

        // When
        await XCTAwaitAssertThrowsError(try await thrower.asyncThrow(), equalTo: EquatableError.someError, reporter: mock) {
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAssertThrowsErrorEqualToNoClosure() {
        // Given
        let mock = FailMock()
        let errorToThrow = EquatableError.someError
        let thrower = Thrower(error: errorToThrow)

        // When
        XCTAssertThrowsError(try thrower.throw(), equalTo: EquatableError.someError, reporter: mock)

        // Then
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAsyncAssertThrowsErrorEqualToNoClosure() async {
        // Given
        let mock = FailMock()
        let errorToThrow = EquatableError.someError
        let thrower = Thrower(error: errorToThrow)

        // When
        await XCTAwaitAssertThrowsError(try await thrower.asyncThrow(), equalTo: EquatableError.someError, reporter: mock)

        // Then
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAssertThrowsErrorEqualToWithNonThrowingExpression() {
        // Given
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertThrowsError(
            "no throw",
            equalTo: EquatableError.someError,
            "custom message",
            reporter: mock,
            file: "some file",
            line: 123,
            then: {
                completionCalled = true
            }
        )

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, "XCTAssertThrowsError - expression did not throw an error - custom message")
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAsyncAssertThrowsErrorEqualToWithNonThrowingExpression() async {
        // Given
        let mock = FailMock()
        var completionCalled = false

        // When
        await XCTAwaitAssertThrowsError(
            "no throw",
            equalTo: EquatableError.someError,
            "custom message",
            reporter: mock,
            file: "some file",
            line: 123,
            then: {
                completionCalled = true
            }
        )

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, "XCTAwaitAssertThrowsError - expression did not throw an error - custom message")
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertThrowsErrorEqualToWithIncorrectType() {
        // Given
        let mock = FailMock()
        let thrower = Thrower(error: WrongError())
        var completionCalled = false

        // When
        XCTAssertThrowsError(
            try thrower.throw(),
            equalTo: EquatableError.someError,
            "custom message",
            reporter: mock,
            file: "some file",
            line: 123,
            then: {
                completionCalled = true
            }
        )

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(
            mock.message,
            "XCTAssertThrowsError - error of type WrongError is not expected type EquatableError - custom message"
        )
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAsyncAssertThrowsErrorEqualToWithIncorrectType() async {
        // Given
        let mock = FailMock()
        let thrower = Thrower(error: WrongError())
        var completionCalled = false

        // When
        await XCTAwaitAssertThrowsError(
            try await thrower.asyncThrow(),
            equalTo: EquatableError.someError,
            "custom message",
            reporter: mock,
            file: "some file",
            line: 123,
            then: {
                completionCalled = true
            }
        )

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(
            mock.message,
            "XCTAwaitAssertThrowsError - error of type WrongError is not expected type EquatableError - custom message"
        )
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertThrowsErrorEqualToWithUnequalError() {
        // Given
        let mock = FailMock()
        let thrower = Thrower(error: EquatableError.someError)
        var completionCalled = false

        // When
        XCTAssertThrowsError(
            try thrower.throw(),
            equalTo: EquatableError.someOtherError,
            "custom message",
            reporter: mock,
            file: "some file",
            line: 123,
            then: {
                completionCalled = true
            }
        )

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(
            mock.message,
            "XCTAssertThrowsError - (\"Some Error\") is not equal to (\"Some Other Error\") - custom message"
        )
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAsyncAssertThrowsErrorEqualToWithUnequalError() async {
        // Given
        let mock = FailMock()
        let thrower = Thrower(error: EquatableError.someError)
        var completionCalled = false

        // When
        await XCTAwaitAssertThrowsError(
            try await thrower.asyncThrow(),
            equalTo: EquatableError.someOtherError,
            "custom message",
            reporter: mock,
            file: "some file",
            line: 123,
            then: {
                completionCalled = true
            }
        )

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(
            mock.message,
            "XCTAwaitAssertThrowsError - (\"Some Error\") is not equal to (\"Some Other Error\") - custom message"
        )
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertThrowsErrorEqualToWithThrowingThen() {
        // Given
        let mock = FailMock()
        let thrower = Thrower(error: EquatableError.someError)
        var completionCalled = false

        // When
        XCTAssertThrowsError(
            try thrower.throw(),
            equalTo: EquatableError.someError,
            "custom message",
            reporter: mock,
            file: "some file",
            line: 123,
            then: {
                completionCalled = true
                throw MockError.someError
            }
        )

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertThrowsError - then closure threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAsyncAssertThrowsErrorEqualToWithThrowingThen() async {
        // Given
        let mock = FailMock()
        let thrower = Thrower(error: EquatableError.someError)
        var completionCalled = false

        // When
        await XCTAwaitAssertThrowsError(
            try await thrower.asyncThrow(),
            equalTo: EquatableError.someError,
            "custom message",
            reporter: mock,
            file: "some file",
            line: 123,
            then: {
                completionCalled = true
                throw MockError.someError
            }
        )

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAwaitAssertThrowsError - then closure threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertThrowsErrorEqualToWithThrowingCallInAutoclosureInThen() {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        var completionCalled = false
        let thrower = Thrower(error: EquatableError.someError)

        // When
        XCTAssertThrowsError(try thrower.throw(), equalTo: EquatableError.someError) {
            throwingAutoclosure(try functionThatCanThrow())
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
    }

    func testAsyncAssertThrowsErrorEqualToWithThrowingCallInAutoclosureInThen() async {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        var completionCalled = false
        let thrower = Thrower(error: EquatableError.someError)

        // When
        await XCTAwaitAssertThrowsError(try await thrower.asyncThrow(), equalTo: EquatableError.someError) {
            throwingAutoclosure(try functionThatCanThrow())
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
    }

    // MARK: - XCTAssertNoThrow | await XCTAssertNoThrow

    func testAssertNoThrow() {
        // Given
        let mock = FailMock()
        var completionCalled = false
        var valuePassedToCompletion: Int?

        func nonThrowingFunction () throws -> Int { 2 }

        // When
        XCTAssertNoThrow(try nonThrowingFunction(), reporter: mock) { value in
            valuePassedToCompletion = value
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(valuePassedToCompletion, 2)
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAsyncAssertNoThrow() async {
        // Given
        let mock = FailMock()
        var completionCalled = false
        var valuePassedToCompletion: Int?

        func nonThrowingAsyncFunction () async throws -> Int { 2 }

        // When
        await XCTAwaitAssertNoThrow(try await nonThrowingAsyncFunction(), reporter: mock) { value in
            valuePassedToCompletion = value
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(valuePassedToCompletion, 2)
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testThrowingAssertNoThrow() {
        // Given
        let mock = FailMock()
        var completionCalled = false

        func throwingFunction () throws -> Int { throw MockError.someError }

        // When
        XCTAssertNoThrow(try throwingFunction(), "custom message", reporter: mock, file: "some file", line: 123) { _ in
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertNoThrow - threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAsyncThrowingAssertNoThrow() async {
        // Given
        let mock = FailMock()
        var completionCalled = false

        func throwingAsyncFunction () async throws -> Int { throw MockError.someError }

        // When
        await XCTAwaitAssertNoThrow(
            try await throwingAsyncFunction(),
            "custom message",
            reporter: mock,
            file: "some file",
            line: 123
        ) { _ in
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAwaitAssertNoThrow - threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertNoThrowWithThrowingThen() {
        // Given
        let mock = FailMock()
        var completionCalled = false

        func nonThrowingFunction () throws -> Int { 2 }

        // When
        XCTAssertNoThrow(try nonThrowingFunction(), "custom message", reporter: mock, file: "some file", line: 123) { _ in
            completionCalled = true
            throw MockError.someError
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertNoThrow - then closure threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAsyncAssertNoThrowWithThrowingThen() async {
        // Given
        let mock = FailMock()
        var completionCalled = false

        func nonThrowingAsyncFunction () async throws -> Int { 2 }

        // When
        await XCTAwaitAssertNoThrow(
            try await nonThrowingAsyncFunction(),
            "custom message",
            reporter: mock,
            file: "some file",
            line: 123
        ) { _ in
            completionCalled = true
            throw MockError.someError
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAwaitAssertNoThrow - then closure threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertNoThrowWithThrowingCallInAutoclosureInThen() {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        func nonThrowingFunction () throws -> Int { 2 }
        var completionCalled = false

        // When
        XCTAssertNoThrow(try nonThrowingFunction()) { _ in
            throwingAutoclosure(try functionThatCanThrow())
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
    }

    func testAsyncAssertNoThrowWithThrowingCallInAutoclosureInThen() async {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        func nonThrowingAsyncFunction () async throws -> Int { 2 }
        var completionCalled = false

        // When
        await XCTAwaitAssertNoThrow(try await nonThrowingAsyncFunction()) { _ in
            throwingAutoclosure(try functionThatCanThrow())
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
    }
}

// MARK: - Helper Types

struct Thrower {
    let error: Error

    func `throw`() throws {
        throw error
    }

    func asyncThrow() async throws {
        throw error
    }
}

struct WrongError: Error {}
