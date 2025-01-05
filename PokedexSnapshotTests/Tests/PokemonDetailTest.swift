//
//  PokemonDetailTest.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.01.2025.
//

@testable import Pokedex
import XCTest

final class PokemonDetailTest: XCTestCase {
    func testPokemonDetailViewSnapshot() {
        TestUtilities.preloadImages(urls: [PokemonDetailView_Previews.imageURL], in: self)
//
        assertSnapshot.devices(PokemonDetailView_Previews.previews)
    }
}
