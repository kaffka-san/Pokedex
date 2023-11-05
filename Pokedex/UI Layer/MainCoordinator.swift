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
        let view = PokemonsView(
            viewModel: PokemonsViewModel(
                coordinator: self,
                pokemonsAPI: pokemonsAPI
            ),
            navigationPropagation: NavigationPropagation()
        )
        let viewController = HostingController(
            navigationPropagation: view.navigationPropagation
        ) { view }
        setViewControllers([viewController], animated: false)
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .always
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainCoordinator: PokemonsCoordinator {
    func goToDetailView() {}
}
