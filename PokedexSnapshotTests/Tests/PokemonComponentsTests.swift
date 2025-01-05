//
//  PokemonComponentsTests.swift
//  PokedexSnapshotTests
//
//  Created by Anastasia Lenina on 05.01.2025.
//

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
