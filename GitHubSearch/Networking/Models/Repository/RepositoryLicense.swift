//
//  RepositoryLicense.swift
//  GitHubSearch
//
//  Created by Brayden Harris on 4/13/20.
//  Copyright © 2020 Brayden Harris. All rights reserved.
//

import Foundation

public struct RepositoryLicense : Codable {
    public let htmlUrl : String?
    public let key : String?
    public let name : String?
    public let spdxId : String?
    public let url : String?

    enum CodingKeys: String, CodingKey {
        case htmlUrl = "html_url"
        case key
        case name
        case spdxId = "spdx_id"
        case url
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        htmlUrl = try values.decodeIfPresent(String.self, forKey: .htmlUrl)
        key = try values.decodeIfPresent(String.self, forKey: .key)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        spdxId = try values.decodeIfPresent(String.self, forKey: .spdxId)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }
}
