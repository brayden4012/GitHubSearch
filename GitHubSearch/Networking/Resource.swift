//
//  Resource.swift
//  GitHubSearch
//
//  Created by Brayden Harris on 4/13/20.
//  Copyright © 2020 Brayden Harris. All rights reserved.
//

import Foundation

class Resource<T: Codable> {
    
    let endpoint: Endpoint
    let parse: (Data, HTTPURLResponse) -> Result<T, Error>
    
    init(endpoint: Endpoint, parse: @escaping (Data, HTTPURLResponse) -> Result<T, Error>) {
        self.endpoint = endpoint
        self.parse = parse
    }
}
