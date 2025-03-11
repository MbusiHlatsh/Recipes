//
//  ImageCache.swift
//  Recipes
//
//  Created by Mbusi Hlatshwayo on 3/9/25.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    init() {
        cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }

    func getCachedImage(for urlString: String) -> UIImage? {
        let fileURL = cacheDirectory.appendingPathComponent(urlString.hash.description)
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }

    func saveImageToCache(_ image: UIImage, urlString: String) {
        let fileURL = cacheDirectory.appendingPathComponent(urlString.hash.description)
        if let data = image.pngData() {
            try? data.write(to: fileURL)
        }
    }
}

#if DEBUG
extension ImageCache {
    var test_cacheDirectory: URL {
        return cacheDirectory
    }
}
#endif
