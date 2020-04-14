//
//  RepoCell.swift
//  GitHubSearch
//
//  Created by Brayden Harris on 4/14/20.
//  Copyright © 2020 Brayden Harris. All rights reserved.
//

import UIKit

class RepoCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var forkCountLabel: UILabel!
    @IBOutlet private var starCountLabel: UILabel!

    // MARK: - Public
    func configure(with viewModel: RepoCellViewModel) {
        nameLabel.text = viewModel.repository.name
        
        if let forkCount = viewModel.repository.forksCount {
            forkCountLabel.text = "\(forkCount) fork"
            if forkCount > 1 || forkCount == 0 {
                forkCountLabel.text?.append("s")
            }
        }
        
        if let starCount = viewModel.repository.stargazersCount {
            starCountLabel.text = "\(starCount) star"
            if starCount > 1 || starCount == 0 {
                starCountLabel.text?.append("s")
            }
        }
    }
}
