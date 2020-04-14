//
//  SearchViewController.swift
//  GitHubSearch
//
//  Created by Brayden Harris on 4/13/20.
//  Copyright © 2020 Brayden Harris. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var resultsTableView: UITableView!
    
    // MARK: - Properties
    private let searchUsersService = SearchUsersService()
    private var users = [SearchUsersItem]() {
        didSet {
            DispatchQueue.main.async {
                self.resultsTableView.reloadData()
            }
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            users.removeAll()
            return
        }
        searchUsersService.findUsersFor(text: searchText) { (result) in
            switch result {
            case .success(let users):
                self.users = users
            case .failure(let error):
                let alertController = UIAlertController(title: "Uh oh!", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell {
            let viewModel = UserCellViewModel(user: users[indexPath.row])
            cell.configure(with: viewModel)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let userDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: UserDetailViewController.self)) as? UserDetailViewController {
            userDetailVC.configure(with: users[indexPath.row])
            userDetailVC.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(userDetailVC, animated: true)
        }
    }
}
