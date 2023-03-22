//
//  XCTestCaseExtensionsLiveAsserts.swift
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

/// Contains assertions that call the XCTestCase.Assert APIs to validate that they produce failures correctly, and do not generate failures on success.
class XCTestCaseExtensionsLiveTestCase: XCTestCase {

    // MARK: - Value Assert

    func testPassingLiveValueAssert() {
        // Given, When, Then
        Assert(that: "some value").pass()
    }

    func testFailingLiveValueAssert() {
        // Given
        XCTExpectFailure("This assertion should generate a failure")

        // When, Then
        Assert(that: "some value").fail()
    }

    // MARK: - Async Value Assert

    func testPassingLiveAsyncValueAssert() async {
        // Given
        let model = AsyncModel()

        // When, Then
        await Assert(async: await model.getValue()).pass()
    }

    func testFailingLiveAsyncValueAssert() async {
        // Given
        let model = AsyncModel()
        XCTExpectFailure("This assertion should generate a failure")

        // When, Then
        await Assert(async: await model.getValue()).fail()
    }

    // MARK: - Throwable Assert

    func testPassingLiveThrowableAssert() {
        // Given
        func throwable() throws -> String { "" }

        // When, Then
        Assert(throwingExpression: try throwable()).pass()
    }

    func testFailingLiveThrowableAssert() {
        // Given
        func throwable() throws -> String { "" }
        XCTExpectFailure("This assertion should generate a failure")

        // When, Then
        Assert(throwingExpression: try throwable()).fail()
    }

    // MARK: - Async Throwable Assert

    func testPassingLiveAsyncThrowableAssert() async {
        // Given
        let model = ThrowingAsyncModel(result: .success(""))

        // When, Then
        await Assert(asyncThrowingExpression: try await model.getValue()).pass()
    }

    func testFailingLiveAsyncThrowableAssert() async {
        // Given
        let model = ThrowingAsyncModel(result: .success(""))
        XCTExpectFailure("This assertion should generate a failure")

        // When, Then
        await Assert(asyncThrowingExpression: try await model.getValue()).fail()
    }
}
