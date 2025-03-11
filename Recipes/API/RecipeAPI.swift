//
//  RecipeAPI.swift
//  Recipes
//
//  Created by Mbusi Hlatshwayo on 3/9/25.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
    case unknown(Error)

    // Primarily used for unit testing
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.noData, .noData),
             (.decodingError, .decodingError):
            return true
        case (.serverError(let code1), .serverError(let code2)):
            return code1 == code2
        case (.unknown, .unknown):
            return true
        default:
            return true
        }
    }
}

protocol APIService {
    func fetch<T: Decodable>(from endpoint: String, responseKey: String?) async throws -> T
}

class RecipeAPI: APIService {
    static let shared = RecipeAPI()
    
    private let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net"
    
    func fetch<T: Decodable>(from endpoint: String, responseKey: String? = nil) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown(URLError(.badServerResponse))
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            
            if let key = responseKey {
                let container = try decoder.decode([String: T].self, from: data)
                guard let result = container[key] else {
                    throw NetworkError.decodingError
                }
                return result
            } else {
                return try decoder.decode(T.self, from: data)
            }
        } catch _ as DecodingError {
            throw NetworkError.decodingError
        } catch {
            throw NetworkError.unknown(error)
        }
    }

    func fetchRecipes() async throws -> [Recipe] {
        try await fetch(from: "/recipes.json", responseKey: "recipes")
//        try await fetch(from: "/recipes-malformed.json", responseKey: "recipes")
//        try await fetch(from: "/recipes-empty.json", responseKey: "recipes")
    }
}
