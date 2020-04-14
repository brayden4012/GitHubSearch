//
//  UserService.swift
//  GitHubSearch
//
//  Created by Brayden Harris on 4/13/20.
//  Copyright © 2020 Brayden Harris. All rights reserved.
//

import Foundation

typealias ReposResult = Result<[RepositoryResponse], Error>
typealias UserResult = Result<UserResponse, Error>

class UserService {
    
    // MARK: - Properties
    let gitHubApi = GitHubAPI()
    
    // MARK: - Public
    func getRepos(with username: String, completion: @escaping (ReposResult) -> Void) {
        let resource = Resource(endpoint: .repos(username: username)) { (data, response) in
            return self.parseRepoCount(from: data, response: response)
        }
        
        gitHubApi.get(resource) { (result) in
            switch result {
            case .success(let repoCount):
                completion(.success(repoCount))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getUser(with username: String, completion: @escaping (UserResult) -> Void) {
        let resource = Resource(endpoint: .user(username: username)) { (data, response) in
            return self.parseUser(from: data, response: response)
        }
        
        gitHubApi.get(resource) { (result) in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
        
    // MARK: - Private
    private func parseRepoCount(from data: Data, response: HTTPURLResponse) -> ReposResult {
        if let repoCount = repoCount(from: data) {
            return .success(repoCount)
        } else {
            return .failure(APIClientError.parseError)
        }
    }
    
    private func repoCount(from data: Data) -> [RepositoryResponse]? {
        let decoder = JSONDecoder()
        guard let reposResponse = try? decoder.decode([RepositoryResponse].self, from: data) else {
            return nil
        }
        
        return reposResponse
    }
    
    private func parseUser(from data: Data, response: HTTPURLResponse) -> UserResult {
        if let user = user(from: data) {
            return .success(user)
        } else {
            return .failure(APIClientError.parseError)
        }
    }
    
    private func user(from data: Data) -> UserResponse? {
        let decoder = JSONDecoder()
        guard let userResponse = try? decoder.decode(UserResponse.self, from: data) else {
            return nil
        }
        
        return userResponse
    }
}
