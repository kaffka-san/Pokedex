//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.11.2023.
//

import Foundation

struct PokemonSpeciesConfig {
    let description: String
    let eggGroups: [String]
}

final class PokemonDetailViewModel: ObservableObject {
    private weak var coordinator: PokemonsCoordinator?
    private let pokemonsAPI: PokemonsAPIProtocol
    let pokemon: PokemonDetailConfig
    var colorBackground: String {
        pokemon.types.first?.capitalized ?? "White"
    }

    @Published var pokemonSpecies = PokemonSpeciesConfig(description: "", eggGroups: [])
    @Published var alertConfig: AlertConfig?
    @Published var nextImageUrl: String?
    @Published var previousImageUrl: String?

    init(
        coordinator: PokemonsCoordinator?,
        pokemonsAPI: PokemonsAPIProtocol,
        pokemon: PokemonDetailConfig
    ) {
        self.coordinator = coordinator
        self.pokemonsAPI = pokemonsAPI
        self.pokemon = pokemon
        loadPokemonSpecies()
        loadNextPokemon()
        loadPreviousPokemon()
    }

    @objc
    func goBack() {
        coordinator?.goBack()
    }

    @objc
    func makeFavourite() {}

    func loadPokemonSpecies() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let pokemonDetail = try await pokemonsAPI.getPokemonSpecies(name: pokemon.name)
                await self.updateSpecies(pokemonDetail: pokemonDetail)
            } catch {
                print(error)
                await MainActor.run {
                    self.showAlert()
                }
            }
        }
    }

    func loadNextPokemon() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let pokemonDetail = try await pokemonsAPI.getPokemonDetail(name: "\(pokemon.id + 1)")
                await self.updateNext(pokemonDetail: pokemonDetail)
            } catch {
                print(error)
                await MainActor.run {
                    self.showAlert()
                }
            }
        }
    }

    func loadPreviousPokemon() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let pokemonDetail = try await pokemonsAPI.getPokemonDetail(name: "\(pokemon.id - 1)")
                await self.updatePrevious(pokemonDetail: pokemonDetail)
            } catch {
                print(error)
                await MainActor.run {
                    self.showAlert()
                }
            }
        }
    }

    @MainActor
    private func updatePrevious(pokemonDetail: PokemonDetail) {
        previousImageUrl = pokemonDetail.sprites.other?.officialArtwork.frontDefault ?? pokemonDetail.sprites.frontDefault
    }

    @MainActor
    private func updateNext(pokemonDetail: PokemonDetail) {
        nextImageUrl = pokemonDetail.sprites.other?.officialArtwork.frontDefault ?? pokemonDetail.sprites.frontDefault
    }

    @MainActor
    private func updateSpecies(pokemonDetail: PokemonSpecies) {
        pokemonSpecies = PokemonSpeciesConfig(
            description: findLastOccurrence(
                of: pokemon.name,
                in: pokemonDetail.flavorTextEntries.map { $0.flavorText }
            ) ?? "",
            eggGroups: pokemonDetail.eggGroups.map { $0.name }
        )
    }

    func findLastOccurrence(of name: String, in array: [String]) -> String? {
        let uppercasedName = name.uppercased()
        let filteredArray = array.filter { $0.contains(uppercasedName) }
        return removeNewLines(from: filteredArray.last ?? "")
    }

    func removeNewLines(from string: String) -> String {
        string.replacingOccurrences(of: "\n", with: "")
    }

    func showAlert() {
        alertConfig = AlertConfig(
            title: L.Errors.genericTitle,
            message: L.Errors.genericMessage
        )
    }
}
