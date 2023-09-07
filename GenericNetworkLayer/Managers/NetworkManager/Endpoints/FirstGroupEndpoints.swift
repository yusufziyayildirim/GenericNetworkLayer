//
//  FirstGroupEndpoints.swift
//  GenericNetworkLayer
//
//  Created by Yusuf Ziya YILDIRIM on 7.09.2023.
//

import Foundation

enum FirstGroupEndpoints {
    case getAllUsers
    case getUser(id: Int)
    case setCurrentUserData
    case uploadCurrentUserProfileImage(imageData: Data)
}

extension FirstGroupEndpoints: EndpointProtocol {
    
    var baseURL: String {
        "https://first-group-example.com/api/"
    }
    
    var path: String {
        switch self {
        case .getAllUsers:
            return "/users"
        case .getUser(let id):
            return "/user/\(id)/"
        case .setCurrentUserData:
            return "/user/update/"
        case .uploadCurrentUserProfileImage:
            return "/user/update/photo/"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAllUsers, .getUser:
            return .GET
        case .setCurrentUserData, .uploadCurrentUserProfileImage:
            return .POST
        }
    }
    
    var queryParams: [String : Any]? {
        switch self {
        case .getAllUsers:
            return ["sources": "abc-news", "apiKey": "65aa49462772477ea31c84814fad3bd7"]
        default:
            return nil
        }
    }
    
    var header: [String: String]? {
        var header = ["Content-type": "application/json; charset=UTF-8"]
        
        switch self {
        case .setCurrentUserData, .uploadCurrentUserProfileImage:
            header["Authorization"] = "Bearer YourAuthTokenHere"
            return header
        default:
            return header
        }
    }
    
    var multipartFormData: [(name: String, filename: String, data: Data)]? {
        switch self {
        case .uploadCurrentUserProfileImage(let imageData):
            let filename = "profile_image.jpg"
            return [("profile_image", filename, imageData)]
        default:
            return nil
        }
    }
}
