//  XCTResultSuccessAssertsTests.swift
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

// swiftlint:disable type_body_length file_length

class XCTResultSuccessAssertsTestCase: XCTestCase {

    // MARK: - AssertSuccess

    func testAssertSuccess() {
        // Given
        let result: Result<Int, MockError> = .success(5)
        let mock = FailMock()
        var completionCalled = false
        var valuePassedToCompletion: Int?

        // When, Then
        XCTAssertSuccess(result, reporter: mock) { value in
            completionCalled = true
            valuePassedToCompletion = value
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(valuePassedToCompletion, 5)
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAssertSuccessNoClosure() {
        // Given
        let result: Result<Int, MockError> = .success(5)
        let mock = FailMock()

        // When, Then
        XCTAssertSuccess(result, reporter: mock)

        // Then
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testFailingAssertSuccess() {
        // Given
        let result: Result<Int, MockError> = .failure(MockError.someError)
        let mock = FailMock()

        // When
        XCTAssertSuccess(result, "custom message", reporter: mock, file: "some file", line: 123)

        // Then
        XCTAssertEqual(mock.message, #"XCTAssertSuccess - Result is .failure("Some Error") - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testFailingOptionalAssertSuccessOnNil() {
        // Given
        let result: Result<Int, MockError>? = nil
        let mock = FailMock()

        // When
        XCTAssertSuccess(result, "custom message", reporter: mock, file: "some file", line: 123)

        // Then
        XCTAssertEqual(mock.message, "XCTAssertSuccess - Result is nil - custom message")
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testThrowingAssertSuccess() {
        // Given
        let expression: () throws -> Result<Int, MockError> = { throw MockError.someError }
        let mock = FailMock()

        // When
        XCTAssertSuccess(try expression(), "custom message", reporter: mock, file: "some file", line: 123)

        // Then
        XCTAssertEqual(mock.message, #"XCTAssertSuccess - threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertSuccessWithThrowingThen() {
        // Given
        let result = Result<Int, MockError>.success(5)
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertSuccess(result, "custom message", reporter: mock, file: "some file", line: 123) { _ in
            completionCalled = true
            throw MockError.someError
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertSuccess - then closure threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertSuccessWithThrowingCallInAutoclosureInThen() {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        let result = Result<Int, MockError>.success(5)
        var completionCalled = false

        // When
        XCTAssertSuccess(result) { _ in
            throwingAutoclosure(try functionThatCanThrow())
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
    }

    // MARK: - AssertSuccess(_, equalTo:)

    func testAssertSuccessEqualTo() {
        // Given
        let result: Result<Int, MockError> = .success(3)
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertSuccess(result, equalTo: 3, reporter: mock) {
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAssertSuccessEqualToNoClosure() {
        // Given
        let result: Result<Int, MockError> = .success(3)
        let mock = FailMock()

        // When
        XCTAssertSuccess(result, equalTo: 3, reporter: mock)

        // Then
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAssertSuccessEqualToWithUnequalValue() {
        // Given
        let result: Result<Int, Error> = .success(3)
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertSuccess(result, equalTo: 5, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertSuccess - ("3") is not equal to ("5") - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertSuccessEqualToWithNilResult() {
        // Given
        let result: Result<Int, Error>? = nil
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertSuccess(result, equalTo: 3, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, "XCTAssertSuccess - Result is nil - custom message")
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testThrowingAssertSuccessEqualTo() {
        // Given
        let expression: () throws -> Result<Int, Error> = { throw MockError.someError }
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertSuccess(try expression(), equalTo: 5, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertSuccess - threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertSuccessEqualToWithThrowingThen() {
        // Given
        let result = Result<Int, Error>.success(5)
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertSuccess(result, equalTo: 5, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
            throw MockError.someError
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertSuccess - then closure threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertSuccessEqualToWithThrowingCallInAutoclosureInThen() {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        let result = Result<Int, Error>.success(5)
        var completionCalled = false

        // When
        XCTAssertSuccess(result, equalTo: 5) {
            throwingAutoclosure(try functionThatCanThrow())
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
    }

    // MARK: - AssertSuccess(_, keyPath, isEqualTo:)

    func testAssertSuccessKeyPathEqualTo() {
        // Given
        let user = User(name: "Roger")
        let result: Result<User, Error> = .success(user)
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertSuccess(result, keyPath: \.name, isEqualTo: "Roger", reporter: mock) {
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAssertSuccessKeyPathEqualToNoClosure() {
        // Given
        let user = User(name: "Roger")
        let result: Result<User, Error> = .success(user)
        let mock = FailMock()

        // When
        XCTAssertSuccess(result, keyPath: \.name, isEqualTo: "Roger", reporter: mock)

        // Then
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAssertSuccessKeyPathEqualToWithUnequalValue() {
        // Given
        let result: Result<User, Error> = .success(User(name: "Roger"))
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertSuccess(
            result,
            keyPath: \.name,
            isEqualTo: "Terry",
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
        XCTAssertEqual(mock.message, #"XCTAssertSuccess - ("Roger") is not equal to ("Terry") - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testOptionalAssertSuccessKeyPathEqualToWithNilResult() {
        // Given
        let result: Result<User, Error>? = nil
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertSuccess(
            result,
            keyPath: \.name,
            isEqualTo: "Roger",
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
        XCTAssertEqual(mock.message, "XCTAssertSuccess - Result is nil - custom message")
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testThrowingAssertSuccessKeyPathEqualTo() {
        // Given
        let expression: () throws -> Result<User, Error> = { throw MockError.someError }
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertSuccess(
            try expression(),
            keyPath: \.name,
            isEqualTo: "Roger",
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
        XCTAssertEqual(mock.message, #"XCTAssertSuccess - threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertSuccessKeyPathEqualToWithThrowingThen() {
        // Given
        let result: Result<User, Error> = .success(User(name: "Roger"))
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertSuccess(
            result,
            keyPath: \.name,
            isEqualTo: "Roger",
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
        XCTAssertEqual(mock.message, #"XCTAssertSuccess - then closure threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertSuccessKeyPathEqualToWithThrowingCallInAutoclosureInThen() {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        let result = Result<User, Error>.success(User(name: "Roger"))
        var completionCalled = false

        // When
        XCTAssertSuccess(result, keyPath: \.name, isEqualTo: "Roger") {
            throwingAutoclosure(try functionThatCanThrow())
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
    }

    // MARK: - AssertSuccess(_, is:)

    func testAssertSuccessIs() {
        // Given
        let result: Result<Any, Error> = .success(5)
        let mock = FailMock()
        var completionCalled = false
        var valuePassedToCompletion: Int?

        // When
        XCTAssertSuccess(result, is: Int.self, reporter: mock) { value in
            completionCalled = true
            valuePassedToCompletion = value
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(valuePassedToCompletion, 5)
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAssertSuccessIsNoClosure() {
        // Given
        let result: Result<Any, Error> = .success(5)
        let mock = FailMock()

        // When
        XCTAssertSuccess(result, is: Int.self, reporter: mock)

        // Then
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAssertSuccessIsWithNilResult() {
        // Given
        let result: Result<Any, Error>? = nil
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertSuccess(result, is: Int.self, "custom message", reporter: mock, file: "some file", line: 123) { _ in
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, "XCTAssertSuccess - Result is nil - custom message")
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testSuccessIsWithFailingCast() {
        // Given
        let result: Result<Any, Error> = .success(5)
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertSuccess(result, is: String.self, "custom message", reporter: mock, file: "some file", line: 123) { _ in
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, "XCTAssertSuccess - value of type Int is not expected type String - custom message")
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testThrowingAssertSuccessIs() {
        // Given
        let expression: () throws -> Result<Any, Error> = { throw MockError.someError }
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertSuccess(try expression(), is: String.self, "custom message", reporter: mock, file: "some file", line: 123) { _ in
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertSuccess - threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertSuccessIsWithThrowingThen() {
        // Given
        let result: Result<Any, Error> = .success(5)
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertSuccess(result, is: Int.self, "custom message", reporter: mock, file: "some file", line: 123) { _ in
            completionCalled = true
            throw MockError.someError
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertSuccess - then closure threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertSuccessIsWithThrowingCallInAutoclosureInThen() {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        let result: Result<Any, Error> = .success(5)
        var completionCalled = false

        // When
        XCTAssertSuccess(result, is: Int.self) { _ in
            throwingAutoclosure(try functionThatCanThrow())
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
    }

    // MARK: - AssertSuccess(_, is:, equalTo:)

    func testAssertSuccessIsEqualTo() {
        // Given
        let result: Result<Any, Error> = .success(5)
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertSuccess(result, is: Int.self, equalTo: 5, reporter: mock) {
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAssertSuccessIsEqualToNoClosure() {
        // Given
        let result: Result<Any, Error> = .success(5)
        let mock = FailMock()

        // When
        XCTAssertSuccess(result, is: Int.self, equalTo: 5, reporter: mock)

        // Then
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testSuccessIsEqualToWithFailingComparison() {
        // Given
        let result: Result<Any, Error> = .success(5)
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertSuccess(
            result,
            is: Int.self,
            equalTo: 9,
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
        XCTAssertEqual(mock.message, #"XCTAssertSuccess - ("5") is not equal to ("9") - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertSuccessIsEqualToWithNilResult() {
        // Given
        let result: Result<Any, Error>? = nil
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertSuccess(
            result,
            is: Int.self,
            equalTo: 5,
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
        XCTAssertEqual(mock.message, "XCTAssertSuccess - Result is nil - custom message")
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testSuccessIsEqualToWithFailingCast() {
        // Given
        let result: Result<Any, Error> = .success(5)
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertSuccess(
            result,
            is: String.self,
            equalTo: "",
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
        XCTAssertEqual(mock.message, "XCTAssertSuccess - value of type Int is not expected type String - custom message")
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testThrowingAssertSuccessIsEqualTo() {
        // Given
        let expression: () throws -> Result<Any, Error> = { throw MockError.someError }
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertSuccess(
            try expression(),
            is: Int.self,
            equalTo: 5,
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
        XCTAssertEqual(mock.message, #"XCTAssertSuccess - threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertSuccessIsEqualToWithThrowingThen() {
        // Given
        let result: Result<Any, Error> = .success(5)
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertSuccess(
            result,
            is: Int.self,
            equalTo: 5,
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
        XCTAssertEqual(mock.message, #"XCTAssertSuccess - then closure threw error "Some Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertSuccessIsEqualToWithThrowingCallInAutoclosureInThen() {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        let result: Result<Any, Error> = .success(5)
        var completionCalled = false

        // When
        XCTAssertSuccess(result, is: Int.self, equalTo: 5) {
            throwingAutoclosure(try functionThatCanThrow())
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
    }
}

// MARK: - Helper Types

private struct User: Equatable {
    let name: String
}
