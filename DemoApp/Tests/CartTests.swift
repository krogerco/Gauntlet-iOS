//
//  CartTests.swift
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

class CartTestCase: XCTestCase {
    func testAddProducts() async {
        // Given
        let cart = Cart(items: [])
        let firstProduct = Product(name: "first", id: "1111")
        let secondProduct = Product(name: "second", id: "2222")

        // When
        await cart.add(firstProduct)
        await cart.add(secondProduct, quantity: 2)

        // Then
        Assert(that: await cart.count).isEqualTo(3)
        await Assert(that: await cart.items)
            .hasCount(2)
            .asyncThen { items in
                let firstItem = items[0]
                let secondItem = items[1]

                Assert(that: await firstItem.product).isEqualTo(firstProduct)
                Assert(that: await firstItem.quantity).isEqualTo(1)

                Assert(that: await secondItem.product).isEqualTo(secondProduct)
                Assert(that: await secondItem.quantity).isEqualTo(2)
            }
    }

    func testReaddingProduct() async {
        // Given
        let cart = Cart(items: [])
        let product = Product(name: "Halibut", id: "12345")

        // When
        await cart.add(product)
        await cart.add(product, quantity: 4)

        // Then
        Assert(that: await cart.count).isEqualTo(5)
        Assert(that: await cart.items).hasCount(1)
    }

    func testRemoveProduct() async {
        // Given
        let productToRemove = Product(name: "Some Product", id: "12345")
        let cart = Cart(
            items: [
                Cart.Item(product: productToRemove, quantity: 5),
                Cart.Item(product: Product(name: "Other Product", id: "54321"), quantity: 1)
            ]
        )

        // When
        await cart.remove(product: productToRemove)

        // Then
        Assert(that: await cart.count).isEqualTo(1)
        Assert(that: await cart.items).hasCount(1)
    }
}
