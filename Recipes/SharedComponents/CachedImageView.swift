//
//  CachedImageView.swift
//  Recipes
//
//  Created by Mbusi Hlatshwayo on 3/9/25.
//

import SwiftUI

struct CachedImageView: View {
    let urlString: String?
    @State private var image: UIImage? = nil

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
                    .task {
                        await loadImage()
                    }
            }
        }
        .frame(width: 100, height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    /// Loads an image asynchronously from a URL.
    /// - First, it checks the cache. If the image is cached, it sets it immediately.
    /// - If not, it downloads the image, caches it, and updates the UI.
    private func loadImage() async {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }

        if let cachedImage = ImageCache.shared.getCachedImage(for: urlString) {
            self.image = cachedImage
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let downloadedImage = UIImage(data: data) {
                ImageCache.shared.saveImageToCache(downloadedImage, urlString: urlString)

                DispatchQueue.main.async {
                    self.image = downloadedImage
                }
            }
        } catch {
            print("Failed to load image: \(error)")
        }
    }
}
