//
//  NetworkManager.swift
//  GenericNetworkLayer
//
//  Created by Yusuf Ziya YILDIRIM on 7.09.2023.
//

import Foundation

protocol NetworkManager {
    func sendRequest<T: Decodable>(_ endpoint: EndpointProtocol, responseType: T.Type) async throws -> T
}

class URLSessionNetworkManager: NetworkManager{
    static let shared = URLSessionNetworkManager()
    
    private init() {}
    
    enum NetworkError: Error {
        case invalidURL
        case requestFailed
        case invalidResponse
        case decodingError
    }
    
    func sendRequest<T: Decodable>(_ endpoint: EndpointProtocol, responseType: T.Type) async throws -> T {
        let request = endpoint.makeUrlRequest()
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                return response
            } catch {
                throw NetworkError.decodingError
            }
            
        } catch {
            throw NetworkError.requestFailed
        }
    }
}
