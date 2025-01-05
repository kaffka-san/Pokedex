//
//  PokedexSnapshotTests.swift
//  PokedexSnapshotTests
//
//  Created by Anastasia Lenina on 05.01.2025.
//

import AckeeSnapshots
@testable import Pokedex

import XCTest

final class PokemonComponentsTests: XCTestCase {
    func testCapsuleLabel() {
        assertSnapshot.devices(CapsuleLabel_Previews.previews)
    }

    func testCapsuleText() {
        assertSnapshot.devices(CapsuleText_Previews.previews)
    }
}

final class PokemonCellTests: XCTestCase {
    func testPokemonCellSnapshot() {
        let expectation = XCTestExpectation(description: "Image should load successfully")

        Task {
            if let url = URL(string: PokemonCell_Previews.imageUrl) {
                await UIImage.load(from: url)
                expectation.fulfill() // Signal that the image has finished loading
            } else {
                XCTFail("Invalid image URL")
                expectation.fulfill()
            }
        }

        // Wait for the image to load before proceeding
        wait(for: [expectation], timeout: 5.0)

        // Now take the snapshot
        assertSnapshot.devices(PokemonCell_Previews.previews)
    }
}

public let assertSnapshot = SnapshotTest(
    devices: [
        .iPhone13Pro
    ],

    record: false,
    displayScale: 1,
    contentSizes: [.extraExtraExtraLarge, .large, .small],
    colorSchemes: [.light]
)
