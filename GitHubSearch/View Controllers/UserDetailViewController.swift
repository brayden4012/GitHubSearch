//
//  UserDetailViewController.swift
//  GitHubSearch
//
//  Created by Brayden Harris on 4/14/20.
//  Copyright © 2020 Brayden Harris. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var usernameLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var joinDateLabel: UILabel!
    @IBOutlet private var followerCountLabel: UILabel!
    @IBOutlet private var followingCountLabel: UILabel!
    @IBOutlet private var biographyLabel: UILabel!
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var reposTableView: UITableView!
    
    // MARK: - Properties
    private var userRepos = [RepositoryResponse]()
    private var tableRepos = [RepositoryResponse]() {
        didSet {
            DispatchQueue.main.async {
                self.reposTableView.reloadData()
            }
        }
    }
    private let userService = UserService()
    
    // MARK: - Public
    func configure(with user: SearchUsersItem) {
        loadViewIfNeeded()
        guard let username = user.login else { return }
        if let avatarUrl = user.avatarUrl,
            let url = URL(string: avatarUrl) {
            fetchAvatar(with: url)
        }
        
        usernameLabel.text = username
        userService.getUser(with: username, completion: { (result) in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.configureViews(with: user)
                }
            case .failure(let error):
                let alertController = UIAlertController(title: "Uh oh!", message: "Unable to fetch user profile: \(error.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        })
        fetchRepos(for: username)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        reposTableView.dataSource = self
        title = "GitHub Searcher"
    }
    
    // MARK: - Private
    private func fetchRepos(for username: String) {
        userService.getRepos(with: username, completion: { (result) in
            switch result {
            case .success(let repos):
                self.userRepos = repos
                self.tableRepos = repos
            case .failure(let error):
                let alertController = UIAlertController(title: "Uh oh!", message: "Unable to fetch repos: \(error.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        })
    }
    
    private func fetchAvatar(with avatarUrl: URL) {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        avatarImageView.addSubview(activityIndicator)
        activityIndicator.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor).isActive = true
        DispatchQueue.main.async {
            self.avatarImageView.load(url: avatarUrl) { (success) in
                activityIndicator.removeFromSuperview()
                if !success {
                    let alertController = UIAlertController(title: "Uh oh!", message: "Unable to fetch avatar", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    DispatchQueue.main.async {
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    private func configureViews(with user: UserResponse) {
        self.emailLabel.text = user.email
        self.locationLabel.text = user.location
        if let creationDate = user.createdAt,
            let joinDate = DateFormatter.isoDateFormatter.date(from: creationDate) {
            let components = Calendar.current.dateComponents([.month, .day, .year], from: joinDate)
            guard let month = components.month, let day = components.day, let year = components.year else { return }
            self.joinDateLabel.text = "\(month) \(day), \(year)"
        }
        
        if let followerCount = user.followers {
            self.followerCountLabel.text = "\(followerCount) follower"
            if followerCount != 1 {
                followerCountLabel.text?.append("s")
            }
        }
        
        if let followingCount = user.following {
            self.followingCountLabel.text = "Following \(followingCount)"
        }
        
        self.biographyLabel.text = user.bio
    }
}

// MARK: - UISearchBarDelegate
extension UserDetailViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else  {
            tableRepos = userRepos
            return
        }
        tableRepos = userRepos.filter { (repo) -> Bool in
            guard let name = repo.name else { return false }
            return name.contains(searchText)
        }
    }
}

// MARK: - UITableViewDataSource
extension UserDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableRepos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell") as? RepoCell {
            let viewModel = RepoCellViewModel(repository: tableRepos[indexPath.row])
            cell.configure(with: viewModel)
            return cell
        }
        return UITableViewCell()
    }
}
