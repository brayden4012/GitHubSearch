//
//  Authentication.swift
//  GitHubSearch
//
//  Created by Brayden Harris on 4/13/20.
//  Copyright © 2020 Brayden Harris. All rights reserved.
//

import Foundation

public enum AuthenticationType {
    case none
    case headers
    case parameters
}

public class Authentication {
    public var type: AuthenticationType {
        return .none
    }
    public init() {}
    
    public var key: String {
        return ""
    }
    
    public var value: String {
        return ""
    }
    
    public func headers() -> [String : String] {
        return [key : value]
    }
}

public class BasicAuthentication: Authentication {
    override public var type: AuthenticationType {
        return .headers
    }
    public var username: String
    public var password: String
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    override public var key: String {
        return "Authorization"
    }
    
    override public var value: String {
        let authorization = self.username + ":" + self.password
        return "Basic \(authorization.toBase64() ?? "")"
    }
    
    override public func headers() -> [String : String] {
        let authorization = self.username + ":" + self.password
        return ["Authorization": "Basic \(authorization.toBase64() ?? "")"]
    }
}
