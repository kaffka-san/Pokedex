//
//  PokemonsRouter.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 27.12.2024.
//

import Foundation

enum PokemonsRouter: APIConvertible {
    case getPokemons(offset: Int, itemsCount: Int)
    case getPokemonDetail(name: String)
    case getPokemonSpecies(name: String)
    case getPokemonForGeneration(generation: Int)
}

extension PokemonsRouter {
    var path: String {
        switch self {
        case .getPokemons:
            return "pokemon"
        case let .getPokemonDetail(name):
            return "pokemon/\(name)"
        case let .getPokemonSpecies(name):
            return "pokemon-species/\(name)"
        case let .getPokemonForGeneration(generation: generation):
            return "generation/\(generation)"
        }
    }

    var parameters: [URLQueryItem]? {
        switch self {
        case let .getPokemons(offset, itemsCount):
            return [
                URLQueryItem(name: "limit", value: "\(itemsCount)"),
                URLQueryItem(name: "offset", value: "\(offset)")
            ]
        default:
            return nil
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .getPokemonDetail, .getPokemons, .getPokemonSpecies, .getPokemonForGeneration:
            return .get
        }
    }

    func createUrlRequest() throws -> URLRequest {
        guard var urlRequest = urlRequest else {
            throw NetworkingError.invalidUrlRequest
        }

        return urlRequest
    }
}
