//
//  GitHubAPI.swift
//  GitHubSearch
//
//  Created by Brayden Harris on 4/13/20.
//  Copyright © 2020 Brayden Harris. All rights reserved.
//

import Foundation

class GitHubAPI {
    
    // MARK: - Properties
    private let urlSession: URLSession
    
    // MARK: - Initialization
    init() {
        let config = URLSessionConfiguration.ephemeral
        config.httpShouldSetCookies = false
        self.urlSession = URLSession(configuration: config)
    }
    
    // MARK: - Public
    public func get<T: Codable>(_ resource: Resource<T>, parameters: [String: String]? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        request(resource, method: .GET, parameters: parameters, completion: completion)
    }
    
    // MARK: - Private
    private func request<T: Codable>(_ resource: Resource<T>, method: HTTPMethod, parameters: [String: String]?, completion: @escaping (Result<T, Error>) -> Void) {
        let aRequest = request(for: resource.endpoint, method: method.rawValue, parameters: parameters)
        urlSession.dataTask(with: aRequest) { (data, urlResponse, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data, let httpResponse = urlResponse as? HTTPURLResponse else {
                completion(.failure(APIClientError.networkResponseError))
                return
            }
            
            completion(resource.parse(data, httpResponse))
        }.resume()
    }
    
    private func request(for endpoint: Endpoint, method: String, parameters: [String: String]?) -> URLRequest {
        guard var url = endpoint.url else { fatalError("Failed to construct URL") }
        // Add parameters if necessary
        if let parameters = parameters {
            var queryItems = [URLQueryItem]()
            parameters.forEach { queryItems.append(URLQueryItem(name: $0.key, value: $0.value)) }
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
            urlComponents?.queryItems = queryItems
            if let newUrl = urlComponents?.url {
                url = newUrl
            }
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        // Add headers
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return request
    }
    
}
