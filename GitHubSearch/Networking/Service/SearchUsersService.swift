//
//  SearchUsersService.swift
//  GitHubSearch
//
//  Created by Brayden Harris on 4/13/20.
//  Copyright © 2020 Brayden Harris. All rights reserved.
//

import Foundation

typealias UsersResult = Result<[SearchUsersItem], Error>

class SearchUsersService {
    
    // MARK: - Properties
    let gitHubApi = GitHubAPI()
    
    // MARK: - Public
    func findUsersFor(text: String, completion: @escaping (UsersResult) -> Void) {
        let resource = Resource(endpoint: .search) { (data, response) in
            return self.parseUsers(from: data, response: response)
        }
        
        gitHubApi.get(resource, parameters: ["q": text]) { (result) in
            switch result {
            case .success(let userItems):
                completion(.success(userItems))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Private
    private func parseUsers(from data: Data, response: HTTPURLResponse) -> Result<[SearchUsersItem], Error> {
        if let users = users(from: data) {
            return .success(users)
        } else {
            return .failure(APIClientError.parseError)
        }
    }
    
    private func users(from data: Data) -> [SearchUsersItem]? {
        let decoder = JSONDecoder()
        guard let usersResponse = try? decoder.decode(SearchUsersResponse.self, from: data) else {
            return nil
        }
        
        return usersResponse.items
    }
}
