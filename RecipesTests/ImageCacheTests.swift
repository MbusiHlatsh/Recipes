//
//  ImageCacheTests.swift
//  RecipesTests
//
//  Created by Mbusi Hlatshwayo on 3/10/25.
//

import XCTest
@testable import Recipes
import UIKit

class ImageCacheTests: XCTestCase {
    
    var imageCache: ImageCache!
    let testURLString = "https://example.com/testImage.png"
    
    override func setUp() {
        super.setUp()
        imageCache = ImageCache.shared
        
        let fileURL = imageCache.test_cacheDirectory.appendingPathComponent(testURLString.hash.description)
        try? FileManager.default.removeItem(at: fileURL)
    }

    override func tearDown() {
        let fileURL = imageCache.test_cacheDirectory.appendingPathComponent(testURLString.hash.description)
        try? FileManager.default.removeItem(at: fileURL)
        
        super.tearDown()
    }

    func testSaveImageToCache() {
        let testImage = UIImage(systemName: "star")!
        
        imageCache.saveImageToCache(testImage, urlString: testURLString)
        
        let fileURL = imageCache.test_cacheDirectory.appendingPathComponent(testURLString.hash.description)
        XCTAssertTrue(FileManager.default.fileExists(atPath: fileURL.path), "Image file should exist in cache")
    }

    func testGetCachedImage() {
        let testImage = UIImage(systemName: "star")!
        
        imageCache.saveImageToCache(testImage, urlString: testURLString)
        
        let cachedImage = imageCache.getCachedImage(for: testURLString)
        
        XCTAssertNotNil(cachedImage, "Cached image should not be nil")
    }

    func testGetNonExistentCachedImage() {
        let nonExistentImage = imageCache.getCachedImage(for: "https://example.com/nonExistentImage.png")
        XCTAssertNil(nonExistentImage, "Retrieving a non-existent image should return nil")
    }
}
