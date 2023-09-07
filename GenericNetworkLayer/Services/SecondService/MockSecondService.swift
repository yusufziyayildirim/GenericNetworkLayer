//
//  MockSecondService.swift
//  GenericNetworkLayer
//
//  Created by Yusuf Ziya YILDIRIM on 7.09.2023.
//

import Foundation

class MockSecondService: SecondServiceProtocol {
    private let mockProducts: [Product] = [
        Product(id: 1, name: "Ürün 1", price: 19.99, description: "Ürün 1 açıklaması"),
        Product(id: 2, name: "Ürün 2", price: 29.99, description: "Ürün 2 açıklaması"),
        Product(id: 3, name: "Ürün 3", price: 39.99, description: "Ürün 3 açıklaması")
    ]

    func getAllProducts() async throws -> APIResponse<[Product]> {
        return APIResponse(status: "success", message: "Tüm ürünler", data: mockProducts)
    }

    func getProduct(id: Int) async throws -> APIResponse<Product> {
        let product = mockProducts.first
        return APIResponse(status: "success", message: "Ürün bulundu", data: product!)
    }
}
