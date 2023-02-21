//
//  RecordedFailure.swift
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

/// Represents the data recorded to an `IssueRecorder`.
///
/// This is intended to be used when testing complex assertions that require testing via issue recording instead of on the returned assertion itself.
public struct RecordedFailure {
    /// The name of the ``Assertion`` that failed.
    public let name: String

    /// The reason for the failure
    public let reason: FailureReason

    /// The file path captured from the call site.
    public let filePath: String

    /// The line number captured from the call site.
    public let lineNumber: Int

    /// Creates a `RecordedFailure` instance from the specified parameters.
    ///
    /// - Parameters:
    ///   - name: The name of the ``Assertion`` that failed.
    ///   - reason: The reason for the failure
    ///   - filePath: The file path captured from the call site.
    ///   - lineNumber: The line number captured from the call site.
    public init(name: String, reason: FailureReason, filePath: String, lineNumber: Int) {
        self.name = name
        self.reason = reason
        self.filePath = filePath
        self.lineNumber = lineNumber
    }
}

// MARK: - Equatable

extension RecordedFailure: Equatable {}
