//
//  UserCell.swift
//  GitHubSearch
//
//  Created by Brayden Harris on 4/13/20.
//  Copyright © 2020 Brayden Harris. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var usernameLabel: UILabel!
    @IBOutlet private var repoCountLabel: UILabel!
    
    // MARK: - Properties
    private let userService = UserService()
    private var task: URLSessionDataTask?

    override func prepareForReuse() {
        super.prepareForReuse()
        task?.cancel()
        task = nil
        profileImageView.image = nil
    }
    
    // MARK: - Public
    func configure(with viewModel: UserCellViewModel) {
        if task == nil,
            let profileUrl = viewModel.user.avatarUrl,
            let url = URL(string: profileUrl) {
            DispatchQueue.main.async {
                self.task = self.profileImageView.load(url: url)
            }
        }
        
        usernameLabel.text = viewModel.user.login
        
        if let username = viewModel.user.login {
            userService.getRepos(with: username) { (result) in
                switch result {
                case .success(let repos):
                    DispatchQueue.main.async {
                        self.repoCountLabel.text = "Repo: \(repos.count)"
                    }
                case .failure:
                    DispatchQueue.main.async {
                        self.repoCountLabel.text = "Repo: --"
                    }
                }
            }
        }
    }
}
