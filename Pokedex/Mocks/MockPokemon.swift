//
//  MockPokemon.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 09.11.2023.
//

import SwiftUI

enum MockPokemonDetailConfig {
    static let pokemon = PokemonDetailConfig(
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
}
