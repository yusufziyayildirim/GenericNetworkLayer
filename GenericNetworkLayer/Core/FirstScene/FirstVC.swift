//
//  FirstVC.swift
//  GenericNetworkLayer
//
//  Created by Yusuf Ziya YILDIRIM on 7.09.2023.
//

import UIKit

protocol FirstVMDelegate: AnyObject {
    func reloadTableView()
    func didFailWithError(error: String)
}

final class FirstVC: UIViewController {
    
    // MARK: - ViewModel
    let viewModel = FirstVM(service: FirstService())
    
    private var firstTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureViewModel()
    }
    
    private func configureTableView() {
        firstTableView = UITableView()
        view.addSubview(firstTableView)
        
        firstTableView.translatesAutoresizingMaskIntoConstraints = false
        firstTableView.delegate = self
        firstTableView.dataSource = self
        
        firstTableView.pinToEdgesOf(view: view)
    }
    
    private func configureViewModel() {
        viewModel.viewDelegate = self
        Task {
            await viewModel.getAllUsers()
        }
    }
    
}

// MARK: - TableViewDelegate and TableViewDataSource
extension FirstVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "UserCell")
        let user = viewModel.users[indexPath.row]
        cell.textLabel?.text = user.username
        
        return cell
    }
    
}

// MARK: - FirstVMDelegate
extension FirstVC: FirstVMDelegate {
    
    func reloadTableView() {
        firstTableView.reloadOnMainThread()
    }
    
    func didFailWithError(error: String) {
        print(error)
    }
    
}
