//
//  PokemonDetailSnapshotTest.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.01.2025.
//

import Combine
@testable import Pokedex
import XCTest

final class PokemonDetailSnapshotTest: XCTestCase {
    @MainActor
    func testPokemonDetailViewSnapshot() async throws {
        // Create the view model with mock data
        let viewModel = PokemonDetailViewModel(
            locationManager: LocationManager(),
            soundManager: SoundManager(),
            pokemonService: PokemonService(apiManager: MockAPIManager())
        )

        // Trigger data loading
        viewModel.pokemon = MockPokemon.pokemonDetailConfig
        viewModel.loadPokemonSpecies()

        // Wait until the view model has loaded the data
        try await Task.sleep(nanoseconds: UInt64(2.0 * 1_000_000_000))

        // Snapshot the SwiftUI view
        let view = PokemonDetailView(viewModel: viewModel)
        assertSnapshot.devices(view)
    }
}
