//
//  SecondVM.swift
//  GenericNetworkLayer
//
//  Created by Yusuf Ziya YILDIRIM on 7.09.2023.
//

import Foundation

final class SecondVM {
    
    // MARK: - Service
    let service: SecondServiceProtocol
    
    // MARK: - Delegate
    weak var viewDelegate: SecondVMDelegate?
    
    var products = [Product]()
    
    // MARK: - Initialization
    init(service: SecondServiceProtocol) {
        self.service = service
    }
    
    // MARK: - Public Methods
    func getAllProducts() async {
        do {
            let response = try await service.getAllProducts()
            switch response.status {
                
            case "success":
                if let products = response.data {
                    self.products = products
                    viewDelegate?.reloadTableView()
                }
                
            case "error":
                let errorMessage = response.message ?? "Bir hata oluştu"
                viewDelegate?.didFailWithError(error: errorMessage)
                
            default:
                break
            }
            
        } catch {
            viewDelegate?.didFailWithError(error: error.localizedDescription)
        }
    }
    
    //You can add other service functions in a similar manner.
}
