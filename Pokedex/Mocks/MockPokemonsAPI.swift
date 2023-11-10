//
//  MockPokemonsAPI.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 08.11.2023.
//

import Foundation

final class MockPokemonsAPI: PokemonsAPIProtocol {
    func getPokemons(offset _: Int) async throws -> Pokemons {
        Pokemons(
            count: 1,
            next: "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20",
            results: [
                Pokemon(
                    name: "bulbasaur",
                    url: "https://pokeapi.co/api/v2/pokemon/1/"
                ),
                Pokemon(
                    name: "ivysaur",
                    url: "https://pokeapi.co/api/v2/pokemon/2/"
                )
            ]
        )
    }

    func getPokemonDetail(name _: String) async throws -> PokemonDetail {
        PokemonDetail(
            id: 1,
            height: 7,
            weight: 69,
            baseExperience: 64,
            types: [
                PokemonTypes(type: SpecificType(name: "grass")),
                PokemonTypes(type: SpecificType(name: "poison"))
            ],
            sprites: Sprites(
                frontDefault: "",
                other: Other(
                    officialArtwork: OfficialArtwork(
                        frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"
                    )
                )
            ),
            name: "bulbasaur"
        )
    }

    func getPokemonSpecies(name _: String) async throws -> PokemonSpecies {
        PokemonSpecies(
            eggGroups: [
                SpecificType(name: "monster")
            ],
            flavorTextEntries: [
                FlavorTextEntry(flavorText: "BULBASAUR can be seen napping in\nbright sunlight.\nThere is a seed on its back."),
                FlavorTextEntry(flavorText: "While it is young,\nit uses the\nnutrients that are stored in the\nseeds on its back\nin order to grow.")
            ],
            genderRate: 1,
            hatchCounter: 20
        )
    }

    func getPokemonForGeneration(generation _: Int) async throws -> PokemonsGeneration {
        PokemonsGeneration(
            id: 1,
            pokemonSpecies: [
                Pokemon(
                    name: "bulbasaur",
                    url: "https://pokeapi.co/api/v2/pokemon/1/"
                ),
                Pokemon(
                    name: "charmander",
                    url: "https://pokeapi.co/api/v2/pokemon/4/"
                )
            ]
        )
    }
}

final class MockFailingPokemonsAPI: PokemonsAPIProtocol {
    func getPokemons(offset _: Int) async throws -> Pokemons {
        throw APIError.genericError
    }

    func getPokemonDetail(name _: String) async throws -> PokemonDetail {
        throw APIError.genericError
    }

    func getPokemonSpecies(name _: String) async throws -> PokemonSpecies {
        throw APIError.genericError
    }

    func getPokemonForGeneration(generation _: Int) async throws -> PokemonsGeneration {
        throw APIError.genericError
    }
}
