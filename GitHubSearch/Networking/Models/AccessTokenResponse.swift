//
//  AccessTokenResponse.swift
//  GitHubSearch
//
//  Created by Brayden Harris on 4/14/20.
//  Copyright © 2020 Brayden Harris. All rights reserved.
//

import Foundation

public struct AccessTokenResponse: Codable {
    public let accessToken: String
    public let tokenType: String
    public let scope: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope = "scope"
    }
}
