//
//  PokemonsAPI.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.11.2023.
//

import Foundation

protocol PokemonsAPIProtocol {
    func getPokemons(offset: Int) async throws -> Pokemons
    func getPokemonDetail(name: String) async throws -> PokemonDetail
}

class PokemonsAPI: PokemonsAPIProtocol, Service {
    typealias Route = PokemonsRoute

    private let apiClient: APIClient
    let router: any Router<PokemonsRoute>

    init(
        apiClient: APIClient,
        router: any Router<PokemonsRoute>
    ) {
        self.apiClient = apiClient
        self.router = router
    }

    func getPokemons(offset: Int) async throws -> Pokemons {
        let route = PokemonsRoute.pokemons(offset: offset)
        return try await apiClient.requestDecodable(
            for: urlConvertible(for: route)
        )
    }

    func getPokemonDetail(name: String) async throws -> PokemonDetail {
        let route = PokemonsRoute.pokemonDetail(name: name)
        return try await apiClient.requestDecodable(
            for: urlConvertible(for: route)
        )
    }
}
