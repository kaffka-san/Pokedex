//
//  PokemonConfig.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 06.11.2023.
//

import Foundation

struct PokemonDetailConfig {
    let id: Int
    let url: String
    let name: String
    let types: [String]
    let imgUrl: String
    let weight: String
    let height: String
    let baseExperience: String

    init(name: String, url: String) {
        id = 0
        self.url = url
        self.name = name
        types = []
        imgUrl = ""
        weight = ""
        height = ""
        baseExperience = ""
    }

    init(
        id: Int,
        url: String,
        name: String,
        types: [String],
        imgUrl: String,
        weight: String,
        height: String,
        baseExperience: String
    ) {
        self.id = id
        self.url = url
        self.name = name
        self.types = types
        self.imgUrl = imgUrl
        self.weight = weight
        self.height = height
        self.baseExperience = baseExperience
    }

    init(pokemonDetail: PokemonDetail, url: String, baseExperience: String) {
        id = pokemonDetail.id
        self.url = url
        name = pokemonDetail.name
        types = pokemonDetail.types.map { $0.type.name }
        imgUrl = pokemonDetail.sprites.other?.officialArtwork.frontDefault ?? pokemonDetail.sprites.frontDefault ?? ""
        weight = PokemonConversionsUtils.convertToPoundsAndKilograms(pokemonDetail.weight)
        height = PokemonConversionsUtils.convertToFeetInchesAndCentimeters(pokemonDetail.height)
        self.baseExperience = baseExperience
    }
}

struct PokemonSpeciesConfig {
    let description: String
    let eggGroups: [String]
    let gender: Gender
    let hatchCounter: String
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

struct PokemonInfo {
    let sections: [PokemonSection]
}

struct PokemonSection {
    let sectionHeader: String
    let items: [Item]
}

struct Item {
    let title: String
    let value: String
}

extension PokemonSpeciesConfig {
    init(pokemonSpecies: PokemonSpecies, pokemonName: String) {
        description = pokemonSpecies.flavorTextEntries.map { $0.flavorText }.findLastOccurrence(of: pokemonName)
        eggGroups = pokemonSpecies.eggGroups.map { $0.name }
        gender = PokemonConversionsUtils.getPokemonGenderChance(index: pokemonSpecies.genderRate)
        hatchCounter = PokemonConversionsUtils.calculateHatchingSteps(initialHatchCounter: pokemonSpecies.hatchCounter)
    }
}
