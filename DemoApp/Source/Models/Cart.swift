//
//  File.swift
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

import Foundation

actor Cart {
    var items: [Item]

    var count: Int {
        get async {
            var count = 0

            for item in items {
                count += await item.quantity
            }

            return count
        }
    }

    init(items: [Item]) {
        self.items = items
    }

    func add(_ product: Product, quantity: Int = 1) async {
        // If we already have the product, increase the quantity
        if let existingItem = items.first(where: { $0.product == product }) {
            await existingItem.setQuantity(existingItem.quantity + quantity)
        } else {
            let item = Item(product: product, quantity: quantity)
            items.append(item)
        }
    }

    func remove(product: Product) {
        items.removeAll { item in
            item.product == product
        }
    }
}

extension Cart {
    actor Item {
        let product: Product
        var quantity: Int

        init(product: Product, quantity: Int) {
            self.product = product
            self.quantity = quantity
        }

        func setQuantity(_ newQuantity: Int) {
            quantity = newQuantity
        }
    }
}
