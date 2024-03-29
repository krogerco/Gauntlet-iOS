//
//  HelperAssertions.swift
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
@testable import Gauntlet
import XCTest

extension Assertion {
    /// An assertion that will always succeed. This is used for testing live calls to the XCTestCase.Assert API without relying on other Gauntlet assertions.
    @discardableResult
    func pass(line: Int = #line) -> Assertion<Void> {
        evaluate(name: "succeed", lineNumber: line) { _ in
            .pass
        }
    }

    /// An assertion that will always succeed. This is used for testing live calls to the XCTestCase.Assert API without relying on other Gauntlet assertions.
    @discardableResult
    func fail(line: Int = #line) -> Assertion<Void> {
        evaluate(name: "fail", lineNumber: line) { _ in
            .fail(message: "Assert Failed")
        }
    }
}

// MARK: -

class HelperAssertionsTestCase: XCTestCase {
    func testSucceed() {
        // Given
        let expectedLine = 123

        // When
        let assertion = TestAnAssertion(on: "").pass(line: expectedLine)

        // Then
        XCTAssertEqual(assertion.lineNumber, expectedLine)

        if case .fail = assertion.result {
            XCTFail("Encountered a failure result. Should be success with a Void value.")
        }
    }

    func testFail() {
        // Given
        let expectedLine = 123

        // When
        let assertion = TestAnAssertion(on: "").fail(line: expectedLine)

        // Then
        XCTAssertEqual(assertion.lineNumber, expectedLine)

        if case .pass = assertion.result {
            XCTFail("Encountered a success result. Should be a failure.")
        }
    }
}
