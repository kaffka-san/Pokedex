//
//  MockPokemon.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 09.11.2023.
//

import SwiftUI

enum MockPokemon {
    static let pokemonDetailConfig = PokemonDetailConfig(
        id: 1,
        url: "https://pokeapi.co/api/v2/pokemon/1/",
        name: "bulbasaur",
        types: [
            "Grass",
            "Poison"
        ],
        imgUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png",
        weight: "13.2 lbs (6.9 kg)",
        height: "1' 04 (0.70 cm)",
        baseExperience: "64"
    )

    static let pokemonDetailConfig2 = PokemonDetailConfig(
        id: 2,
        url: "https://pokeapi.co/api/v2/pokemon-form/2/",
        name: "ivysaur",
        types: [
            "Grass",
            "Poison"
        ],
        imgUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/2.png",
        weight: "130",
        height: "10",
        baseExperience: "142"
    )

    static let emptyPokemonSpeciesConfig = PokemonSpeciesConfig(
        description: "",
        eggGroups: [],
        gender: Gender(
            male: "",
            female: "",
            genderCase: .genderless
        ),
        hatchCounter: ""
    )

    static let pokemonSpeciesConfig = PokemonSpeciesConfig(
        description: "A strange seed was planted on its back at birth. The plant sprouts and grows with this Pokémon.",
        eggGroups: ["Monster", "Grass"],
        gender: Gender(
            male: "87.5%",
            female: "12.5%",
            genderCase: .maleFemale
        ),
        hatchCounter: "20"
    )

    static let pokemonSpecies = PokemonSpecies(
        eggGroups: [
            SpecificType(name: "Monster"),
            SpecificType(name: "Grass")
        ],
        flavorTextEntries: [
            FlavorTextEntry(
                flavorText: "BULBASAUR can be seen napping in\nbright sunlight.\nThere is a seed on its back.By soaking up the sun’s rays, the seed\ngrows progressively larger."
            )
        ],
        genderRate: 1, // Gender rate: 1 -> 12.5% female (8 - genderRate) / 8
        hatchCounter: 20 // Number of cycles needed to hatch
    )

    static let mockGeneration = PokemonsGeneration(
        id: 1,
        pokemonSpecies: [
            Pokemon(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon-species/1/"),
            Pokemon(name: "ivysaur", url: "https://pokeapi.co/api/v2/pokemon-species/2/"),
            Pokemon(name: "venusaur", url: "https://pokeapi.co/api/v2/pokemon-species/3/")
        ]
    )

    static let pokemonDetail = PokemonDetail(
        id: 1,
        height: 7, // Height in decimeters (0.7 meters)
        weight: 69, // Weight in hectograms (6.9 kilograms)
        baseExperience: 64, // Base experience yield
        types: [
            PokemonTypes(type: SpecificType(name: "grass")),
            PokemonTypes(type: SpecificType(name: "poison"))
        ],
        sprites: Sprites(
            frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
            other: Other(officialArtwork: OfficialArtwork(frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"))
        ),
        name: "bulbasaur"
    )

    static let pokemon = Pokemon(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")
}
