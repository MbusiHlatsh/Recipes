//
//  RecipeListView.swift
//  Recipes
//
//  Created by Mbusi Hlatshwayo on 3/9/25.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeViewModel()
    @State private var showErrorAlert = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationView {
            Group {
                if viewModel.recipes.isEmpty {
                    VStack {
                        Image(systemName: "tray.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                        Text("No recipes available")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Button("Retry") {
                            Task {
                                await loadRecipes()
                            }
                        }
                        .buttonStyle(.bordered)
                        .padding(.top, 10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(viewModel.recipes) { recipe in
                        RecipeRowView(recipe: recipe)
                    }
                }
            }
            .navigationTitle("Recipes")
            .task {
                await loadRecipes()
            }
            .refreshable {
                await loadRecipes()
            }
            .alert("Error", isPresented: $showErrorAlert, actions: {
                Button("Retry") {
                    Task {
                        await loadRecipes()
                    }
                }
                Button("Cancel", role: .cancel) { }
            }, message: {
                Text(errorMessage)
            })
        }
    }

    private func loadRecipes() async {
        do {
            try await viewModel.loadRecipes()
        } catch {
            // in production, we would not expose the real api error
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
    }
}

struct RecipeRowView: View {
    let recipe: Recipe

    var body: some View {
        HStack {
            CachedImageView(urlString: recipe.photoURLSmall)

            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline)
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

