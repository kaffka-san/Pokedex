//
//  PokemonsViewModelTests.swift
//  PokedexTests
//
//  Created by Anastasia Lenina on 08.11.2023.
//

import Combine
@testable import Pokedex
import XCTest

// final class PokedexTests: XCTestCase {
//    private var subscriptions: Set<AnyCancellable> = []
//    private let genericErrorConfig = AlertConfig(
//        title: L.Errors.genericTitle,
//        message: L.Errors.genericMessage
//    )
//
//    override func tearDown() {
//        super.tearDown()
//        subscriptions.removeAll()
//    }
//
//    func testLoadPokemonsWithSuccess() {
//        let expectation = XCTestExpectation(description: "Pokemons should be loaded successfully.")
//        let viewModel = PokemonsViewModel(
//            coordinator: nil,
//            pokemonsAPI: MockPokemonsAPI()
//        )
//        viewModel.$pokemons
//            .dropFirst()
//            .sink { data in
//                XCTAssertEqual(data.first!.name, "bulbasaur")
//                expectation.fulfill()
//            }
//            .store(in: &subscriptions)
//        viewModel.loadPokemons()
//        wait(
//            for: [expectation],
//            timeout: 1
//        )
//        XCTAssertNil(viewModel.alertConfig)
//    }
//
//    func testLoadPokemonsWithError() {
//        let expectation = XCTestExpectation(description: "Error is thrown")
//        let viewModel = PokemonsViewModel(
//            coordinator: nil,
//            pokemonsAPI: MockFailingPokemonsAPI()
//        )
//        viewModel.$alertConfig
//            .dropFirst()
//            .sink { data in
//                XCTAssertEqual(data?.title, self.genericErrorConfig.title)
//                XCTAssertEqual(data?.message, self.genericErrorConfig.message)
//                expectation.fulfill()
//            }
//            .store(in: &subscriptions)
//        viewModel.loadPokemons()
//        wait(
//            for: [expectation],
//            timeout: 1
//        )
//        XCTAssertTrue(viewModel.pokemons.isEmpty)
//    }
//
//    func testGetFavourite() {
//        let viewModel = PokemonsViewModel(
//            coordinator: nil,
//            pokemonsAPI: MockPokemonsAPI()
//        )
//        viewModel.favouriteIds = Set([1, 2, 3])
//
//        viewModel.getFavourite()
//
//        XCTAssertEqual(viewModel.pokemons.count, viewModel.favouriteIds.count, "The number of favourite pokemons should be equal to the number of favourite IDs.")
//        XCTAssertEqual(viewModel.showingFavourites, true, "showingFavourites should be true after calling getFavourite().")
//    }
//
//    func testLoadGenerationsWithSuccess() {
//        let expectation = XCTestExpectation(description: "Pokemons with certain generation should be loaded successfully.")
//        let viewModel = PokemonsViewModel(
//            coordinator: nil,
//            pokemonsAPI: MockPokemonsAPI()
//        )
//        viewModel.$pokemons
//            .dropFirst()
//            .sink { data in
//                XCTAssertEqual(data.first!.name, "bulbasaur")
//                XCTAssertEqual(data.count, 2)
//                expectation.fulfill()
//            }
//            .store(in: &subscriptions)
//        viewModel.loadGeneration(index: 1)
//        wait(
//            for: [expectation],
//            timeout: 1
//        )
//        XCTAssertTrue(viewModel.disablePagination)
//        XCTAssertNil(viewModel.alertConfig)
//    }
//
//    func testLoadGenerationsWithError() {
//        let expectation = XCTestExpectation(description: "Error is thrown")
//        let viewModel = PokemonsViewModel(
//            coordinator: nil,
//            pokemonsAPI: MockFailingPokemonsAPI()
//        )
//        viewModel.$alertConfig
//            .dropFirst()
//            .sink { data in
//                XCTAssertEqual(data?.title, self.genericErrorConfig.title)
//                XCTAssertEqual(data?.message, self.genericErrorConfig.message)
//                expectation.fulfill()
//            }
//            .store(in: &subscriptions)
//        viewModel.loadGeneration(index: 1)
//        wait(
//            for: [expectation],
//            timeout: 1
//        )
//        XCTAssertTrue(viewModel.pokemons.isEmpty)
//    }
//
//    func testShowAllPokemons() {
//        let viewModel = PokemonsViewModel(
//            coordinator: nil,
//            pokemonsAPI: MockPokemonsAPI()
//        )
//
//        viewModel.showAllPokemons()
//
//        XCTAssertFalse(viewModel.showingFavourites)
//        XCTAssertFalse(viewModel.disablePagination)
//    }
// }
