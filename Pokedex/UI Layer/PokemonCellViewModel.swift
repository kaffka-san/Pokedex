//
//  PokemonCellViewModel.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.11.2023.
//

import SwiftUI

struct PokemonDetailConfig {
    let id: Int
    let name: String
    let types: [String]
    let imgUrl: String
    let weight: String
    let height: String
    let baseExperience: String
    let gender: Gender

    init(name: String) {
        id = 0
        self.name = name
        types = []
        imgUrl = ""
        weight = ""
        height = ""
        baseExperience = ""
        gender = Gender(
            male: "",
            female: "",
            genderCase: .maleFemale
        )
    }

    init(
        id: Int,
        name: String,
        types: [String],
        imgUrl: String,
        weight: String,
        height: String,
        baseExperience: String,
        gender: Gender
    ) {
        self.id = id
        self.name = name
        self.types = types
        self.imgUrl = imgUrl
        self.weight = weight
        self.height = height
        self.baseExperience = baseExperience
        self.gender = gender
    }
}

final class PokemonCellViewModel: ObservableObject {
    private let pokemonsAPI: PokemonsAPIProtocol
    private weak var coordinator: PokemonsCoordinator?
    var idFormatted: String {
        String(format: "#%03d", pokemon.id)
    }

    var colorBackground: String {
        pokemon.types.first?.capitalized ?? "White"
    }

    @Published var pokemon: PokemonDetailConfig
    @Published var alertConfig: AlertConfig?
    @Published private(set) var progressHudState: ProgressHudState = .hide
    var task: Task<Void, Never>?

    init(
        name: String,
        pokemonsAPI: PokemonsAPIProtocol,
        coordinator: PokemonsCoordinator?
    ) {
        pokemon = PokemonDetailConfig(name: name)
        self.pokemonsAPI = pokemonsAPI
        self.coordinator = coordinator
        loadPokemon()
    }

    func loadPokemon() {
        task = Task { [weak self] in
            guard let self else { return }
            do {
                let pokemonDetail = try await pokemonsAPI.getPokemonDetail(name: pokemon.name)
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
            name: pokemon.name,
            types: pokemonDetail.types.map { $0.type.name },
            imgUrl: pokemonDetail.sprites.other?.officialArtwork.frontDefault ?? pokemonDetail.sprites.frontDefault,
            weight: convertToPoundsAndKilograms(pokemonDetail.weight),
            height: convertToFeetInchesAndCentimeters(pokemonDetail.height),
            baseExperience: "\(pokemonDetail.baseExperience)",
            gender: getPokemonGenderChance(femaleEighths: pokemonDetail.genderRate)
        )
    }

    func showAlert() {
        alertConfig = AlertConfig(
            title: L.Errors.genericTitle,
            message: L.Errors.genericMessage
        )
    }

    func convertToPoundsAndKilograms(_ value: Int) -> String {
        let weightInKilograms = Double(value) / 10.0
        let weightInPounds = weightInKilograms * 2.20462 // Convert kg to lbs

        // Format the string to have one decimal place for both kg and lbs
        let formattedWeightInKilograms = String(format: "%.1f kg", weightInKilograms)
        let formattedWeightInPounds = String(format: "%.1f lbs", weightInPounds)

        return "\(formattedWeightInPounds) (\(formattedWeightInKilograms))"
    }

    func getPokemonGenderChance(femaleEighths: Int) -> Gender {
        switch femaleEighths {
        case -1:
            return Gender(male: "", female: "", genderCase: .genderless)
        case 0:
            return Gender(male: "100%", female: "", genderCase: .male)
        case 8:
            return Gender(male: "", female: "100%", genderCase: .female)
        default:
            let femalePercentage = (femaleEighths * 100) / 8
            let malePercentage = 100 - femalePercentage
            return Gender(male: "\(malePercentage)%", female: "\(femalePercentage)%", genderCase: .maleFemale)
        }
    }

    func convertToFeetInchesAndCentimeters(_ decimeters: Int) -> String {
        // Conversion constants
        let centimetersPerDecimeter = 10.0
        let centimetersPerInch = 2.54
        let inchesPerFoot = 12.0

        // Convert decimeters to centimeters
        let centimeters = Double(decimeters) * centimetersPerDecimeter

        // Convert centimeters to inches
        let totalInches = centimeters / centimetersPerInch

        // Calculate feet and inches
        let feet = Int(totalInches / inchesPerFoot)
        let inches = totalInches.truncatingRemainder(dividingBy: inchesPerFoot)

        // Format the string to have one decimal place for inches
        // and no decimal places for centimeters as they're typically represented as a whole number
        let formattedHeightInFeetAndInches = "\(feet)'\(String(format: "%.1f", inches))\""
        let formattedHeightInCentimeters = String(format: "%.0f cm", centimeters)

        return "\(formattedHeightInFeetAndInches) (\(formattedHeightInCentimeters))"
    }
}

struct Gender {
    let male: String
    let female: String
    let genderless = "Genderless"
    let genderCase: GenderCase
}

enum GenderCase {
    case genderless
    case male
    case female
    case maleFemale
}
