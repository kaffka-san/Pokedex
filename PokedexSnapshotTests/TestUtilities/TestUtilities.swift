//
//  TestUtilities.swift
//  PokedexSnapshotTests
//
//  Created by Anastasia Lenina on 05.01.2025.
//

@testable import Pokedex
import XCTest

enum TestUtilities {
    static func preloadImages(urls: [String], in testCase: XCTestCase) {
        let expectation = XCTestExpectation(description: "All images should load successfully")
        expectation.expectedFulfillmentCount = urls.count // Fulfill for each URL

        Task {
            for urlString in urls {
                if let url = URL(string: urlString) {
                    _ = await UIImage.load(from: url)
                    expectation.fulfill() // Fulfill the expectation for each loaded image
                } else {
                    XCTFail("Invalid image URL: \(urlString)")
                    expectation.fulfill()
                }
            }
        }

        // Wait for all images to load
        testCase.wait(for: [expectation], timeout: Double(urls.count) * 5.0) // Adjust timeout as needed
    }
}
