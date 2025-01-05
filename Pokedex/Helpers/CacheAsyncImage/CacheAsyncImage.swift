//
//  CacheAsyncImage.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 02.01.2025.
//

import SwiftUI

/// A SwiftUI view that asynchronously loads and displays an image from a specified URL, incorporating caching mechanisms.
///
/// `CacheAsyncImage` uses a provided URL to load an image asynchronously and displays content
/// based on the current phase of the image loading process. The phases are represented by
/// `AsyncImagePhase`, and the view's content updates automatically as the image loading state
/// transitions from empty to either success or failure.
///
/// - Parameters:
///   - url: The URL from which to load the image. If `nil`, the loading process does not begin.
///   - content: A closure returning a view corresponding to the current loading phase.
///     The closure receives an `AsyncImagePhase` and returns the appropriate view to display.
///
/// **Example Usage:**
/// ```swift
/// CacheAsyncImage(url: URL(string: "https://example.com/image.png")) { phase in
///     switch phase {
///     case .empty:
///         ProgressView()
///     case .success(let image):
///         image.resizable()
///     case .failure(_):
///         Image(systemName: "photo.fill")
///     }
/// }
///
struct CacheAsyncImage<Content: View>: View {
    let url: URL?
    var content: (AsyncImagePhase) -> Content
    @State private var phase: AsyncImagePhase = .empty

    /// - Parameters:
    ///   - url: The URL of the image to load. If this is `nil`, the loading process will not begin.
    ///   - content: A closure returning a view corresponding to the current loading phase.
    ///     The closure receives an `AsyncImagePhase` value and returns the view to display.
    init(url: URL?, @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.content = content
        guard let image = UIImage.getImageFromCache(from: url) else { return }
        phase = .success(image)
    }

    var body: some View {
        content(phase)
            .task(id: url) {
                await loadImage()
            }
    }

    /// Begins the image loading process.
    ///
    /// This method starts an asynchronous task that attempts to load the image from the specified `url`.
    /// If the image is successfully loaded, it updates the view's `phase` state to `.success`,
    /// otherwise, it sets the `phase` to `.failure`.
    func loadImage() async {
        phase = await UIImage.load(from: url)
    }
}

/// The phases of image loading within a `CacheAsyncImage` view.
///
/// This enum represents the state of the image loading process:
/// - `empty`: No image is currently loaded, and no attempt to load one has begun.
/// - `success`: An image was successfully loaded and is available.
/// - `failure`: There was an error while attempting to load the image.
///
/// Each phase may carry associated values:
/// - For `success`, the loaded `Image`.
/// - For `failure`, the `Error` that occurred during loading.
enum AsyncImagePhase: Sendable {
    case empty
    case success(Image)
    case failure(Error)

    /// A computed property that returns the associated `Image` if the phase is `success`,
    /// otherwise returns `nil`.
    var image: Image? {
        switch self {
        case let .success(image):
            return image
        default:
            return nil
        }
    }
}
