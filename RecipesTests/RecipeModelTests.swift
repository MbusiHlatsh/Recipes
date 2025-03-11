//
//  RecipeModelTests.swift
//  RecipesTests
//
//  Created by Mbusi Hlatshwayo on 3/10/25.
//

import XCTest
@testable import Recipes

class RecipeTests: XCTestCase {

    func testRecipeInitialization() {
        let recipe = Recipe(
            uuid: "12345",
            name: "Pasta",
            cuisine: "Italian",
            photoURLSmall: "https://example.com/small.jpg",
            photoURLLarge: "https://example.com/large.jpg",
            sourceURL: "https://example.com",
            youtubeURL: "https://youtube.com/watch?v=12345"
        )
        
        XCTAssertEqual(recipe.uuid, "12345")
        XCTAssertEqual(recipe.name, "Pasta")
        XCTAssertEqual(recipe.cuisine, "Italian")
        XCTAssertEqual(recipe.photoURLSmall, "https://example.com/small.jpg")
        XCTAssertEqual(recipe.photoURLLarge, "https://example.com/large.jpg")
        XCTAssertEqual(recipe.sourceURL, "https://example.com")
        XCTAssertEqual(recipe.youtubeURL, "https://youtube.com/watch?v=12345")
    }

    func testRecipeJSONDecoding() throws {
        let json = """
        {
            "cuisine": "Malaysian",
            "name": "Apam Balik",
            "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
            "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
            "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
            "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
            "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let recipe = try decoder.decode(Recipe.self, from: json)

        XCTAssertEqual(recipe.uuid, "0c6ca6e7-e32a-4053-b824-1dbf749910d8")
        XCTAssertEqual(recipe.name, "Apam Balik")
        XCTAssertEqual(recipe.cuisine, "Malaysian")
        XCTAssertEqual(recipe.photoURLSmall, "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")
        XCTAssertEqual(recipe.photoURLLarge, "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")
        XCTAssertEqual(recipe.sourceURL, "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ")
        XCTAssertEqual(recipe.youtubeURL, "https://www.youtube.com/watch?v=6R8ffRRJcrg")
    }

}

