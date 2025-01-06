//
//  PokemonsService.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 27.12.2024.
//

import Combine
import Foundation

protocol PokemonServiceProtocol {
    func getPokemons(offset: Int) async throws -> Pokemons
    func getPokemonDetail(name: String) async throws -> PokemonDetail
    func getPokemonSpecies(name: String) async throws -> PokemonSpecies
    func getPokemonForGeneration(generation: Int) async throws -> PokemonsGeneration
}

final class PokemonService {
    private let apiManager: APIManager
    private let defaultItemsCount = 20
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }
}

extension PokemonService: PokemonServiceProtocol {
    func getPokemonDetail(name: String) async throws -> PokemonDetail {
        try await apiManager.request(request: PokemonsRouter.getPokemonDetail(name: name))
    }

    func getPokemonSpecies(name: String) async throws -> PokemonSpecies {
        try await apiManager.request(request: PokemonsRouter.getPokemonSpecies(name: name))
    }

    func getPokemonForGeneration(generation: Int) async throws -> PokemonsGeneration {
        try await apiManager.request(request: PokemonsRouter.getPokemonForGeneration(generation: generation))
    }

    func getPokemons(offset: Int) async throws -> Pokemons {
        try await apiManager.request(request: PokemonsRouter.getPokemons(offset: offset, itemsCount: defaultItemsCount))
    }
}
