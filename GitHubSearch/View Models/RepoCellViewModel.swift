//
//  RepoCellViewModel.swift
//  GitHubSearch
//
//  Created by Brayden Harris on 4/14/20.
//  Copyright © 2020 Brayden Harris. All rights reserved.
//

import Foundation

class RepoCellViewModel {
    
    let repository: RepositoryResponse
    
    init(repository: RepositoryResponse) {
        self.repository = repository
    }
}
