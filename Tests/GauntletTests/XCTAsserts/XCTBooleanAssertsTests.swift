//  XCTBooleanAssertsTests.swift
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

// swiftlint:disable discouraged_optional_boolean type_body_length

class XCTBooleanAssertsTests: XCTestCase {

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

    func testAwaitAssertTrueSuccess() async {
        // Given
        let mock = FailMock()
        var completionCalled = false
        let bool: () async -> Bool = { true }

        // When
        await XCTAwaitAssertTrue(await bool(), "custom message", reporter: mock, file: "some file", line: 123) {
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

    func testOptionalAwaitAssertTrueNoClosure() async {
        // Given
        let mock = FailMock()
        let optionalBool: () async -> Bool? = { true }

        // When
        await XCTAwaitAssertTrue(await optionalBool(), reporter: mock)

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

    func testAwaitAssertTrueFail() async {
        // Given
        let mock = FailMock()
        var completionCalled = false
        let boolAsFalse: () async -> Bool = { false }

        // When
        await XCTAwaitAssertTrue(await boolAsFalse(), "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertEqual(mock.message, #"XCTAwaitAssertTrue - ("false") is not true - custom message"#)
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

    func testAwaitAssertTrueOnNil() async {
        // Given
        let mock = FailMock()
        var completionCalled = false
        let optionalBoolAsNil: () async -> Bool? = { nil }

        // When
        await XCTAwaitAssertTrue(await optionalBoolAsNil(), "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertEqual(mock.message, #"XCTAwaitAssertTrue - ("nil") is not true - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
        XCTAssertFalse(completionCalled)
    }

    func testAssertTrueWithThrowingExpression() {
        // Given
        let mock = FailMock()
        var completionCalled = false
        let expression: () throws -> Bool = { throw MockError.someError }

        // When
        XCTAssertTrue(try expression(), "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertTrue - threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAwaitAssertTrueWithThrowingExpression() async {
        // Given
        let mock = FailMock()
        var completionCalled = false
        let expression: () async throws -> Bool = { throw MockError.someError }

        // When
        await XCTAwaitAssertTrue(try await expression(), "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAwaitAssertTrue - threw error "Some Error" - custom message"#)
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

    func testAwaitAssertTrueWithThrowingCallInAutoclosureInThen() async {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        var completionCalled = false
        let boolAsTrue: () async -> Bool = { true }

        // When
        await XCTAwaitAssertTrue(await boolAsTrue()) {
            await asyncThrowingAutoclosure(try await asyncFunctionThatCanThrow())
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
            throw MockError.someError
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertTrue - then closure threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAwaitAssertTrueWithThrowingThen() async {
        // Given
        let mock = FailMock()
        var completionCalled = false
        let boolAsTrue: () async -> Bool = { true }

        // When
        await XCTAwaitAssertTrue(await boolAsTrue(), "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
            throw MockError.someError
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAwaitAssertTrue - then closure threw error "Some Error" - custom message"#)
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

    func testAwaitAssertFalseSuccess() async {
        // Given
        let mock = FailMock()
        var completionCalled = false
        let boolAsFalse: () async -> Bool = { false }

        // When
        await XCTAwaitAssertFalse(await boolAsFalse(), "custom message", reporter: mock, file: "some file", line: 123) {
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

    func testOptionalAwaitAssertFalseNoClosure() async {
        // Given
        let mock = FailMock()
        let optionalBoolAsFalse: () async -> Bool? = { false }

        // When
        await XCTAwaitAssertFalse(await optionalBoolAsFalse(), reporter: mock)

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

    func testAwaitAssertFalseFail() async {
        // Given
        let mock = FailMock()
        var completionCalled = false
        let boolAsTrue: () async -> Bool = { true }

        // When
        await XCTAwaitAssertFalse(await boolAsTrue(), "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertEqual(mock.message, #"XCTAwaitAssertFalse - ("true") is not false - custom message"#)
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
        XCTAssertEqual(mock.message, #"XCTAssertFalse - ("nil") is not false - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
        XCTAssertFalse(completionCalled)
    }

    func testAwaitAssertFalseOnNil() async {
        // Given
        let mock = FailMock()
        var completionCalled = false
        let optionalBoolAsNil: () async -> Bool? = { nil }

        // When
        await XCTAwaitAssertFalse(await optionalBoolAsNil(), "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertEqual(mock.message, #"XCTAwaitAssertFalse - ("nil") is not false - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
        XCTAssertFalse(completionCalled)
    }

    func testAssertFalseWithThrowingExpression() {
        // Given
        let mock = FailMock()
        var completionCalled = false
        let expression: () throws -> Bool = { throw MockError.someError }

        // When
        XCTAssertFalse(try expression(), "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertFalse - threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAwaitAssertFalseWithThrowingExpression() async {
        // Given
        let mock = FailMock()
        var completionCalled = false
        let expression: () async throws -> Bool = { throw MockError.someError }

        // When
        await XCTAwaitAssertFalse(try await expression(), "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAwaitAssertFalse - threw error "Some Error" - custom message"#)
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

    func testAwaitAssertFalseWithThrowingCallInAutoclosureInThen() async {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        var completionCalled = false
        let boolAsFalse: () async -> Bool = { false }

        // When
        await XCTAwaitAssertFalse(await boolAsFalse()) {
            await asyncThrowingAutoclosure(try await asyncFunctionThatCanThrow())
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
            throw MockError.someError
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertFalse - then closure threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAwaitAssertFalseWithThrowingThen() async {
        // Given
        let mock = FailMock()
        var completionCalled = false
        let boolAsFalse: () async -> Bool = { false }

        // When
        await XCTAwaitAssertFalse(await boolAsFalse(), "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
            throw MockError.someError
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAwaitAssertFalse - then closure threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }
}
