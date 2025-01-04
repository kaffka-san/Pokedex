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
        weight: "69",
        height: "7",
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

    static let emptyPokemonSpecies = PokemonSpeciesConfig(
        description: "",
        eggGroups: [],
        gender: Gender(
            male: "",
            female: "",
            genderCase: .genderless
        ),
        hatchCounter: ""
    )

    static let pokemon = Pokemon(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")
}
