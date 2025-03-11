//
//  Recipe.swift
//  Recipes
//
//  Created by Mbusi Hlatshwayo on 3/9/25.
//

import Foundation

struct Recipe: Identifiable, Codable {
    let uuid: String
    let name: String
    let cuisine: String
    let photoURLSmall: String?
    let photoURLLarge: String?
    let sourceURL: String?
    let youtubeURL: String?

    enum CodingKeys: String, CodingKey {
        case uuid, name, cuisine
        case photoURLSmall = "photo_url_small"
        case photoURLLarge = "photo_url_large"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
    
    var id: String { uuid }
}
