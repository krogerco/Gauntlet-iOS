//
//  CollectionOperators.swift
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

// MARK: - Empty

extension Assertion where Value: Collection {

    /// Asserts that the collection has no items in it.
    ///
    /// - Returns: An ``Assertion`` with a `Void` value.
    @discardableResult
    public func isEmpty(line: Int = #line) -> Assertion<Void> {
        evaluate(name: "isEmpty", lineNumber: line) { collection in
            guard !collection.isEmpty else { return .pass }

            // Format the message appropriately based on the count
            let messageSuffix = collection.count == 1 ? "item" : "items"
            return .fail(message: "The collection has \(collection.count) \(messageSuffix)")
        }
    }

    /// Asserts that the collection has items in it.
    ///
    /// - Returns: An ``Assertion`` with the collection.
    @discardableResult
    public func isNotEmpty(line: Int = #line) -> Assertion<Value> {
        evaluate(name: "isNotEmpty", lineNumber: line) { collection in
            guard collection.isEmpty else { return .pass(collection) }

            return .fail(message: "The collection is empty")
        }
    }
}

// MARK: - Count

extension Assertion where Value: Collection {
    /// Asserts tha the collection has the expected number of items, providing the colelction.
    ///
    /// - Parameters:
    ///   - expectedCount: The number of items expected to be in the collection.
    ///
    /// - Returns: An ``Assertion`` containing the collection.
    @discardableResult
    public func hasCount(_ expectedCount: Int, line: Int = #line) -> Assertion<Value> {
        evaluate(name: "hasCount", lineNumber: line) { collection in
            if collection.count == expectedCount { return .pass(collection) }

            return .fail(message: "Count of \(collection.count) is not equal to the expected count \(expectedCount)")
        }
    }
}

// MARK: - Contains

extension Assertion where Value: Collection, Value.Element: Equatable {

    /// Asserts that the collection contains the expected item, providing the collection.
    ///
    /// - Parameters:
    ///   - expectedValue: The value that's expected to be in the collection.
    ///
    /// - Returns: An ``Assertion`` containing the collection.
    @discardableResult
    public func contains<T>(_ expectedValue: T, line: Int = #line) -> Assertion<Value> where T == Value.Element {
        evaluate(name: "contains", lineNumber: line) { collection in
            if collection.contains(expectedValue) { return .pass(collection) }

            return .fail(message: #"The collection does not contain "\#(expectedValue)""#)
        }
    }
}
