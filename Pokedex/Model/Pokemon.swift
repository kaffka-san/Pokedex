//
//  Pokemon.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.11.2023.
//

import Foundation

struct Pokemons: Decodable {
    let count: Int
    let next: String
    let results: [Pokemon]
}

struct Pokemon: Decodable, Equatable {
    let name: String
    let url: String

    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        lhs.id == rhs.id
    }
}

struct PokemonDetail: Decodable {
    let id: Int
    let height: Int
    let weight: Int
    let baseExperience: Int?
    let types: [PokemonTypes]
    let sprites: Sprites
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case height
        case weight
        case baseExperience = "base_experience"
        case name
        case types
        case sprites
    }

    init(
        id: Int = 0,
        height: Int = 0,
        weight: Int = 0,
        baseExperience: Int? = nil,
        types: [PokemonTypes] = [],
        sprites: Sprites = Sprites(
            frontDefault: "",
            other: nil
        ),
        name: String = ""
    ) {
        self.id = id
        self.height = height
        self.weight = weight
        self.baseExperience = baseExperience
        self.types = types
        self.sprites = sprites
        self.name = name
    }
}

struct PokemonTypes: Decodable {
    let type: SpecificType
}

struct SpecificType: Decodable {
    let name: String
}

struct Sprites: Decodable {
    let frontDefault: String?
    let other: Other?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case other
    }
}

struct Other: Decodable {
    let officialArtwork: OfficialArtwork

    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct OfficialArtwork: Decodable {
    let frontDefault: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct PokemonSpecies: Decodable {
    let eggGroups: [SpecificType]
    let flavorTextEntries: [FlavorTextEntry]
    let genderRate: Int
    let hatchCounter: Int?

    enum CodingKeys: String, CodingKey {
        case eggGroups = "egg_groups"
        case flavorTextEntries = "flavor_text_entries"
        case genderRate = "gender_rate"
        case hatchCounter = "hatch_counter"
    }
}

struct FlavorTextEntry: Decodable {
    let flavorText: String

    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
    }
}

struct PokemonsGeneration: Decodable {
    let id: Int
    let pokemonSpecies: [Pokemon]

    enum CodingKeys: String, CodingKey {
        case id
        case pokemonSpecies = "pokemon_species"
    }
}

extension PokemonDetail {
    var idFormatted: String {
        String(format: "#%03d", id)
    }
}

extension Pokemon: Identifiable {
    var id: Int {
        guard let url = URL(string: url) else { return -1 }
        return Int(url.lastPathComponent) ?? -1
    }
}

extension PokemonTypes: Identifiable {
    var id: UUID {
        UUID()
    }
}
