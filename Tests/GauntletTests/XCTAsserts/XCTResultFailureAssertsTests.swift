//  XCTResultFailureAssertsTests.swift
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

class XCTResultFailureAssertsTestCase: XCTestCase {

    // MARK: - AssertFailure

    func testAssertFailure() {
        // Given
        let result: Result<Int, Error> = .failure(MockError())
        let mock = FailMock()
        var completionCalled = false
        var errorPassedToCompletion: Error?

        // When
        XCTAssertFailure(result, reporter: mock) { error in
            completionCalled = true
            errorPassedToCompletion = error
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssert(errorPassedToCompletion, is: MockError.self)
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAssertFailureNoClosure() {
        // Given
        let result: Result<Int, Error> = .failure(MockError())
        let mock = FailMock()

        // When
        XCTAssertFailure(result, reporter: mock)

        // Then
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testFailingAssertFailure() {
        // Given
        let result: Result<Int, MockError> = .success(5)
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertFailure(result, "custom message", reporter: mock, file: "some file", line: 123) { _ in
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, "XCTAssertFailure - Result is .success - custom message")
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertFailureWithNilResult() {
        // Given
        let result: Result<Int, MockError>? = nil
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertFailure(result, "custom message", reporter: mock, file: "some file", line: 123) { _ in
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, "XCTAssertFailure - Result is nil - custom message")
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testThrowingAssertFailure() {
        // Given
        let function: () throws -> Result<Int, MockError> = { throw MockError() }
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertFailure(try function(), "custom message", reporter: mock, file: "some file", line: 123) { _ in
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertFailure - threw error "Mock Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertFailureWithThrowingThen() {
        // Given
        let result: Result<Int, MockError> = .failure(MockError())
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertFailure(result, "custom message", reporter: mock, file: "some file", line: 123) { _ in
            completionCalled = true
            throw MockError()
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertFailure - then closure threw error "Mock Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertFailureWithThrowingCallInAutoclosureInThen() {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        let result: Result<Int, MockError> = .failure(MockError())
        var completionCalled = false

        // When
        XCTAssertFailure(result) { _ in
            throwingAutoclosure(try functionThatCanThrow())
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
    }

    // MARK: - AssertFailure(_, equalTo:)

    func testAssertFailureEqualTo() {
        // Given
        let result: Result<NonEquatableValue, EquatableError> = .failure(.someError)
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertFailure(result, equalTo: .someError, reporter: mock) {
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAssertFailureEqualToNoClosure() {
        // Given
        let result: Result<NonEquatableValue, EquatableError> = .failure(.someError)
        let mock = FailMock()

        // When
        XCTAssertFailure(result, equalTo: .someError, reporter: mock)

        // Then
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAssertFailureEqualToWithUnequalValue() {
        // Given
        let result: Result<NonEquatableValue, EquatableError> = .failure(.someOtherError)
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertFailure(result, equalTo: .someError, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(
            mock.message,
            #"XCTAssertFailure - ("Some Other Error") is not equal to ("Some Error") - custom message"#
        )
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertFailureEqualToWithNilResult() {
        // Given
        let result: Result<NonEquatableValue, EquatableError>? = nil
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertFailure(result, equalTo: .someError, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, "XCTAssertFailure - Result is nil - custom message")
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testThrowingAssertFailureEqualTo() {
        // Given
        let expression: () throws -> Result<NonEquatableValue, EquatableError> = { throw MockError() }
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertFailure(
            try expression(),
            equalTo: .someError,
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
        XCTAssertEqual(mock.message, #"XCTAssertFailure - threw error "Mock Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertFailureEqualToWithThrowingThen() {
        // Given
        let result: Result<NonEquatableValue, EquatableError> = .failure(.someError)
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertFailure(result, equalTo: .someError, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
            throw MockError()
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertFailure - then closure threw error "Mock Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertFailureEqualToWithThrowingCallInAutoclosureInThen() {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        let result: Result<Int, EquatableError> = .failure(.someError)
        var completionCalled = false

        // When
        XCTAssertFailure(result, equalTo: .someError) {
            throwingAutoclosure(try functionThatCanThrow())
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
    }

    // MARK: - AssertFailure(_, is:)

    func testAssertFailureIs() {
        // Given
        let result: Result<Any, Error> = .failure(EquatableError.someError)
        let mock = FailMock()
        var completionCalled = false
        var errorPassedToCompletion: EquatableError?

        // When
        XCTAssertFailure(result, is: EquatableError.self, reporter: mock) { error in
            completionCalled = true
            errorPassedToCompletion = error
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(errorPassedToCompletion, .someError)
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAssertFailureIsNoClosure() {
        // Given
        let result: Result<Any, Error> = .failure(EquatableError.someError)
        let mock = FailMock()

        // When
        XCTAssertFailure(result, is: EquatableError.self, reporter: mock)

        // Then
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAssertFailureIsWithNilResult() {
        // Given
        let result: Result<Any, Error>? = nil
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertFailure(result, is: EquatableError.self, "custom message", reporter: mock, file: "some file", line: 123) { _ in
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, "XCTAssertFailure - Result is nil - custom message")
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertFailureIsWithFailingCast() {
        // Given
        let result: Result<Any, Error> = .failure(EquatableError.someError)
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertFailure(result, is: MockError.self, "custom message", reporter: mock, file: "some file", line: 123) { _ in
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(
            mock.message,
            "XCTAssertFailure - value of type EquatableError is not expected type MockError - custom message"
        )
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testThrowingAssertFailureIs() {
        // Given
        let expression: () throws -> Result<Any, Error> = { throw MockError() }
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertFailure(
            try expression(),
            is: EquatableError.self,
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
        XCTAssertEqual(mock.message, #"XCTAssertFailure - threw error "Mock Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertFailureIsWithThrowingThen() {
        // Given
        let result: Result<Any, Error> = .failure(EquatableError.someError)
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertFailure(result, is: EquatableError.self, "custom message", reporter: mock, file: "some file", line: 123) { _ in
            completionCalled = true
            throw MockError()
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertFailure - then closure threw error "Mock Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertFailureIsWithThrowingCallInAutoclosureInThen() {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        let result: Result<Int, Error> = .failure(EquatableError.someError)
        var completionCalled = false

        // When
        XCTAssertFailure(result, is: EquatableError.self) { _ in
            throwingAutoclosure(try functionThatCanThrow())
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
    }

    // MARK: - AssertFailure(_, is:, equalTo:)

    func testAssertFailureIsEqualTo() {
        // Given
        let result: Result<NonEquatableValue, Error> = .failure(EquatableError.someError)
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertFailure(result, is: EquatableError.self, equalTo: .someError, reporter: mock) {
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testAssertFailureIsEqualToNoClosure() {
        // Given
        let result: Result<NonEquatableValue, Error> = .failure(EquatableError.someError)
        let mock = FailMock()

        // When
        XCTAssertFailure(result, is: EquatableError.self, equalTo: .someError, reporter: mock)

        // Then
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testFailureIsEqualToWithFailingComparison() {
        // Given
        let result: Result<NonEquatableValue, Error> = .failure(EquatableError.someError)
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertFailure(
            result,
            is: EquatableError.self,
            equalTo: .someOtherError,
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
            #"XCTAssertFailure - ("Some Error") is not equal to ("Some Other Error") - custom message"#
        )
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertFailureIsEqualToWithNilResult() {
        // Given
        let result: Result<NonEquatableValue, Error>? = nil
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertFailure(
            result,
            is: EquatableError.self,
            equalTo: .someError,
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
        XCTAssertEqual(mock.message, "XCTAssertFailure - Result is nil - custom message")
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertFailureIsEqualToWithFailingCast() {
        // Given
        let result: Result<NonEquatableValue, Error> = .failure(MockError())
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertFailure(
            result,
            is: EquatableError.self,
            equalTo: .someError,
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
            "XCTAssertFailure - value of type MockError is not expected type EquatableError - custom message"
        )
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testThrowingAssertFailureIsEqualTo() {
        // Given
        let expression: () throws -> Result<NonEquatableValue, Error> = { throw MockError() }
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertFailure(
            try expression(),
            is: EquatableError.self,
            equalTo: .someError,
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
        XCTAssertEqual(mock.message, #"XCTAssertFailure - threw error "Mock Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testAssertFailureIsEqualToWithThrowingThen() {
        // Given
        let result: Result<NonEquatableValue, Error> = .failure(EquatableError.someError)
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssertFailure(
            result,
            is: EquatableError.self,
            equalTo: .someError,
            "custom message",
            reporter: mock,
            file: "some file",
            line: 123,
            then: {
                completionCalled = true
                throw MockError()
            }
        )

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssertFailure - then closure threw error "Mock Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)

    }

    func testAssertFailureIsEqualToWithThrowingCallInAutoclosureInThen() {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        let result: Result<Int, Error> = .failure(EquatableError.someError)
        var completionCalled = false

        // When
        XCTAssertFailure(result, is: EquatableError.self, equalTo: .someError) {
            throwingAutoclosure(try functionThatCanThrow())
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
    }
}
