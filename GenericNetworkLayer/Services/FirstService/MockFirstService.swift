//
//  MockFirstService.swift
//  GenericNetworkLayer
//
//  Created by Yusuf Ziya YILDIRIM on 7.09.2023.
//

import Foundation

// Mock veri sunan bir sınıf. İstediğiniz şekilde bu mock verileri doldurun.
class MockDataService: FirstServiceProtocol {
    
    private var currentUser = User(id: 1, username: "currentUser", email: "currentUser@example.com", imgUrl: "https://example.com/img1.jpg")
    
    private let mockUsers: [User] = [
        User(id: 1, username: "kullanici1", email: "kullanici1@example.com", imgUrl: "https://example.com/img1.jpg"),
        User(id: 2, username: "kullanici2", email: "kullanici2@example.com", imgUrl: "https://example.com/img2.jpg"),
        User(id: 3, username: "kullanici3", email: "kullanici3@example.com", imgUrl: "https://example.com/img3.jpg"),
    ]
    
    func getAllUsers() async throws -> APIResponse<[User]> {
        return APIResponse(status: "success", message: "All Users", data: mockUsers)
    }
    
    func getUser(id: Int) async throws -> APIResponse<User> {
        return APIResponse(status: "success", message: "The User", data: currentUser)
    }
    
    func setCurrentUserData() async throws -> APIResponse<User> {
        let newCurrentUser = User(id: 999, username: "mockuser999", email: "newCurrentUser@example.com", imgUrl: "https://example.com/mockimg.jpg")
        currentUser = newCurrentUser
        return APIResponse(status: "success", message: "Current user data updated", data: currentUser)
    }
    
    func uploadCurrentUserProfileImage(imageData: Data) async throws -> APIResponse<User> {
        let newCurrentUser = User(id: 999, username: "mockuser999", email: "mockuser999newCurrentUser@example.com", imgUrl: "https://example.com/newMockimg.jpg")
        currentUser = newCurrentUser
        return APIResponse(status: "success", message: "Current user profile image updated", data: currentUser)
    }
}
