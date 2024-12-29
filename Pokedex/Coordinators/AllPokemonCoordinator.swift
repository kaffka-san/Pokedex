//
//  AllPokemonCoordinator.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 28.12.2024.
//

import UIKit

final class AllPokemonCoordinator: Coordinator {
    private weak var navigationController: UINavigationController?
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }
}

extension AllPokemonCoordinator {
    func start() {
        let viewModel = AppDIContainer.resolveObject(AllPokemonViewModel.self)
        viewModel.coordinator = self

        let vc = AllPokemonViewController()
        vc.viewModel = viewModel

        let navVc = UINavigationController(rootViewController: vc)
        navigationController = navVc
        window.rootViewController = navVc
    }
}

extension AllPokemonCoordinator: AllPokemonFlow {
    func showDetail(pokemon: PokemonDetailConfig) {
        let coordinator = PokemonDetailCoordinator(navigationController: navigationController, pokemon: pokemon)
        coordinate(to: coordinator)
        print("show detail coordinator")
    }
}

protocol AllPokemonFlow {
    func showDetail(pokemon: PokemonDetailConfig)
}
