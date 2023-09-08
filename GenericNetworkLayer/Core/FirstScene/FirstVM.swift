//
//  FirstVM.swift
//  GenericNetworkLayer
//
//  Created by Yusuf Ziya YILDIRIM on 7.09.2023.
//

import Foundation

final class FirstVM{
    
    // MARK: - Service
    let service: FirstServiceProtocol
    
    // MARK: - Delegate
    weak var viewDelegate: FirstVMDelegate?
    
    var users = [User]()
    
    // MARK: - Initialization
    init(service: FirstServiceProtocol) {
        self.service = service
    }
    
    // MARK: - Public Methods
    func getAllUsers() async {
        do {
            let response = try await service.getAllUsers()
            switch response.status {
            case .success:
                if let users = response.data {
                    self.users = users
                    viewDelegate?.reloadTableView()
                }
            case .error:
                let errorMessage = response.message ?? "Something went wrong"
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
