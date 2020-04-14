//
//  APIClientError.swift
//  GitHubSearch
//
//  Created by Brayden Harris on 4/13/20.
//  Copyright © 2020 Brayden Harris. All rights reserved.
//

import Foundation

enum APIClientError: Error {
    case networkResponseError, parseError
}
