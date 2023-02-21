//
//  FailureReason.swift
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

/// The reason an  ``Assertion`` failed.
public enum FailureReason: Error {
    /// A message describing why the assertion failed.
    case message(String)

    /// The assertion failed because an error was thrown.
    case thrownError(Error)
}

// MARK: -

extension FailureReason: Equatable {
    public static func == (lhs: FailureReason, rhs: FailureReason) -> Bool {
        switch (lhs, rhs) {
        case let (.message(lhs), .message(rhs)):
            return lhs == rhs

        case let (.thrownError(lhs as NSError), .thrownError(rhs as NSError)):
            return lhs == rhs

        default:
            return false
        }
    }
}

#warning("Need to add Assertions to FailureReason to allow easily testing thrown error cases")
