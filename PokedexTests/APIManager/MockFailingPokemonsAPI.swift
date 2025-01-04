//
//  MockFailingPokemonsAPI.swift
//  PokedexTests
//
//  Created by Anastasia Lenina on 04.01.2025.
//

import Foundation

final class MockFailingPokemonsAPI: PokemonServiceProtocol {
    func getPokemons(offset _: Int) async throws -> Pokemons {
        throw NetworkingError.genericError
    }

    func getPokemonDetail(name _: String) async throws -> PokemonDetail {
        throw NetworkingError.genericError
    }

    func getPokemonSpecies(name _: String) async throws -> PokemonSpecies {
        throw NetworkingError.genericError
    }

    func getPokemonForGeneration(generation _: Int) async throws -> PokemonsGeneration {
        throw NetworkingError.genericError
    }
}
