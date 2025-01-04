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
    func testLoadPokemonSpeciesWithSuccess() {
        let expectation = XCTestExpectation(description: "Pokemon species should be loaded successfully.")
        let viewModel = PokemonDetailViewModel(
            locationManager: LocationManager(),
            soundManager: SoundManager(),
            pokemonService: PokemonService(apiManager: MockAPIManager())
        )
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
        let viewModel = PokemonDetailViewModel(
            locationManager: LocationManager(),
            soundManager: SoundManager(),
            pokemonService: MockFailingPokemonsAPI()
        )
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
        let viewModel = PokemonDetailViewModel(
            locationManager: LocationManager(),
            soundManager: SoundManager(),
            pokemonService: PokemonService(apiManager: MockAPIManager())
        )
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
        let viewModel = PokemonDetailViewModel(
            locationManager: LocationManager(),
            soundManager: SoundManager(),
            pokemonService: PokemonService(apiManager: MockAPIManager())
        )
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

    func testGenderlessPokemon() {
        let viewModel = PokemonDetailViewModel(
            locationManager: LocationManager(),
            soundManager: SoundManager(),
            pokemonService: PokemonService(apiManager: MockAPIManager())
        )
        let gender = viewModel.getPokemonGenderChance(femaleEighths: -1)

        XCTAssertEqual(gender.genderCase, .genderless, "Genderless Pokemon should have empty male and female properties.")
    }

    func testMaleOnlyPokemon() {
        let viewModel = PokemonDetailViewModel(
            locationManager: LocationManager(),
            soundManager: SoundManager(),
            pokemonService: PokemonService(apiManager: MockAPIManager())
        )
        let gender = viewModel.getPokemonGenderChance(femaleEighths: 0)

        XCTAssertEqual(gender.genderCase, .male, "Male-only Pokemon should have 100% male property.")
    }

    func testFemaleOnlyPokemon() {
        let viewModel = PokemonDetailViewModel(
            locationManager: LocationManager(),
            soundManager: SoundManager(),
            pokemonService: PokemonService(apiManager: MockAPIManager())
        )
        let gender = viewModel.getPokemonGenderChance(femaleEighths: 8)

        XCTAssertEqual(gender.genderCase, .female, "Female-only Pokemon should have 100% female property.")
    }
}
