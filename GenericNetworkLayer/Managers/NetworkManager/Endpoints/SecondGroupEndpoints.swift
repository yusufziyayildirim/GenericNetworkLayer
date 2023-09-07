//
//  SecondGroupEndpoints.swift
//  GenericNetworkLayer
//
//  Created by Yusuf Ziya YILDIRIM on 7.09.2023.
//

import Foundation

enum SecondGroupEndpoints {
    case getAllProducts
    case getProduct(id: Int)
}

extension SecondGroupEndpoints: EndpointProtocol {
    var baseURL: String {
        "https://second-group-example.com/api/"
    }
    
    var path: String {
        switch self {
        case .getAllProducts:
            return "/products/"
        case .getProduct(let id):
            return "/product/\(id)/"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAllProducts, .getProduct:
            return .GET
        }
    }
    
    var queryParams: [String : Any]? {
        switch self {
        case .getAllProducts:
            return ["page": 1, "pageSize": 20]
        default:
            return nil
        }
    }
    
    var header: [String: String]? {
        let header = ["Content-type": "application/json; charset=UTF-8"]
        
        // You can optionally add the Authorization header as needed.
        // Ex: header["Authorization"] = "Bearer YourAuthTokenHere"
        
        return header
    }
    
    var multipartFormData: [(name: String, filename: String, data: Data)]? {
        return nil // We are not using multipart form data for this group.
    }
}
