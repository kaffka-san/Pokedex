//
//  PokemonCellShapshotTests.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.01.2025.
//

@testable import Pokedex
import XCTest

final class PokemonCellShapshotTests: XCTestCase {
    func testPokemonCellSnapshot() {
        TestUtilities.preloadImages(urls: [PokemonCell_Previews.imageUrl], in: self)
        assertSnapshot.devices(PokemonCell_Previews.previews)
    }
}
