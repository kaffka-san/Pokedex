//
//  PokemonDetailViewModelTests.swift
//  PokedexTests
//
//  Created by Anastasia Lenina on 09.11.2023.
//

import Combine
import XCTest

final class PokemonDetailViewModelTests: XCTestCase {
    var disposeBag: Set<AnyCancellable>!
    var viewModel: PokemonDetailViewModel!
    var mockAPIManager: MockAPIManager!
    var pokemonService: PokemonService!

    private let genericErrorConfig = AlertConfiguration(
        title: LocalizedString.Errors.genericTitle,
        message: LocalizedString.Errors.genericMessage
    )

    override func setUp() {
        super.setUp()
        mockAPIManager = MockAPIManager()
        pokemonService = PokemonService(apiManager: mockAPIManager)
        viewModel = PokemonDetailViewModel(
            locationManager: LocationManager(),
            soundManager: SoundManager(),
            pokemonService: pokemonService
        )
        disposeBag = []
    }

    override func tearDown() {
        super.tearDown()
        disposeBag = nil
    }

    @MainActor
    func testLoadPokemonSpeciesWithSuccess() {
        let expectation = XCTestExpectation(description: "Pokemon species should be loaded successfully.")
        mockAPIManager.resultType = .success
        viewModel.pokemon = MockPokemon.pokemonDetailConfig

        viewModel.$pokemonSpecies
            .dropFirst()
            .sink { data in
                XCTAssertEqual(data.eggGroups, ["monster", "plant"])
                expectation.fulfill()
            }
            .store(in: &disposeBag)
        viewModel.loadPokemonSpecies()
        wait(for: [expectation], timeout: 1)
        XCTAssertNil(viewModel.alertConfig)
    }

    @MainActor
    func testLoadPokemonSpeciesWithError() {
        let expectation = XCTestExpectation(description: "Error is thrown")
        mockAPIManager.resultType = .error
        viewModel.pokemon = MockPokemon.pokemonDetailConfig
        viewModel.$alertConfig
            .dropFirst()
            .sink { data in
                XCTAssertEqual(data?.title, self.genericErrorConfig.title)
                XCTAssertEqual(data?.message, self.genericErrorConfig.message)
                expectation.fulfill()
            }
            .store(in: &disposeBag)
        viewModel.loadPokemonSpecies()
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(viewModel.pokemonSpecies.eggGroups.isEmpty)
    }

    @MainActor
    func testLoadNextPokemonWithSuccess() {
        let expectation = XCTestExpectation(description: "Next Pokemon should be loaded successfully.")
        mockAPIManager.resultType = .success
        viewModel.pokemon = MockPokemon.pokemonDetailConfig

        viewModel.$nextImageUrl
            .dropFirst()
            .sink { data in
                XCTAssertEqual(data, "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/2.png")
                expectation.fulfill()
            }
            .store(in: &disposeBag)
        viewModel.loadNextPokemon()
        wait(for: [expectation], timeout: 1)
        XCTAssertNil(viewModel.alertConfig)
    }

    @MainActor
    func testLoadPreviousPokemonWithSuccess() {
        let expectation = XCTestExpectation(description: "Previous Pokemon should be loaded successfully.")
        mockAPIManager.resultType = .success
        viewModel.pokemon = MockPokemon.pokemonDetailConfig2
        viewModel.$previousImageUrl
            .dropFirst()
            .sink { data in
                XCTAssertEqual(data, "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png")
                expectation.fulfill()
            }
            .store(in: &disposeBag)
        viewModel.loadPokemonSpecies()
        wait(for: [expectation], timeout: 1)
        XCTAssertNil(viewModel.alertConfig)
    }
}
