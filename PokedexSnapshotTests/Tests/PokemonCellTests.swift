//
//  PokemonCellTests.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.01.2025.
//

@testable import Pokedex
import XCTest

final class PokemonCellTests: XCTestCase {
    func testPokemonCellSnapshot() {
        TestUtilities.preloadImages(urls: [PokemonCell_Previews.imageUrl], in: self)
        assertSnapshot.devices(PokemonCell_Previews.previews)
    }
}
