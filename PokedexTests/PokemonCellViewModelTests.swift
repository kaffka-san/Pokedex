//
//  PokemonCellViewModelTests.swift
//  PokedexTests
//
//  Created by Anastasia Lenina on 08.11.2023.
//

import Combine
@testable import Pokedex
import SwiftUI
import XCTest
final class PokemonCellViewModelTests: XCTestCase {
    private var subscriptions: Set<AnyCancellable> = []
    private let genericErrorConfig = AlertConfig(
        title: L.Errors.genericTitle,
        message: L.Errors.genericMessage
    )

    override func tearDown() {
        super.tearDown()
        subscriptions.removeAll()
    }

    func testLoadPokemonWithSuccess() {
        let expectation = XCTestExpectation(description: "Pokemon should be loaded successfully.")
        let viewModel = PokemonCellViewModel(
            name: "bulbasaur",
            url: "https://pokeapi.co/api/v2/pokemon/1",
            pokemonsAPI: MockPokemonsAPI(),
            coordinator: nil,
            userLocation: Binding.constant(
                MockLocation.location
            ),
            favouriteIds: Binding.constant([1, 2, 3])
        )

        viewModel.$pokemon
            .dropFirst()
            .sink { data in
                XCTAssertEqual(data.baseExperience, "64")
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        viewModel.loadPokemon()
        wait(
            for: [expectation],
            timeout: 1
        )
        XCTAssertNil(viewModel.alertConfig)
    }

    func testLoadPokemonWithError() {
        let expectation = XCTestExpectation(description: "Error is thrown")
        let viewModel = PokemonCellViewModel(
            name: "bulbasaur",
            url: "https://pokeapi.co/api/v2/pokemon/1",
            pokemonsAPI: MockFailingPokemonsAPI(),
            coordinator: nil,
            userLocation: Binding.constant(
                MockLocation.location
            ),
            favouriteIds: Binding.constant([1, 2, 3])
        )
        viewModel.$alertConfig
            .dropFirst()
            .sink { data in
                XCTAssertEqual(data?.title, self.genericErrorConfig.title)
                XCTAssertEqual(data?.message, self.genericErrorConfig.message)
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        viewModel.loadPokemon()
        wait(
            for: [expectation],
            timeout: 1
        )
        XCTAssertEqual(viewModel.pokemon.types, [])
    }

    func testConvertToPoundsAndKilograms() {
        let viewModel = PokemonCellViewModel(
            name: "bulbasaur",
            url: "https://pokeapi.co/api/v2/pokemon/1",
            pokemonsAPI: MockPokemonsAPI(),
            coordinator: nil,
            userLocation: Binding.constant(
                MockLocation.location
            ),
            favouriteIds: Binding.constant([1, 2, 3])
        )
        let testValue = 100 // This is the value in decagrams.

        let result = viewModel.convertToPoundsAndKilograms(testValue)

        let expectedKilograms = 10.0
        let expectedPounds = expectedKilograms * 2.20462
        let expectedOutput = String(format: "%.1f lbs (%.1f kg)", expectedPounds, expectedKilograms)

        XCTAssertEqual(result, expectedOutput, "The conversion result should be \(expectedOutput) but was \(result)")
    }

    func testConvertToFeetInchesAndCentimeters() {
        let viewModel = PokemonCellViewModel(
            name: "bulbasaur",
            url: "https://pokeapi.co/api/v2/pokemon/1",
            pokemonsAPI: MockPokemonsAPI(),
            coordinator: nil,
            userLocation: Binding.constant(
                MockLocation.location
            ),
            favouriteIds: Binding.constant([1, 2, 3])
        )
        let decimeters = 32

        let result = viewModel.convertToFeetInchesAndCentimeters(decimeters)

        let expectedCentimeters = Double(decimeters) * 10.0
        let expectedTotalInches = expectedCentimeters / 2.54
        let expectedFeet = Int(expectedTotalInches / 12.0)
        let expectedInches = expectedTotalInches.truncatingRemainder(dividingBy: 12.0)
        let expectedOutput = "\(expectedFeet)'\(String(format: "%.1f", expectedInches))\" (\(String(format: "%.0f cm", expectedCentimeters)))"

        XCTAssertEqual(result, expectedOutput, "The conversion result should be \(expectedOutput) but was \(result)")
    }

    func testExtractNumberFromValidPokemonURL() {
        let viewModel = PokemonCellViewModel(
            name: "bulbasaur",
            url: "https://pokeapi.co/api/v2/pokemon/1",
            pokemonsAPI: MockPokemonsAPI(),
            coordinator: nil,
            userLocation: Binding.constant(
                MockLocation.location
            ),
            favouriteIds: Binding.constant([1, 2, 3])
        )
        let validURL = "https://pokeapi.co/api/v2/pokemon/25/"

        let result = viewModel.extractNumberFromPokemonURL(validURL)

        XCTAssertEqual(result, "25", "The extracted number should be '25' for the given URL")
    }
}
