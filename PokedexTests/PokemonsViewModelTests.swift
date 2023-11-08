//
//  PokemonsViewModelTests.swift
//  PokedexTests
//
//  Created by Anastasia Lenina on 08.11.2023.
//

import Combine
@testable import Pokedex
import XCTest

final class PokedexTests: XCTestCase {
    private var subscriptions: Set<AnyCancellable> = []
    private let genericErrorConfig = AlertConfig(
        title: L.Errors.genericTitle,
        message: L.Errors.genericMessage
    )

    override func tearDown() {
        super.tearDown()
        subscriptions.removeAll()
    }

    func testLoadDataWithSuccess() {
        let expectation = XCTestExpectation(description: "Data is loaded")
        let viewModel = PokemonsViewModel(
            coordinator: nil,
            pokemonsAPI: MockPokemonsAPI()
        )
        viewModel.$pokemons
            .dropFirst()
            .sink { data in
                XCTAssertEqual(data.first!.name, "bulbasaur")
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        viewModel.loadPokemons()
        wait(
            for: [expectation],
            timeout: 1
        )
        XCTAssertNil(viewModel.alertConfig)
    }
}
