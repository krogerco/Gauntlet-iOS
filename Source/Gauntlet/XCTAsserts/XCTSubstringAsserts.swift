//  XCTSubstringAsserts.swift
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

import XCTest

/// Asserts that the string is not `nil` and contains the provided substring.
///
/// This function provides the ability to assert that a string contains a given substring.
/// This can be easily done with the XCTest provided functions by calling `XCTAssert(string.contains(substring))`, though the failure case of this approach leaves a lot to be desired.
/// If this test fails you will simply see a red failure with the unhelpful message `"XCTAssertTrue failed"`.
/// When you encounter one of these failures you need to re-run the test and set a breakpoint, or just add logging code before rerunning the test, just to understand why the test actually failed.
///
///     XCTAssert("Hello Worl!", contains: "World") {
///         // Optionally perform additional conditional tests.
///     }
///
/// `XCTAssert(_, contains:)` provides a much more helpful message when it fails: `XCTAssert(_, contains:) failed - "World" not found in "Hello Worl!"`.
/// When you see the test fail you'll get a much more descriptive failure message and will have a much easier time debugging the failing test as you fix the issue and re-reun the tests to verify the fix worked.
///
/// - Parameters:
///   - expression: An expression of type `String?`.
///   - substring:  The substring expected to be in `string`.
///   - message:    An optional description of the failure.
///   - reporter:   The `FailureReporter` to report a failure to. The default reporter will report the failure with XCTest.
///   - file:       The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - line:       The line number on which failure occurred. Defaults to the line number on which this function was called.
///   - then:       A closure to be called if the substring is found in the string. This can be used to perform any additional tests.
public func XCTAssert(
    _ expression: @autoclosure () throws -> String?,
    contains substring: String,
    _ message: @autoclosure () -> String = "",
    reporter: FailureReporter = XCTestReporter.default,
    file: StaticString = #filePath,
    line: UInt = #line,
    then: () throws -> Void = { })
{
    let name = "XCTAssert(_, contains:)"
    let result = catchErrors(
        in: expression,
        message: message,
        name: name,
        reporter: reporter,
        file: file,
        line: line
    )

    guard case let .success(optionalString) = result else { return }
    guard let string = optionalString else {
        reporter.reportFailure(
            description: "\(name) - nil string does not contain \"\(substring)\"\(suffix(from: message))",
            file: file,
            line: line
        )

        return
    }

    guard string.contains(substring) else {
        reporter.reportFailure(
            description: "\(name) - \"\(substring)\" not found in \"\(string)\"\(suffix(from: message))",
            file: file,
            line: line
        )

        return
    }

    failIfThrows(try then(), message: message, name: name, reporter: reporter, file: file, line: line)
}
