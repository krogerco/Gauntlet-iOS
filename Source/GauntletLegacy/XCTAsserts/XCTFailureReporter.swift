//  XCTFailureReporter.swift
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
import XCTest

/// A type that can report a test failure.
public protocol FailureReporter {
    /// Reports a test failure.
    ///
    /// - Parameters:
    ///   - description: A description of the failure.
    ///   - file:        The path of the file that generated the failure.
    ///   - line:        The line that generated the failure.
    func reportFailure(description: String, file: StaticString, line: UInt)
}

// MARK: -

/// A `FailureReporter` that reports the error using `XCTFail`.
public struct XCTestReporter: FailureReporter {

    /// An instance of `XCTestReporter` used as the default parameter for all asserts.
    public static let `default` = XCTestReporter()

    public func reportFailure(description: String, file: StaticString, line: UInt) {
        XCTFail(description, file: file, line: line)
    }
}
