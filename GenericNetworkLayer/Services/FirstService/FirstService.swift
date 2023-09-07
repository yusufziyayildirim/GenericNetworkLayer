//
//  FirstService.swift
//  GenericNetworkLayer
//
//  Created by Yusuf Ziya YILDIRIM on 7.09.2023.
//

import Foundation

class FirstService: FirstServiceProtocol {
    private let networkManager: NetworkManager
    
    init() {
        self.networkManager = URLSessionNetworkManager.shared
    }
    
    func getAllUsers() async throws -> APIResponse<[User]> {
        let endpoint = FirstGroupEndpoints.getAllUsers
        return try await networkManager.sendRequest(endpoint, responseType: APIResponse<[User]>.self)
    }
    
    func getUser(id: Int) async throws -> APIResponse<User> {
        let endpoint = FirstGroupEndpoints.getUser(id: id)
        return try await networkManager.sendRequest(endpoint, responseType: APIResponse<User>.self)
    }
    
    func setCurrentUserData() async throws -> APIResponse<User> {
        let endpoint = FirstGroupEndpoints.setCurrentUserData
        return try await networkManager.sendRequest(endpoint, responseType: APIResponse<User>.self)
    }
    
    func uploadCurrentUserProfileImage(imageData: Data) async throws -> APIResponse<User> {
        let endpoint = FirstGroupEndpoints.uploadCurrentUserProfileImage(imageData: imageData)
        return try await networkManager.sendRequest(endpoint, responseType: APIResponse<User>.self)
    }
}
