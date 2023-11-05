//
//  PokemonsViewModel.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.11.2023.
//

import Foundation

final class PokemonsViewModel: ObservableObject {
    private weak var coordinator: PokemonsCoordinator?
    let pokemonsAPI: PokemonsAPIProtocol
    @Published var pokemons = [Pokemon]()
    @Published var alertConfig: AlertConfig?
    @Published private(set) var progressHudState: ProgressHudState = .hide

    init(
        coordinator: PokemonsCoordinator?,
        pokemonsAPI: PokemonsAPIProtocol
    ) {
        self.coordinator = coordinator
        self.pokemonsAPI = pokemonsAPI
        loadPokemons()
    }

    func goToDetailView(name: String) {
        coordinator?.goToDetailView(name: name)
    }

    func loadPokemons() {
        Task { [weak self] in
            guard let self else { return }
            await MainActor.run {
                defer {
                    self.progressHudState = .hide
                }
                self.progressHudState = .showProgress
            }
            do {
                let pokemonsList = try await pokemonsAPI.getPokemons()
                await self.update(pokemonsList: pokemonsList)
            } catch {
                await MainActor.run {
                    self.showAlert()
                }
            }
        }
    }

    @MainActor
    private func update(pokemonsList: Pokemons) {
        pokemons = pokemonsList.results
    }

    func showAlert() {
        alertConfig = AlertConfig(
            title: L.Errors.genericTitle,
            message: L.Errors.genericMessage
        )
    }
}
