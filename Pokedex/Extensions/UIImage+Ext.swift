//
//  UIImage+Ext.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 02.01.2025.
//

import SwiftUI
import UIKit

extension UIImage {
    static var imageCache = ImageCache.shared

    /// Loads an image asynchronously from a given URL and handles caching, this is used in CacheAsyncImage.
    /// - Parameter url: The URL from which to load the image.
    /// - Returns: An `AsyncImagePhase` indicating the result of the image loading process. Trying to mimic AsyncImage phase.
    static func load(from url: URL?) async -> AsyncImagePhase {
        guard let url else {
            return .failure(NetworkingError.invalidURL)
        }
        // Return cached image if available
        if let cachedImage = imageCache.get(forKey: url.absoluteString) {
            return .success(Image(uiImage: cachedImage))
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return .failure(NetworkingError.invalidResponse)
            }

            guard let image = UIImage(data: data) else {
                return .failure(NetworkingError.invalidData)
            }

            imageCache.set(image, forKey: url.absoluteString)
            return .success(Image(uiImage: image))
        } catch {
            return .failure(error)
        }
    }
}

extension Image {
    init?(fromImageLiteral image: ImageName) {
        self.init(image.rawValue)
    }

    init(sfSymbol: Symbol) {
        self.init(systemName: sfSymbol.rawValue)
    }
}
