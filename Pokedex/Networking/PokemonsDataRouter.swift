//
//  PokemonsDataRouter.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.11.2023.
//

import Foundation

enum PokemonsRoute {
    case pokemons
    case pokemonDetail(name: String)
}

final class PokemonsRouter: Router, APIRouter {
    typealias Route = PokemonsRoute
    private let encoder = JSONEncoder()

    func urlRequest(for route: PokemonsRoute) -> URLRequestConvertible {
        switch route {
        case .pokemons:
            return buildRequest(
                method: .get,
                url: "\(baseURL)/pokemon?limit=248&offset=0",
                headers: [
                    "Content-Type": "application/json",
                    "accept": "application/json"
                ],
                body: { nil }
            )
        case let .pokemonDetail(name):
            return buildRequest(
                method: .get,
                url: "\(baseURL)/pokemon/\(name)",
                headers: [
                    "Content-Type": "application/json",
                    "accept": "application/json"
                ],
                body: { nil }
            )
        }
    }
}
