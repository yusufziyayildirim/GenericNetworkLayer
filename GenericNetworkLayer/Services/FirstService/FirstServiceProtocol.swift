//
//  FirstServiceProtocol.swift
//  GenericNetworkLayer
//
//  Created by Yusuf Ziya YILDIRIM on 7.09.2023.
//

import Foundation

protocol FirstServiceProtocol {
    func getAllUsers() async throws -> APIResponse<[User]>
    func getUser(id: Int) async throws -> APIResponse<User>
    func setCurrentUserData() async throws -> APIResponse<User>
    func uploadCurrentUserProfileImage(imageData: Data) async throws -> APIResponse<User>
}
