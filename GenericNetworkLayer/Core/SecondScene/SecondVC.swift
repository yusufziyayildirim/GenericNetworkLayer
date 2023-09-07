//
//  SecondVC.swift
//  GenericNetworkLayer
//
//  Created by Yusuf Ziya YILDIRIM on 7.09.2023.
//

import UIKit

protocol SecondVMDelegate: AnyObject {
    func reloadTableView()
    func didFailWithError(error: String)
}

class SecondVC: UIViewController {
    
    // MARK: - ViewModel
    let viewModel = SecondVM(service: SecondService())
    
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
            await viewModel.getAllProducts()
        }
    }
}

// MARK: - TableViewDelegate and TableViewDataSource
extension SecondVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ProductCell")
        let product = viewModel.products[indexPath.row]
        cell.textLabel?.text = product.name // Burada product.name'i gösteriyoruz, gerçek isim verisine göre ayarlayın
        
        return cell
    }
}

// MARK: - SecondVMDelegate
extension SecondVC: SecondVMDelegate {

    func reloadTableView() {
        firstTableView.reloadOnMainThread()
    }
    
    func didFailWithError(error: String) {
        print(error)
    }
    
}
