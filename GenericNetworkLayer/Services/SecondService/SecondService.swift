//
//  SecondService.swift
//  GenericNetworkLayer
//
//  Created by Yusuf Ziya YILDIRIM on 7.09.2023.
//

import Foundation

class SecondService: SecondServiceProtocol {
    private let networkManager: NetworkManager
    
    init() {
        self.networkManager = URLSessionNetworkManager.shared
    }
    
    func getAllProducts() async throws -> APIResponse<[Product]> {
        let endpoint = SecondGroupEndpoints.getAllProducts
        return try await networkManager.sendRequest(endpoint, responseType: APIResponse<[Product]>.self)
    }
    
    func getProduct(id: Int) async throws -> APIResponse<Product> {
        let endpoint = SecondGroupEndpoints.getProduct(id: id)
        return try await networkManager.sendRequest(endpoint, responseType: APIResponse<Product>.self)
    }

}
