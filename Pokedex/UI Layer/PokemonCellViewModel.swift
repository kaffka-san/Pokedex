//
//  PokemonCellViewModel.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.11.2023.
//

import SwiftUI

final class PokemonCellViewModel: ObservableObject {
    private let name: String
    private let pokemonsAPI: PokemonsAPIProtocol
    var id: String {
        String(format: "#%03d", pokemon.id)
    }

    var colorBackground: String {
        pokemon.types.first!.capitalized
    }

    // TODO: create empty mock
    @Published var pokemon = PokemonCellConfig(id: 0, name: "", types: ["", ""], imgUrl: "")
    @Published var alertConfig: AlertConfig?
    @Published private(set) var progressHudState: ProgressHudState = .hide

    init(
        name: String,
        pokemonsAPI: PokemonsAPIProtocol
    ) {
        self.name = name
        self.pokemonsAPI = pokemonsAPI
        loadPokemon()
    }

    func loadPokemon() {
        Task { [weak self] in
            guard let self else { return }
            await MainActor.run {
                defer {
                    self.progressHudState = .hide
                }
                self.progressHudState = .showProgress
            }
            do {
                let pokemonDetail = try await pokemonsAPI.getPokemonDetail(name: name)
                await self.update(pokemonDetail: pokemonDetail)
            } catch {
                print(error)
                await MainActor.run {
                    self.showAlert()
                }
            }
        }
    }

    @MainActor
    private func update(pokemonDetail: PokemonDetail) {
        pokemon = PokemonCellConfig(
            id: pokemonDetail.id,
            name: name,
            types: pokemonDetail.types.map { $0.type.name },
            imgUrl: pokemonDetail.sprites.other?.officialArtwork.frontDefault ?? pokemonDetail.sprites.frontDefault
        )
    }

    func showAlert() {
        alertConfig = AlertConfig(
            title: L.Errors.genericTitle,
            message: L.Errors.genericMessage
        )
    }
}
