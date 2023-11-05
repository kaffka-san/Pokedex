//
//  Pokemon.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.11.2023.
//

import Foundation

struct Pokemons: Codable {
    let count: Int
    let next: String
    let results: [Pokemon]
}

struct Pokemon: Codable, Identifiable, Equatable {
    let id = UUID()
    let name: String
    let url: String

    static var samplePokemon = Pokemon(
        name: "charmander",
        url: "https://pokeapi.co/api/v2/pokemon/4/"
    )
    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        lhs.id == rhs.id
    }
}

struct PokemonDetail: Codable {
    let id: Int
    let height: Int
    let weight: Int
    let baseExperience: Int
    let stats: [PokemonStats]
    let types: [PokemonTypes]
    let sprites: Sprites

    enum CodingKeys: String, CodingKey {
        case id
        case height
        case weight
        case baseExperience = "base_experience"
        case stats
        case types
        case sprites
    }
}

struct PokemonStats: Codable {
    let base_stat: Int
    let effort: Int
    let stat: SpecificStat
}

struct SpecificStat: Codable {
    let name: String
    let url: String
}

struct PokemonTypes: Codable {
    let slot: Int
    let type: SpecificType
}

struct SpecificType: Codable {
    let name: String
    let url: String
}

class Sprites: Codable {
    let frontDefault: String
    let other: Other?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case other
    }
}

// MARK: - Other
struct Other: Codable {
    let officialArtwork: OfficialArtwork

    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

// MARK: - OfficialArtwork
struct OfficialArtwork: Codable {
    let frontDefault: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct PokemonSpecies: Codable {
    let eggGroups: [SpecificType]
    let flavorTextEntries: [FlavorTextEntry]

    enum CodingKeys: String, CodingKey {
        case eggGroups = "egg_groups"
        case flavorTextEntries = "flavor_text_entries"
    }
}

// MARK: - FlavorTextEntry
struct FlavorTextEntry: Codable {
    let flavorText: String

    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
    }
}
