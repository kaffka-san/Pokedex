//
//  AllPokemonViewSnapshotTest.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.01.2025.
//

@testable import Pokedex
import XCTest

final class AllPokemonViewSnapshotTest: XCTestCase {
    @MainActor
    func testAllPokemonViewSnapshot() async throws {
        let viewModel = AllPokemonViewModel(
            pokemonService: PokemonService(apiManager: MockAPIManager())
        )

        viewModel.loadPokemons(isInitialLoad: true)
        try await Task.sleep(nanoseconds: UInt64(2.0 * 1_000_000_000))

        let view = AllPokemonView(viewModel: viewModel)
        assertSnapshot.devices(view)
    }
}
