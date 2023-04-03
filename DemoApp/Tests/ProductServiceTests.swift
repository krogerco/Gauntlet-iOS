//
//  ProductServiceTests.swift
//  DemoApp
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

@testable import DemoApp
import Foundation
import Gauntlet
import XCTest

class ProductServiceTestCase: XCTestCase {
    private let queue = DispatchQueue(label: "com.krogerco.DemoAppTests.ProductService")

    // Asserts that the provider will return a success when getting all products.
    func testGetAllProducts() {
        // Given
        let service = ProductService()
        var result: Result<[Product], Error>?
        let expectation = self.expectation(description: "The getAllProducts completion will be called")

        // When
        service.getAllProducts(queue: queue) { [self] receivedResult in
            result = receivedResult
            Assert(that: queue).isTheCurrentQueue()
            expectation.fulfill()
        }

        // Then
        waitForExpectations(timeout: 1)

        Assert(that: result)
            .isNotNil()
            .isSuccess()
            .hasCount(7)
            .then { products in
                Assert(that: products[0]).isEqualTo(Product(name: "Allspice", id: "1234"))
            }
    }

    // Asserts that the provider will return a success result when a product is requested for a known id.
    func testGetProductSuccess() {
        // Given
        let service = ProductService()
        var result: Result<Product, Error>?
        let expectation = self.expectation(description: "The getAllProducts completion will be called")

        // When
        service.getProduct(id: "5678", queue: queue) { [self] receivedResult in
            result = receivedResult
            Assert(that: queue).isTheCurrentQueue()
            expectation.fulfill()
        }

        // Then
        waitForExpectations(timeout: 1)
        let expectedProduct = Product(name: "Eggs", id: "5678")

        Assert(that: result)
            .isNotNil()
            .isSuccess()
            .isEqualTo(expectedProduct)
    }

    // Asserts that the provider will return a failure result when a product is requested for an id it doesn't know about.
    func testGetProductFailure() {
        // Given
        let service = ProductService()
        var result: Result<Product, Error>?
        let expectation = self.expectation(description: "The getAllProducts completion will be called")

        // When
        service.getProduct(id: "invalid-id", queue: queue) { [self] receivedResult in
            result = receivedResult
            Assert(that: queue).isTheCurrentQueue()
            expectation.fulfill()
        }

        // Then
        waitForExpectations(timeout: 1)

        Assert(that: result)
            .isNotNil()
            .isFailure()
            .isOfType(ProductError.self)
            .isEqualTo(.noProductForID("invalid-id"))
    }
}
