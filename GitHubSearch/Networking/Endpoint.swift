//
//  Endpoint.swift
//  GitHubSearch
//
//  Created by Brayden Harris on 4/13/20.
//  Copyright © 2020 Brayden Harris. All rights reserved.
//

import Foundation

enum Endpoint {
    case search, repos(username: String), user(username: String)

    var path: String {
        let pathName: String
        switch self {
        case .search:
            pathName = "/search/users"
        case .repos(let username):
            pathName = "/users/\(username)/repos"
        case .user(let username):
            if let encodedUsername = username.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed) {
                pathName = "/users/\(encodedUsername)"
            } else {
                pathName = "/users/\(username)"
            }
        }
        
        return pathName
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = NetworkConstants.hostName
        components.path = path
        return components.url
    }
}
