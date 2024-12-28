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
        container.register(APIManager.self) { _ in
            APICommunication()
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
    func registerManagers(container _: Container) {
        // Notification Manager
//        container.register(NotificationManagerProtocol.self) { resolver in
//            NotificationManager()
//        }
    }
}

// MARK: - View Models
private extension DIAssembly {
    func registerViewModels(container: Container) {
        // AllPokemonViewModel
        container.register(AllPokemonViewModel.self) { resolver in
            AllPokemonViewModel(pokemonService: resolver.resolve(PokemonServiceProtocol.self)!)
        }
    }
}
