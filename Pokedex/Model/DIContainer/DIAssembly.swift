//
//  DIAssembly.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 27.12.2024.
//

import Foundation
import Swinject

final class DIAssembly: Assembly {
    func assemble(container: Container) {
        registerAPIManager(container: container)
        registerServices(container: container)
        registerManagers(container: container)
        registerViewModels(container: container)
    }
}

// MARK: API Manager
private extension DIAssembly {
    func registerAPIManager(container: Container) {
        container.register(APIManager.self) { resolver in
            APICommunication(reachability: resolver.resolve(ReachabilityManagerProtocol.self)!)
        }
    }
}

// MARK: - Services
private extension DIAssembly {
    func registerServices(container: Container) {
        // PokemonsService
        container.register(PokemonServiceProtocol.self) { resolver in
            PokemonService(apiManager: resolver.resolve(APIManager.self)!)
        }
    }
}

// MARK: - Managers
private extension DIAssembly {
    func registerManagers(container: Container) {
        // LocationManager
        container.register(LocationManagerProtocol.self) { _ in
            LocationManager()
        }

        // MapManager
        container.register(MapManagerProtocol.self) { _ in
            MapManager()
        }

        // ReachabilityManager
        container.register(ReachabilityManagerProtocol.self) { _ in
            ReachabilityManager()
        }

        // SoundManager
        container.register(SoundManagerProtocol.self) { _ in
            SoundManager()
        }
    }
}

// MARK: - View Models
private extension DIAssembly {
    func registerViewModels(container: Container) {
        // AllPokemonViewModel
        container.register(AllPokemonViewModel.self) { resolver in
            AllPokemonViewModel(pokemonService: resolver.resolve(PokemonServiceProtocol.self)!)
        }

        // PokemonDetailViewModel
        container.register(PokemonDetailViewModel.self) { resolver in
            PokemonDetailViewModel(
                locationManager: resolver.resolve(LocationManagerProtocol.self)!,
                soundManager: resolver.resolve(SoundManagerProtocol.self)!,
                pokemonService: resolver.resolve(PokemonServiceProtocol.self)!,
                mapManager: resolver.resolve(MapManagerProtocol.self)!
            )
        }
    }
}
