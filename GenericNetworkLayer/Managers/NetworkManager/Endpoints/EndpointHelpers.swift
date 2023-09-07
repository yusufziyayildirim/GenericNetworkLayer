//
//  NetworkHelper.swift
//  GenericNetworkLayer
//
//  Created by Yusuf Ziya YILDIRIM on 7.09.2023.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

//All endpoint group will confirm this protocol
protocol EndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var header: [String: String]? { get }
    var queryParams: [String: Any]? { get }
    var multipartFormData: [(name: String, filename: String, data: Data)]? { get }
}

extension EndpointProtocol {
    
    func makeUrlRequest() -> URLRequest {
        guard var components = URLComponents(string: baseURL) else { fatalError("Invalid base URL") }
        
        // Add path
        components.path = path
        
        //Create request
        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue
        
        //Add queryParams
        if let queryParams = queryParams {
            if method == .GET {
                // For GET requests, append query parameters to the URL
                
                var queryItems: [URLQueryItem] = []
                for (key, value) in queryParams {
                    let queryItem = URLQueryItem(name: key, value: String(describing: value))
                    queryItems.append(queryItem)
                }
                components.queryItems = queryItems
                request.url = components.url
                
            } else {
                // For other methods, add query parameters to the request body
                
                do {
                    let data = try JSONSerialization.data(withJSONObject: queryParams)
                    request.httpBody = data
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        }
        
        //Add header
        if let header = header {
            for (key, value) in header {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        //Add multipart form data
        if let multipartFormData = multipartFormData {
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            for formData in multipartFormData {
                request.httpBody?.append("--\(boundary)\r\n".data(using: .utf8)!)
                request.httpBody?.append("Content-Disposition: form-data; name=\"\(formData.name)\"; filename=\"\(formData.filename)\"\r\n".data(using: .utf8)!)
                request.httpBody?.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
                request.httpBody?.append(formData.data)
                request.httpBody?.append("\r\n".data(using: .utf8)!)
            }
        }
        
        return request
    }
    
}
