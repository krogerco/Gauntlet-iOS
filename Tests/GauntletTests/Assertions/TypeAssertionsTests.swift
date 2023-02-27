//
//  TypeAssertionsTests.swift
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

class TypeAssertionsTestCase: XCTestCase {
    func testIsTypeSuccess() {
        // Given
        let expectedValue = "some value on the concrete type"
        let protocolValue: SomeProtocol = SomeConformingType(value: expectedValue)
        let line = 345

        // When
        let assertion = TestAnAssertion(on: protocolValue).isType(SomeConformingType.self, line: line)

        // Then
        Assert(that: assertion)
            .isSuccess(expectedName: "isType", expectedLine: line)
            .isEqualTo(SomeConformingType(value: expectedValue))
    }

    func testIsTypeFailure() {
        // Given
        let value = SomeNonConformingType()
        let line = 543

        // When
        let assertion = TestAnAssertion(on: value).isType(SomeProtocol.self, line: line)

        // Then
        let expectedMessage = #"Value of type SomeNonConformingType does not conform to expected type SomeProtocol"#

        Assert(that: assertion)
            .isFailure(expectedName: "isType", expectedLine: line)
            .isEqualTo(.message(expectedMessage))
    }
}

// MARK: - Helper Types

private protocol SomeProtocol {}
private struct SomeConformingType: SomeProtocol, Equatable {
    let value: String
}
private struct SomeNonConformingType {}
