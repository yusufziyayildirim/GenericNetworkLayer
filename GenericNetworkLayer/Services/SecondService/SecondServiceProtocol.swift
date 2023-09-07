//
//  SecondServiceProtocol.swift
//  GenericNetworkLayer
//
//  Created by Yusuf Ziya YILDIRIM on 7.09.2023.
//

import Foundation

protocol SecondServiceProtocol {
    func getAllProducts() async throws -> APIResponse<[Product]>
    func getProduct(id: Int) async throws -> APIResponse<Product>
}
