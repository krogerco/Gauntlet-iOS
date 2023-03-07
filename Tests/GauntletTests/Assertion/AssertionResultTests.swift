//
//  AssertionResultTests.swift
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
import Gauntlet
import XCTest

class AssertionResultTestCase: XCTestCase {
    func testMessageFactoryFunction() {
        // Given
        let message = "some message"

        // When
        let result: AssertionResult<Void> = .fail(message: message)

        // Then
        if case let .fail(reason) = result {
            XCTAssertEqual(reason, .message(message))
        } else {
            XCTFail("Result is a pass")
        }
    }

    func testThrownErrorFactoryFunction() {
        // Given
        let thrownError = MockError.someError

        // When
        let result: AssertionResult<Void> = .fail(thrownError: thrownError)

        // Then
        if case let .fail(reason) = result {
            XCTAssertEqual(reason, .thrownError(thrownError))
        } else {
            XCTFail("Result is a pass")
        }
    }
}
