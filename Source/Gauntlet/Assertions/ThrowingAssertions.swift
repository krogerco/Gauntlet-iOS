//
//  ThrowingAssertions.swift
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

// MARK: - Throwing

extension Assertion where Value: ThrowableExpressionProtocol {
    /// Asserts that the expression does not throw an error, providing the resulting value.
    ///
    /// - Returns: An ``Assertion`` containing the result of the expression.
    @discardableResult
    public func doesNotThrow(line: Int = #line) -> Assertion<Value.Output> {
        evaluate(name: "doesNotThrow", lineNumber: line) { expression in
            let output = try expression.evaluate()
            return .success(output)
        }
    }

    /// Asserts that the expression does throw an error, providing the thrown error.
    ///
    /// - Returns: An ``Assertion`` containing the error thrown by the expression.
    @discardableResult
    public func throwsError(line: Int = #line) -> Assertion<Error> {
        evaluate(name: "throwsError", lineNumber: line) { expression in
            do {
                // If we get a value that's bad
                let output = try expression.evaluate()
                return .failure(message: "Expression did not throw. Returned \"\(output)\"")
            } catch {
                return .success(error)
            }
        }
    }
}

// MARK: - Async Throwing

extension Assertion where Value: AsyncThrowableExpressionProtocol {

    /// Asserts that the async expression does not throw an error, providing the resulting value.
    ///
    /// - Returns: An ``Assertion`` containing the result of the expression.
    @discardableResult
    public func doesNotThrow(line: Int = #line) async -> Assertion<Value.Output> {
        await asyncEvaluate(name: "doesNotThrow", lineNumber: line) { expression in
            let output = try await expression.evaluate()
            return .success(output)
        }
    }

    /// Asserts that the async expression does throw an error, providing the thrown error.
    ///
    /// - Returns: An ``Assertion`` containing the error thrown by the expression.
    @discardableResult
    public func throwsError(line: Int = #line) async -> Assertion<Error> {
        await asyncEvaluate(name: "throwsError", lineNumber: line) { expression in
            do {
                // If we get a value that's bad
                let output = try await expression.evaluate()
                return .failure(message: "Expression did not throw. Returned \"\(output)\"")
            } catch {
                return .success(error)
            }
        }
    }
}

// MARK: - Supporting Protocols

/// A type that can throw when being evaluated.
///
/// This type is used to create ``Assertion`` extensions on throwable expressions.
public protocol ThrowableExpressionProtocol {
    associatedtype Output

    /// Evaluates the expression, returning its output.
    func evaluate() throws -> Output
}

/// A type that can throw when evaluating it asynchronously.
///
/// This type is used to create ``Assertion`` extensions on throwable async expressions.
public protocol AsyncThrowableExpressionProtocol {
    associatedtype Output: Sendable

    /// Evaluates the expression, returning its output.
    func evaluate() async throws -> Output
}

// MARK: - Supporting Concrete Types

/// Encapsulates an expression that can throw when being evaluated.
///
/// This is is used to create `Assertion`s on expression that can throw errors.
public struct ThrowableExpression<Output>: ThrowableExpressionProtocol {
    let expression: () throws -> Output

    /// Creates a `ThrowableExpression` instance with the specified expression.
    ///
    /// - Parameter expression: The expression to be evaluated.
    public init(expression: @escaping () throws -> Output) {
        self.expression = expression
    }

    /// Evaluates the expression, returning its output.
    public func evaluate() throws -> Output {
        try expression()
    }
}

/// Encapsulates an async expression that can throw when being evaluated.
///
/// This is is used to create `Assertion`s on async expressions that can throw errors.
public struct AsyncThrowableExpression<Output>: AsyncThrowableExpressionProtocol {
    let expression: () async throws -> Output

    /// Creates an `AsyncThrowableExpression` instance with the specified expression.
    ///
    /// - Parameter expression: The expression to be evaluated.
    public init(expression: @escaping () async throws -> Output) {
        self.expression = expression
    }

    /// Evaluates the expression, returning its output.
    public func evaluate() async throws -> Output {
        try await expression()
    }
}
