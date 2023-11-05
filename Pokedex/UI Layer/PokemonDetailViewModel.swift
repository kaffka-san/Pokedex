//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.11.2023.
//

import Foundation

final class PokemonDetailViewModel: ObservableObject {
    private weak var coordinator: PokemonsCoordinator?
    let name: String

    init(
        coordinator: PokemonsCoordinator?,
        name: String
    ) {
        self.coordinator = coordinator
        self.name = name
    }

    @objc
    func goBack() {
        coordinator?.goBack()
    }

    @objc
    func makeFavourite() {}
}
