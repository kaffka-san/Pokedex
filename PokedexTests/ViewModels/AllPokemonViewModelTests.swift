//
//  AllPokemonViewModelTests.swift
//  PokedexTests
//
//  Created by Anastasia Lenina on 08.11.2023.
//

import Combine
import XCTest

final class AllPokemonViewModelTests: XCTestCase {
    var disposeBag: Set<AnyCancellable>!
    private let genericErrorConfig = AlertConfiguration(
        title: LocalizedString.Errors.genericTitle,
        message: LocalizedString.Errors.genericMessage
    )

    override func setUp() {
        super.setUp()

        disposeBag = []
    }

    override func tearDown() {
        super.tearDown()
        disposeBag = nil
    }

    @MainActor
    func testLoadAllPokemonWithSuccess() {
        let expectation = XCTestExpectation(description: "Pokemons should be loaded successfully.")
        let viewModel = AllPokemonViewModel(pokemonService: PokemonService(apiManager: MockAPIManager()))
        viewModel.$pokemons
            .dropFirst()
            .sink { data in
                XCTAssertEqual(data.first!.name, "bulbasaur")
                expectation.fulfill()
            }
            .store(in: &disposeBag)
        viewModel.loadPokemons(state: .initial)
        wait(for: [expectation], timeout: 1)
        XCTAssertNil(viewModel.alertConfig)
    }

    @MainActor
    func testLoadPokemonWithSuccess() {
        let expectation = XCTestExpectation(description: "Pokemon detail should be loaded successfully.")
        let viewModel = AllPokemonViewModel(pokemonService: PokemonService(apiManager: MockAPIManager()))
        viewModel.$pokemonsDetailed
            .dropFirst()
            .sink { data in
                XCTAssertEqual(data.first!.height, 7)
                expectation.fulfill()
            }
            .store(in: &disposeBag)
        viewModel.loadPokemonDetail(for: MockPokemon.pokemon)
        wait(for: [expectation], timeout: 1)
        XCTAssertNil(viewModel.alertConfig)
    }

    @MainActor
    func testLoadPokemonsWithError() {
        let expectation = XCTestExpectation(description: "Error is thrown")
        let viewModel = AllPokemonViewModel(pokemonService: MockFailingPokemonsAPI())

        viewModel.$alertConfig
            .dropFirst()
            .sink { data in
                XCTAssertEqual(data?.title, self.genericErrorConfig.title)
                XCTAssertEqual(data?.message, self.genericErrorConfig.message)
                expectation.fulfill()
            }
            .store(in: &disposeBag)
        viewModel.loadPokemons(state: .initial)
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(viewModel.pokemons.isEmpty)
    }

    @MainActor
    func testLoadPokemonWithError() {
        let expectation = XCTestExpectation(description: "Error is thrown")
        let viewModel = AllPokemonViewModel(pokemonService: MockFailingPokemonsAPI())

        viewModel.$alertConfig
            .dropFirst()
            .sink { data in
                XCTAssertEqual(data?.title, self.genericErrorConfig.title)
                XCTAssertEqual(data?.message, self.genericErrorConfig.message)
                expectation.fulfill()
            }
            .store(in: &disposeBag)
        viewModel.loadPokemonDetail(for: MockPokemon.pokemon)
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(viewModel.pokemons.isEmpty)
    }

    @MainActor
    func testGetFavourite() {
        let viewModel = AllPokemonViewModel(pokemonService: PokemonService(apiManager: MockAPIManager()))
        viewModel.favouriteIds = Set([1, 2, 3])
        viewModel.getFavourite()

        XCTAssertEqual(viewModel.pokemons.count, viewModel.favouriteIds.count, "The number of favourite pokemons should be equal to the number of favourite IDs.")
        XCTAssertEqual(viewModel.showingFavourites, true, "showingFavourites should be true after calling getFavourite().")
    }

    @MainActor
    func testLoadGenerationsWithSuccess() {
        let expectation = XCTestExpectation(description: "Pokemons for a certain generation should load successfully.")
        let viewModel = AllPokemonViewModel(pokemonService: PokemonService(apiManager: MockAPIManager()))

        viewModel.$pokemons
            .dropFirst()
            .sink { data in
                XCTAssertEqual(data.count, 151, "Expected 151 pokemons to be loaded.")
                XCTAssertEqual(data.first?.name, "bulbasaur", "First Pokemon should be bulbasaur.")
                expectation.fulfill()
            }
            .store(in: &disposeBag)

        viewModel.loadGeneration(index: 1)

        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(viewModel.disablePagination, "Pagination should be disabled when loading a generation.")
        XCTAssertNil(viewModel.alertConfig, "No alert should be triggered for a successful load.")
    }

    @MainActor
    func testLoadGenerationsWithError() {
        let expectation = XCTestExpectation(description: "Error should be triggered when loading a generation.")
        let viewModel = AllPokemonViewModel(pokemonService: MockFailingPokemonsAPI())

        viewModel.$alertConfig
            .dropFirst()
            .sink { data in
                XCTAssertEqual(data?.title, self.genericErrorConfig.title, "Error title should match the generic error.")
                XCTAssertEqual(data?.message, self.genericErrorConfig.message, "Error message should match the generic error.")
                expectation.fulfill()
            }
            .store(in: &disposeBag)

        viewModel.loadGeneration(index: 1)

        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(viewModel.pokemons.isEmpty, "Pokemons array should be empty when an error occurs.")
    }

    @MainActor
    func testShowAllPokemons() {
        let viewModel = AllPokemonViewModel(pokemonService: PokemonService(apiManager: MockAPIManager()))

        viewModel.showAllPokemons()

        XCTAssertFalse(viewModel.showingFavourites, "Showing favourites should be false when showing all Pokemons.")
        XCTAssertFalse(viewModel.disablePagination, "Pagination should not be disabled when showing all Pokemons.")
    }
}
