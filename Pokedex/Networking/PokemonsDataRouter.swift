//
//  PokemonsDataRouter.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.11.2023.
//

import Foundation

enum PokemonsRoute {
    case pokemons(offset: Int)
    case pokemonDetail(name: String)
    case pokemonSpecies(name: String)
    case pokemonsForGeneration(generation: Int)
}

final class PokemonsRouter: Router, APIRouter {
    private let headers = [
        "Content-Type": "application/json",
        "accept": "application/json"
    ]

    func urlRequest(for route: PokemonsRoute) -> URLRequestConvertible {
        switch route {
        case let .pokemons(offset):
            return buildRequest(
                method: .get,
                url: "\(baseURL)/pokemon?limit=20&offset=\(offset)",
                headers: headers,
                body: { nil }
            )
        case let .pokemonDetail(name):
            return buildRequest(
                method: .get,
                url: "\(baseURL)/pokemon/\(name)",
                headers: headers,
                body: { nil }
            )
        case let .pokemonSpecies(name):
            return buildRequest(
                method: .get,
                url: "\(baseURL)/pokemon-species/\(name)",
                headers: headers,
                body: { nil }
            )
        case let .pokemonsForGeneration(generation: generation):
            return buildRequest(
                method: .get,
                url: "\(baseURL)/generation/\(generation)",
                headers: headers,
                body: { nil }
            )
        }
    }
}
