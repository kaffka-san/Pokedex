//
//  ImageCache.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 02.01.2025.
//

import UIKit

/// A singleton class for efficient in-memory image caching using `NSCache`.
final class ImageCache {
    /// Shared instance for global access.
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    /// Stores an image in the cache with a given key.
    /// - Parameters:
    ///   - image: The `UIImage` to store.
    ///   - key: A unique identifier for the image.
    func set(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    /// Retrieves an image from the cache by its key.
    /// - Parameter key: The unique identifier for the image.
    /// - Returns: The cached `UIImage`, or `nil` if not found.
    func get(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
}
