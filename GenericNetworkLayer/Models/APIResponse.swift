//
//  APIResponse.swift
//  GenericNetworkLayer
//
//  Created by Yusuf Ziya YILDIRIM on 7.09.2023.
//

import Foundation

struct APIResponse<T: Codable>: Codable {
    let status: APIResponseStatus?
    let message: String?
    let data: T?
}

enum APIResponseStatus: String, Codable {
    case success = "success"
    case error = "error"
    case unknown = "unknown"
}
