//  XCTTypeAssertsTests.swift
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

class XCTTypeAssertsTestCase: XCTestCase {

    // MARK: - Assert(_, is:)

    func testTypeAssert() {
        // Given
        let mock = FailMock()
        let anyInt: Any = 5
        var completionCalled = false
        var valuePassedToCompletion: Int?

        // When
        XCTAssert(anyInt, is: Int.self, reporter: mock) { value in
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

    func testTypeAssertNoClosure() {
        // Given
        let mock = FailMock()
        let anyInt: Any = 5

        // When
        XCTAssert(anyInt, is: Int.self, reporter: mock)

        // Then
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testFailingTypeAssert() {
        // Given
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssert(5, is: String.self, "custom message", reporter: mock, file: "some file", line: 123) { _ in
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, "XCTAssert(_, is:) - value of type Int is not expected type String - custom message")
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testFailingTypeAssertOnNil() {
        // Given
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssert(nil, is: Int.self, "custom message", reporter: mock, file: "some file", line: 123) { _ in
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(
            mock.message,
            "XCTAssert(_, is:) - value is nil and cannot be checked for conformance to type Int - custom message"
        )

        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testThrowingTypeAssert() {
        // Given
        let function: () throws -> Any = { throw MockError() }
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssert(try function(), is: String.self, "custom message", reporter: mock, file: "some file", line: 123) { _ in
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssert(_, is:) - threw error "Mock Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testTypeAssertWithThrowingThen() {
        // Given
        let anyString: Any = ""
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssert(anyString, is: String.self, "custom message", reporter: mock, file: "some file", line: 123) { _ in
            completionCalled = true
            throw MockError()
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssert(_, is:) - then closure threw error "Mock Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testTypeAssertWithThrowingCallInAutoclosureInThen() {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        let anyInt: Any = 5
        var completionCalled = false

        // When
        XCTAssert(anyInt, is: Int.self) { _ in
            throwingAutoclosure(try functionThatCanThrow())
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
    }

    // MARK: - Assert(_, is:, equalTo:)

    func testTypeEqualityAssert() {
        // Given
        let mock = FailMock()
        let any: Any = 5
        var completionCalled = false

        // When
        XCTAssert(any, is: Int.self, equalTo: 5, reporter: mock) {
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testTypeEqualityAssertNoClosure() {
        // Given
        let mock = FailMock()
        let any: Any = EquatableClass(value: 5)

        // When
        XCTAssert(any, is: EquatableClass.self, equalTo: EquatableClass(value: 5), reporter: mock)

        // Then
        XCTAssertNil(mock.message)
        XCTAssertNil(mock.file)
        XCTAssertNil(mock.line)
    }

    func testFailingTypeEqualityAssertOnUnequalValue() {
        // Given
        let anyInt: Any = 5
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssert(anyInt, is: Int.self, equalTo: 1, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(mock.message, "XCTAssert(_, is:, equalTo:) - 5 is not equal to 1 - custom message")
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testFailingTypeEqualityAssert() {
        // Given
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssert(5, is: String.self, equalTo: "", "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(
            mock.message,
            "XCTAssert(_, is:, equalTo:) - value of type Int is not expected type String - custom message"
        )

        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testFailingTypeEqualityAssertOnNil() {
        // Given
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssert(nil, is: Int.self, equalTo: 5, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
        }

        // Then
        XCTAssertFalse(completionCalled)
        XCTAssertEqual(
            mock.message,
            "XCTAssert(_, is:, equalTo:) - value is nil and cannot be checked for conformance to type Int - custom message"
        )

        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testThrowingTypeEqualityAssert() {
        // Given
        let function: () throws -> Any = { throw MockError() }
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssert(
            try function(),
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
        XCTAssertEqual(mock.message, "XCTAssert(_, is:, equalTo:) - threw error \"Mock Error\" - custom message")
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testTypeEqualityAssertWithThrowingThen() {
        // Given
        let anyInt: Any = 5
        let mock = FailMock()
        var completionCalled = false

        // When
        XCTAssert(anyInt, is: Int.self, equalTo: 5, "custom message", reporter: mock, file: "some file", line: 123) {
            completionCalled = true
            throw MockError()
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(mock.message, #"XCTAssert(_, is:, equalTo:) - then closure threw error "Mock Error" - custom message"#)
        XCTAssertEqual(mock.file, "some file")
        XCTAssertEqual(mock.line, 123)
    }

    func testTypeEqualtyAssertWithThrowingCallInAutoclosureInThen() {
        // This is a compile time test that ensures that a throwing function can be called within an autoclosure
        // in the then closure of this assert. This simulates calling throwing code inside another assert within
        // the closure.

        // Given
        let anyInt: Any = 5
        var completionCalled = false

        // When
        XCTAssert(anyInt, is: Int.self, equalTo: 5) {
            throwingAutoclosure(try functionThatCanThrow())
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
    }
}
