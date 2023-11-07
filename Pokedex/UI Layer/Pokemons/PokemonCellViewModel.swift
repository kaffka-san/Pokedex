//
//  PokemonCellViewModel.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.11.2023.
//

import SwiftUI

final class PokemonCellViewModel: ObservableObject {
    private let pokemonsAPI: PokemonsAPIProtocol
    private weak var coordinator: PokemonsCoordinator?
    var idFormatted: String {
        String(format: "#%03d", pokemon.id)
    }

    var colorBackground: String {
        pokemon.types.first?.capitalized ?? Constants.neutralBackground
    }

    @Published var pokemon: PokemonDetailConfig
    @Published var alertConfig: AlertConfig?
    @Published private(set) var progressHudState: ProgressHudState = .hide
    var task: Task<Void, Never>?

    init(
        name: String,
        url: String,
        pokemonsAPI: PokemonsAPIProtocol,
        coordinator: PokemonsCoordinator?
    ) {
        pokemon = PokemonDetailConfig(name: name, url: url)
        self.pokemonsAPI = pokemonsAPI
        self.coordinator = coordinator
        loadPokemon()
    }

    func loadPokemon() {
        task = Task { [weak self] in
            guard let self else { return }
            do {
                let pokemonDetail = try await pokemonsAPI.getPokemonDetail(name: extractNumberFromPokemonURL(pokemon.url))
                await self.update(pokemonDetail: pokemonDetail)
            } catch {
                print(error)
                await MainActor.run {
                    self.showAlert()
                }
            }
        }
    }

    func goToDetailView() {
        coordinator?.goToDetailView(pokemon: pokemon)
    }

    func onDisappear() {
        task?.cancel()
    }

    @MainActor
    private func update(pokemonDetail: PokemonDetail) {
        pokemon = PokemonDetailConfig(
            id: pokemonDetail.id,
            url: pokemon.url,
            name: pokemon.name,
            types: pokemonDetail.types.map { $0.type.name },
            imgUrl: pokemonDetail.sprites.other?.officialArtwork.frontDefault ?? pokemonDetail.sprites.frontDefault ?? "",
            weight: convertToPoundsAndKilograms(pokemonDetail.weight),
            height: convertToFeetInchesAndCentimeters(pokemonDetail.height),
            baseExperience: describeValue(pokemonDetail.baseExperience)
        )
    }

    func showAlert() {
        alertConfig = AlertConfig(
            title: L.Errors.genericTitle,
            message: L.Errors.genericMessage
        )
    }

    func describeValue(_ value: Int?) -> String {
        guard let intValue = value else {
            return L.PokemonDetail.defaultString
        }
        return "\(intValue)"
    }

    func convertToPoundsAndKilograms(_ value: Int) -> String {
        let weightInKilograms = Double(value) / 10.0
        let weightInPounds = weightInKilograms * 2.20462 // Convert kg to lbs
        let formattedWeightInKilograms = String(format: "%.1f kg", weightInKilograms)
        let formattedWeightInPounds = String(format: "%.1f lbs", weightInPounds)

        return "\(formattedWeightInPounds) (\(formattedWeightInKilograms))"
    }

    func convertToFeetInchesAndCentimeters(_ decimeters: Int) -> String {
        let centimetersPerDecimeter = 10.0
        let centimetersPerInch = 2.54
        let inchesPerFoot = 12.0
        // Convert decimeters to centimeters
        let centimeters = Double(decimeters) * centimetersPerDecimeter
        // Convert centimeters to inches
        let totalInches = centimeters / centimetersPerInch
        // Calculate feet and the remaining inches
        let feet = Int(totalInches / inchesPerFoot)
        let inches = totalInches.truncatingRemainder(dividingBy: inchesPerFoot)
        // Format the height in feet and inches
        let formattedHeightInFeetAndInches = "\(feet)'\(String(format: "%.1f", inches))\""
        // Format the height in centimeters
        let formattedHeightInCentimeters = String(format: "%.0f cm", centimeters)
        return "\(formattedHeightInFeetAndInches) (\(formattedHeightInCentimeters))"
    }

    // Get id from the url
    func extractNumberFromPokemonURL(_ urlString: String) -> String {
        guard let url = URL(string: urlString) else { return "" }
        return url.lastPathComponent
    }
}
