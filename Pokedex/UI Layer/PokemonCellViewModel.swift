//
//  PokemonCellViewModel.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.11.2023.
//

import SwiftUI

struct PokemonCellConfig {
    let id: Int
    let name: String
    let types: [String]
    let imgUrl: String
    let selectedAction: () -> Void
}

final class PokemonCellViewModel: ObservableObject {
    private let pokemonsAPI: PokemonsAPIProtocol
    var idFormatted: String {
        String(format: "#%03d", id)
    }

    var colorBackground: String {
        types.first?.capitalized ?? "white"
    }

    @Published var id: Int
    @Published var name: String
    @Published var types: [String]
    @Published var imgUrl: String
    @Published var selectedAction: () -> Void
    @Published var alertConfig: AlertConfig?
    @Published private(set) var progressHudState: ProgressHudState = .hide

    init(
        id: Int,
        name: String,
        types: [String],
        imgUrl: String,
        selectedAction: @escaping () -> Void,
        pokemonsAPI: PokemonsAPIProtocol
    ) {
        self.id = id
        self.name = name
        self.types = types
        self.imgUrl = imgUrl
        self.selectedAction = selectedAction
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
        id = pokemonDetail.id
        name = name
        types = pokemonDetail.types.map { $0.type.name }
        imgUrl = pokemonDetail.sprites.other?.officialArtwork.frontDefault ?? pokemonDetail.sprites.frontDefault
    }

    func showAlert() {
        alertConfig = AlertConfig(
            title: L.Errors.genericTitle,
            message: L.Errors.genericMessage
        )
    }
}
