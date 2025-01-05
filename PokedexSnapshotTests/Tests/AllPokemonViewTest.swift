//
//  AllPokemonViewTest.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.01.2025.
//

@testable import Pokedex
import XCTest

final class AllPokemonViewTest: XCTestCase {
    func testAllPokemonViewSnapshot() {
        let expectation = XCTestExpectation(description: "All async data should load")

        // Create the view model with mock services
        let viewModel = AllPokemonViewModel(
            pokemonService: PokemonService(apiManager: MockAPIManager())
        )

        // Trigger asynchronous data loading
        Task {
            await viewModel.loadPokemons(isInitialLoad: true)
            expectation.fulfill() // Fulfill the expectation once loading is complete
        }

        // Wait for the async task to complete
        wait(for: [expectation], timeout: 5.0) // Adjust timeout as necessary

        // Now create the view and assert the snapshot
        let view = AllPokemonView(viewModel: viewModel)
        assertSnapshot.devices(view)
    }
}
