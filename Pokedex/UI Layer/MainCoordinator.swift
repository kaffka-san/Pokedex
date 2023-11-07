//
//  MainCoordinator.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.11.2023.
//

import SwiftUI

class MainCoordinator: UINavigationController {
    private let apiClient: APIClient
    private let pokemonsAPI: PokemonsAPI
    private let pokemonsDataRouter: PokemonsRouter

    init(
        apiClient: APIClient,
        pokemonsDataRouter: PokemonsRouter
    ) {
        self.apiClient = apiClient
        self.pokemonsDataRouter = pokemonsDataRouter
        pokemonsAPI = PokemonsAPI(
            apiClient: apiClient,
            router: pokemonsDataRouter
        )

        super.init(nibName: nil, bundle: nil)

        let viewController = HostingController {
            PokemonsView(
                viewModel: PokemonsViewModel(
                    coordinator: self,
                    pokemonsAPI: pokemonsAPI
                )
            )
        }
        setViewControllers([viewController], animated: false)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainCoordinator: PokemonsCoordinator {
    func goBack() {
        popViewController(animated: true)
    }

    func goToDetailView(
        pokemon: PokemonDetailConfig,
        favouriteIds: Binding<Set<Int>>
    ) {
        let viewController = HostingController {
            PokemonDetailView(
                viewModel: PokemonDetailViewModel(
                    coordinator: self,
                    pokemonsAPI: pokemonsAPI,
                    pokemon: pokemon,
                    favouriteIds: favouriteIds
                )
            )
        }
        pushViewController(viewController, animated: true)
    }
}
