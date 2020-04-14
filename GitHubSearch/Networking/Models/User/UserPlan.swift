//
//  UserPlan.swift
//  GitHubSearch
//
//  Created by Brayden Harris on 4/14/20.
//  Copyright © 2020 Brayden Harris. All rights reserved.
//

import Foundation

public struct UserPlan : Codable {
    public let collaborators : Int?
    public let name : String?
    public let privateRepos : Int?
    public let space : Int?
    
    enum CodingKeys: String, CodingKey {
        case collaborators
        case name
        case privateRepos = "private_repos"
        case space
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        collaborators = try values.decodeIfPresent(Int.self, forKey: .collaborators)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        privateRepos = try values.decodeIfPresent(Int.self, forKey: .privateRepos)
        space = try values.decodeIfPresent(Int.self, forKey: .space)
    }
}
