//
//  ThrowingAssertionsTests.swift
//
//  MIT License
//
//  Copyright (c) [2023] The Kroger Co. All rights reserved.
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
import Gauntlet
import XCTest

class ThrowingAssertionsTestCase: XCTestCase {
    func testDoesNotThrow() {
        // Given
        let expression = ThrowableExpression(expression: { "some value" })
        let expectedLine = 123

        // When
        let assertion = TestAnAssertion(on: expression).doesNotThrow(line: expectedLine)

        // Then
        Assert(that: assertion)
            .isSuccess(expectedName: "doesNotThrow", expectedLine: expectedLine)
            .isEqualTo("some value")
    }

    func testDoesNotThrowWhenErrorIsThrown() {
        // Given
        let expression = ThrowableExpression(expression: { throw MockError.someError })
        let expectedLine = 321

        // When
        let assertion = TestAnAssertion(on: expression).doesNotThrow(line: expectedLine)

        // Then
        Assert(that: assertion)
            .isFailure(expectedName: "doesNotThrow", expectedLine: expectedLine)
            .isEqualTo(.thrownError(MockError.someError))
    }

    func testThrowsError() {
        // Given
        let expression = ThrowableExpression(expression: { throw MockError.someError })
        let expectedLine = 321

        // When
        let assertion = TestAnAssertion(on: expression).throwsError(line: expectedLine)

        // Then
        Assert(that: assertion)
            .isSuccess(expectedName: "throwsError", expectedLine: expectedLine)
            .isType(MockError.self)
            .isEqualTo(.someError)
    }

    func testThrowsErrorWhenNoErrorIsThrown() {
        // Given
        let expression = ThrowableExpression(expression: { "some value" })
        let expectedLine = 123

        // When
        let assertion = TestAnAssertion(on: expression).throwsError(line: expectedLine)

        // Then
        Assert(that: assertion)
            .isFailure(expectedName: "throwsError", expectedLine: expectedLine)
            .isEqualTo(.message(#"Expression did not throw. Returned "some value""#))
    }

    // MARK: - Async

    func testAsyncDoesNotThrow() async {
        // Given
        let model = ThrowingAsyncModel(result: .success("some value"))
        let expectedLine = 321
        let expression = AsyncThrowableExpression(expression: { try await model.getValue() })

        // When
        let assertion = await TestAnAssertion(on: expression).doesNotThrow(line: expectedLine)

        // Then
        Assert(that: assertion)
            .isSuccess(expectedName: "doesNotThrow", expectedLine: expectedLine)
            .isEqualTo("some value")

    }

    func testAsyncDoesNotThrowWhenErrorIsThrown() async {
        // Given
        let model = ThrowingAsyncModel(result: .failure(.someError))
        let expectedLine = 321
        let expression = AsyncThrowableExpression(expression: { try await model.getValue() })

        // When
        let assertion = await TestAnAssertion(on: expression).doesNotThrow(line: expectedLine)

        // Then
        Assert(that: assertion)
            .isFailure(expectedName: "doesNotThrow", expectedLine: expectedLine)
            .isEqualTo(.thrownError(MockError.someError))
    }

    func testAsyncThrowsError() async {
        // Given
        let model = ThrowingAsyncModel(result: .failure(.someError))
        let expectedLine = 321
        let expression = AsyncThrowableExpression(expression: { try await model.getValue() })

        // When
        let assertion = await TestAnAssertion(on: expression).throwsError(line: expectedLine)

        // Then
        Assert(that: assertion)
            .isSuccess(expectedName: "throwsError", expectedLine: expectedLine)
            .isType(MockError.self)
            .isEqualTo(.someError)
    }

    func testAsyncThrowsErrorWhenNoErrorIsThrown() async {
        // Given
        let model = ThrowingAsyncModel(result: .success("some value"))
        let expectedLine = 321
        let expression = AsyncThrowableExpression(expression: { try await model.getValue() })

        // When
        let assertion = await TestAnAssertion(on: expression).throwsError(line: expectedLine)

        // Then
        Assert(that: assertion)
            .isFailure(expectedName: "throwsError", expectedLine: expectedLine)
            .isEqualTo(.message(#"Expression did not throw. Returned "some value""#))
    }
}
