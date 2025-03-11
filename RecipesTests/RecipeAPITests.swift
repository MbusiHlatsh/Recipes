//
//  RecipeAPITests.swift
//  RecipesTests
//
//  Created by Mbusi Hlatshwayo on 3/10/25.
//

import XCTest
@testable import Recipes

class MockRecipeAPI: APIService {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func fetch<T: Decodable>(from endpoint: String, responseKey: String?) async throws -> T {
        let url = URL(string: "https://mock-url.com" + endpoint)!

        let (data, response) = try await session.data(from: url)
        
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
    }

    func fetchRecipes() async throws -> [Recipe] {
        try await fetch(from: "/mock-recipes.json", responseKey: "recipes")
    }
}


final class RecipeAPITests: XCTestCase {
    var apiService: MockRecipeAPI!

    override func setUp() {
        super.setUp()
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        
        apiService = MockRecipeAPI(session: session)
    }
    
    override func tearDown() {
        apiService = nil
        super.tearDown()
    }
    
    func testFetchRecipes_Success() async throws {
        let mockJSON = """
        {
            "recipes": [
                {
                    "cuisine": "Malaysian",
                    "name": "Apam Balik",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                    "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                    "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                    "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
                },
                {
                    "cuisine": "British",
                    "name": "Apple & Blackberry Crumble",
                    "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
                    "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
                    "source_url": "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
                    "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
                    "youtube_url": "https://www.youtube.com/watch?v=4vhcOwVBDO4"
                }
            ]
        }
        """.data(using: .utf8)!
        
        MockURLProtocol.responseData = mockJSON
        MockURLProtocol.responseCode = 200
        
        do {
            let recipes: [Recipe] = try await apiService.fetchRecipes()
            XCTAssertEqual(recipes.count, 2)
            XCTAssertEqual(recipes[0].name, "Apam Balik")
            XCTAssertEqual(recipes[1].cuisine, "British")
        } catch {
            XCTFail("Expected success but got error: \(error)")
        }
    }
    
    func testFetchRecipes_DecodingError() async throws {
        let mockJSON = """
        {
            "wrongKey": []
        }
        """.data(using: .utf8)!
        
        MockURLProtocol.responseData = mockJSON
        MockURLProtocol.responseCode = 200
        
        do {
            _ = try await apiService.fetchRecipes()
            XCTFail("Expected decoding error but got success")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .decodingError)
        }
    }
    
    func testFetchRecipes_NoData() async throws {
        let mockJSON = """
        {
            "recipes": []
        }
        """.data(using: .utf8)!
        
        MockURLProtocol.responseData = mockJSON
        MockURLProtocol.responseCode = 200

        do {
            let recipes = try await apiService.fetchRecipes()
            XCTAssertTrue(recipes.isEmpty, "Expected empty array but got non-empty result")
        } catch {
            XCTFail("Expected success with an empty array but got error: \(error)")
        }
    }
    
    func testFetchRecipes_ServerError() async throws {
        MockURLProtocol.responseData = nil
        MockURLProtocol.responseCode = 500
        
        do {
            _ = try await apiService.fetchRecipes()
            XCTFail("Expected server error but got success")
        } catch let error as NetworkError {
            if case .serverError(let statusCode) = error {
                XCTAssertEqual(statusCode, 500)
            } else {
                XCTFail("Unexpected error type: \(error)")
            }
        }
    }
}
