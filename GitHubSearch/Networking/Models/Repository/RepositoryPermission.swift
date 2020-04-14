//
//  RepositoryPermission.swift
//  GitHubSearch
//
//  Created by Brayden Harris on 4/13/20.
//  Copyright © 2020 Brayden Harris. All rights reserved.
//

import Foundation

public struct RepositoryPermission : Codable {
    public let admin : Bool?
    public let pull : Bool?
    public let push : Bool?

    enum CodingKeys: String, CodingKey {
        case admin
        case pull
        case push
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        admin = try values.decodeIfPresent(Bool.self, forKey: .admin)
        pull = try values.decodeIfPresent(Bool.self, forKey: .pull)
        push = try values.decodeIfPresent(Bool.self, forKey: .push)
    }
}
