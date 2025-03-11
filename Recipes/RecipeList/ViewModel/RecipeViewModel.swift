//
//  RecipeViewModel.swift
//  Recipes
//
//  Created by Mbusi Hlatshwayo on 3/9/25.
//

import Foundation

@MainActor
class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    
    func loadRecipes() async throws {
        recipes = try await RecipeAPI.shared.fetchRecipes()
    }
}
