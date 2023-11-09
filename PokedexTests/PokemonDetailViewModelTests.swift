//
//  PokemonDetailViewModelTests.swift
//  PokedexTests
//
//  Created by Anastasia Lenina on 09.11.2023.
//

import Combine
@testable import Pokedex
import SwiftUI
import XCTest

final class PokemonDetailViewModelTests: XCTestCase {
    private var subscriptions: Set<AnyCancellable> = []
    private let genericErrorConfig = AlertConfig(
        title: L.Errors.genericTitle,
        message: L.Errors.genericMessage
    )

    override func tearDown() {
        super.tearDown()
        subscriptions.removeAll()
    }

    func testLoadPokemonSpeciesWithSuccess() {
        let expectation = XCTestExpectation(description: "Pokemon species should be loaded successfully.")
        let viewModel = PokemonDetailViewModel(
            coordinator: nil,
            pokemonsAPI: MockPokemonsAPI(),
            pokemon: MockPokemonDetailConfig.pokemon,
            favouriteIds: Binding.constant([1, 3, 6])
        )
        viewModel.$pokemonSpecies
            .dropFirst()
            .sink { data in
                XCTAssertEqual(data.eggGroups, ["monster"])
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        viewModel.loadPokemonSpecies()
        wait(
            for: [expectation],
            timeout: 1
        )
        XCTAssertNil(viewModel.alertConfig)
    }

    func testLoadPokemonSpeciesWithError() {
        let expectation = XCTestExpectation(description: "Error is thrown")
        let viewModel = PokemonDetailViewModel(
            coordinator: nil,
            pokemonsAPI: MockFailingPokemonsAPI(),
            pokemon: MockPokemonDetailConfig.pokemon,
            favouriteIds: Binding.constant([1, 3, 6])
        )
        viewModel.$alertConfig
            .dropFirst()
            .sink { data in
                XCTAssertEqual(data?.title, self.genericErrorConfig.title)
                XCTAssertEqual(data?.message, self.genericErrorConfig.message)
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        viewModel.loadPokemonSpecies()
        wait(
            for: [expectation],
            timeout: 1
        )
        XCTAssertTrue(viewModel.pokemonSpecies.eggGroups.isEmpty)
    }

    func testLoadNextPokemonWithSuccess() {
        let expectation = XCTestExpectation(description: "Next Pokemon should be loaded successfully.")
        let viewModel = PokemonDetailViewModel(
            coordinator: nil,
            pokemonsAPI: MockPokemonsAPI(),
            pokemon: MockPokemonDetailConfig.pokemon,
            favouriteIds: Binding.constant([1, 3, 6])
        )
        viewModel.$nextImageUrl
            .dropFirst()
            .sink { data in
                XCTAssertEqual(data, "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png")
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        viewModel.loadNextPokemon()
        wait(
            for: [expectation],
            timeout: 1
        )
        XCTAssertNil(viewModel.alertConfig)
    }

    func testLoadPreviousPokemonWithSuccess() {
        let expectation = XCTestExpectation(description: "Previous Pokemon should be loaded successfully.")
        let viewModel = PokemonDetailViewModel(
            coordinator: nil,
            pokemonsAPI: MockPokemonsAPI(),
            pokemon: MockPokemonDetailConfig.pokemon,
            favouriteIds: Binding.constant([1, 3, 6])
        )
        viewModel.$previousImageUrl
            .dropFirst()
            .sink { data in
                XCTAssertEqual(data, "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png")
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        viewModel.loadPokemonSpecies()
        wait(
            for: [expectation],
            timeout: 1
        )
        XCTAssertNil(viewModel.alertConfig)
    }

    func testGenderlessPokemon() {
        let viewModel = PokemonDetailViewModel(
            coordinator: nil,
            pokemonsAPI: MockPokemonsAPI(),
            pokemon: MockPokemonDetailConfig.pokemon,
            favouriteIds: Binding.constant([1, 3, 6])
        )
        let gender = viewModel.getPokemonGenderChance(femaleEighths: -1)

        XCTAssertEqual(gender.genderCase, .genderless, "Genderless Pokemon should have empty male and female properties.")
    }

    func testMaleOnlyPokemon() {
        let viewModel = PokemonDetailViewModel(
            coordinator: nil,
            pokemonsAPI: MockPokemonsAPI(),
            pokemon: MockPokemonDetailConfig.pokemon,
            favouriteIds: Binding.constant([1, 3, 6])
        )
        let gender = viewModel.getPokemonGenderChance(femaleEighths: 0)

        XCTAssertEqual(gender.genderCase, .male, "Male-only Pokemon should have 100% male property.")
    }

    func testFemaleOnlyPokemon() {
        let viewModel = PokemonDetailViewModel(
            coordinator: nil,
            pokemonsAPI: MockPokemonsAPI(),
            pokemon: MockPokemonDetailConfig.pokemon,
            favouriteIds: Binding.constant([1, 3, 6])
        )
        let gender = viewModel.getPokemonGenderChance(femaleEighths: 8)

        XCTAssertEqual(gender.genderCase, .female, "Female-only Pokemon should have 100% female property.")
    }

    func testFindLastOccurrenceWithMultipleOccurrences() {
        let viewModel = PokemonDetailViewModel(
            coordinator: nil,
            pokemonsAPI: MockPokemonsAPI(),
            pokemon: MockPokemonDetailConfig.pokemon,
            favouriteIds: Binding.constant([1, 3, 6])
        )
        let array = ["Ivysaur", "", "BULBASAUR", "Charmander", "Charmeleon", "Charizard"]
        let nameToFind = "bulbasaur"

        let result = viewModel.findLastOccurrence(of: nameToFind, in: array)

        XCTAssertEqual(result, "BULBASAUR", "The method should return the last occurrence of a name containing the search term.")
    }

    func testRemoveNewLines() {
        let viewModel = PokemonDetailViewModel(
            coordinator: nil,
            pokemonsAPI: MockPokemonsAPI(),
            pokemon: MockPokemonDetailConfig.pokemon,
            favouriteIds: Binding.constant([1, 3, 6])
        )
        let stringWithNewLines = "This\nis\na\ntest\nstring."

        let result = viewModel.removeNewLines(from: stringWithNewLines)

        XCTAssertEqual(result, "Thisisateststring.", "The new line characters should be removed from the string.")
    }

    func testCalculateHatchingSteps() {
        let viewModel = PokemonDetailViewModel(
            coordinator: nil,
            pokemonsAPI: MockPokemonsAPI(),
            pokemon: MockPokemonDetailConfig.pokemon,
            favouriteIds: Binding.constant([1, 3, 6])
        )
        let initialHatchCounter = 10
        let expectedSteps = 255 * (initialHatchCounter + 1)

        let result = viewModel.calculateHatchingSteps(initialHatchCounter: initialHatchCounter)

        XCTAssertEqual(result, "\(expectedSteps) \(L.PokemonDetail.steps)", "The calculated hatching steps should match the expected value.")
    }
}
