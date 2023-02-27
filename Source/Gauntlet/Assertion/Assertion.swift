//
//  Assertion.swift
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

/// An assertion that has been made on a value.
///
/// This is the main type in `Gauntlet`, and the type on which you will make assertions. An `Asertion` instance
/// can be created by calling the `Assert(that: ...)` instance function on `XCTestCase`.
///
/// `Assertion`s of a specific type are extended to provide assertion functions relevant to that type. These functions return
/// a new assertion allowing multiple assertions to be chained.
///
/// ```
/// let boolValue: Bool = ...
///
/// Assert(that: boolValue).isTrue()
///
/// let result: Result<String, Error> = ...
/// Assert(that: result)
///     .isSuccess()
///     .isEqualTo("Expected String")
///
/// let failureResult: Result<String, Error> = ...
/// Assert(that: failureResult)
///     .isFailure()
/// ```
/// 
/// `Assertion` can be extended further to easily create new assertion functions that suit your needs or types.
public final class Assertion<Value> {

    /// The result of the assertion.
    public let result: AssertionResult<Value>

    /// The name of the assertion. This should describe what the assertion is validating.
    public let name: String

    /// The path to the source file in which the assertion exists.
    public let filePath: String

    /// The line number of the assertion. This can be captured at the call site with the `#line` default parameter.
    public let lineNumber: Int

    /// The `FailureRecorder` instance that failures should be recorded to.
    let recorder: FailureRecorder

    /// Indicates whether this assertion is the root assertion or if it spawned off of the root.
    let isRoot: Bool

    /// Indicates whether or not evaluate has been called, and a new assertion returned, or a failure result has been recorded..
    private var hasEvaluatedOrRecordedFailure: Bool

    /// Creates an ``Assertion`` instance from the specified parameters.
    ///
    /// This initializer will not record any failure values for the `result` automatically. When creating an instance where the failure result
    /// has not already been recorded manually call `recordFailure()`.
    ///
    /// - Parameters:
    ///   - result: The result of the assertion.
    ///   - name: The name of the assertion. This should describe what the assertion is validating.
    ///   - filePath: The path to the source file in which the assertion exists.
    ///   - lineNumber: The line number of the assertion. This can be captured at the call site with the `#line` default parameter.
    ///   - recorder: The `FailureRecorder` instance that failures should be recorded to.
    ///   - isRoot: Indicates whether this assertion is the root assertion or if it spawned off of the root.
    init(
        result: AssertionResult<Value>,
        name: String,
        filePath: String,
        lineNumber: Int,
        recorder: FailureRecorder,
        isRoot: Bool)
    {
        self.result = result
        self.name = name
        self.filePath = filePath
        self.lineNumber = lineNumber
        self.recorder = recorder
        self.isRoot = isRoot
        self.hasEvaluatedOrRecordedFailure = false
    }

    deinit {
        // If this is a root assertion and it hasn't yet evaluated something must have gone wrong, so record a failure.
        // This could happen if the user calls Assert(that: ...) but never performs any additional assertions on it.
        guard isRoot, !hasEvaluatedOrRecordedFailure else { return }

        // Create a new assertion with an appropriate failure description and report it.
        let assertion: Assertion<Value> = with(newResult: .failure(message: "This assertion was never evaluated."))
        assertion.recordFailure()
    }

    // MARK: - Evaluation

    /// Creates a new `Assertion` by evaluating the provided closure.
    ///
    /// The closure is only evaluated if the receiver's result is a `success`. In the case of a `failure` the returned assertion will contain
    /// the same data as the receiver.
    ///
    /// - Parameters:
    ///   - name: The name of the assertion being evaluated. This will be used when displaying failure messages in Xcode or in logs. Example: `isEqual`
    ///   - lineNumber: The line number of the assertion being evaluated. This can be captured from the callsite with the `#line` default parameter.
    ///   - evaluator: A function that is provided a `Value` insance and yields an ``AssertionResult``.
    public func evaluate<NewValue>(
        name newName: String,
        lineNumber newLineNumber: Int,
        evaluator: (Value) throws -> AssertionResult<NewValue>)
        -> Assertion<NewValue>
    {
        hasEvaluatedOrRecordedFailure = true

        switch result {
        case let .success(value):
            let newResult: AssertionResult<NewValue>

            do {
                newResult = try evaluator(value)
            } catch {
                newResult = .failure(thrownError: error)
            }

            let newAssertion = with(newResult: newResult, newName: newName, newLineNumber: newLineNumber)
            newAssertion.recordFailure()

            return newAssertion

        case let .failure(reason):
            // If the assertion was already a failure just return a copy with the new type and no other changes.
            return with(newResult: .failure(reason))
        }
    }

    /// Creates a new `Assertion` by evaluating the provided async closure.
    ///
    /// The closure is only evaluated if the receiver's result is a `success`. In the case of a `failure` the returned assertion will contain
    /// the same data as the receiver.
    ///
    /// - Parameters:
    ///   - name: The name of the assertion being evaluated. This will be used when displaying failure messages in Xcode or in logs. Example: `isEqual`
    ///   - lineNumber: The line number of the assertion being evaluated. This can be captured from the callsite with the `#line` default parameter.
    ///   - evaluator: A function that is provided a `Value` insance and yields an ``AssertionResult``.
    public func asyncEvaluate<NewValue>(
        name newName: String,
        lineNumber newLineNumber: Int,
        evaluator: (Value) async throws -> AssertionResult<NewValue>)
        async -> Assertion<NewValue>
    {
        hasEvaluatedOrRecordedFailure = true

        switch result {
        case let .success(value):
            let newResult: AssertionResult<NewValue>

            do {
                newResult = try await evaluator(value)
            } catch {
                newResult = .failure(thrownError: error)
            }

            let newAssertion = with(newResult: newResult, newName: newName, newLineNumber: newLineNumber)
            newAssertion.recordFailure()

            return newAssertion

        case let .failure(reason):
            // If the assertion was already a failure just return a copy with the new type and no other changes.
            return with(newResult: .failure(reason))
        }
    }

    /// If the result is a `failure` this will record the failure to the recorder.
    func recordFailure() {
        // Only report failures
        guard case let .failure(reason) = result else { return }

        hasEvaluatedOrRecordedFailure = true
        recorder.record(name: name, reason: reason, filePath: filePath, lineNumber: lineNumber)
    }

    // MARK: - New Assertsions

    /// Creates a copy of the receiver with the provided values overridden.
    ///
    /// - Parameters:
    ///   - newResult: The result for the new instance.
    ///   - newName: The name to use for the new instance. The default value is the name of the receiver.
    ///   - newLineNumber: The line number to use for the new instance. The default value is the lineNumber of the receiver.
    func with<NewValue>(
        newResult: AssertionResult<NewValue>,
        newName: String? = nil,
        newLineNumber: Int? = nil)
        -> Assertion<NewValue>
    {
        Assertion<NewValue>(
            result: newResult,
            name: newName ?? name,
            filePath: filePath,
            lineNumber: newLineNumber ?? lineNumber,
            recorder: recorder,
            isRoot: false
        )
    }
}

// MARK: - Initializers

extension Assertion {
    convenience init(
        value: Value,
        name: String,
        filePath: String,
        lineNumber: Int,
        recorder: FailureRecorder,
        isRoot: Bool)
    {
        self.init(result: .success(value), name: name, filePath: filePath, lineNumber: lineNumber, recorder: recorder, isRoot: isRoot)
    }

    convenience init(
        expression: () async -> Value,
        name: String,
        filePath: String,
        lineNumber: Int,
        recorder: FailureRecorder,
        isRoot: Bool) async
    {
        let value = await expression()
        self.init(result: .success(value), name: name, filePath: filePath, lineNumber: lineNumber, recorder: recorder, isRoot: isRoot)
    }
}
