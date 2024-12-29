//
//  PokemonDetailCoordinator.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 28.12.2024.
//

import UIKit

final class PokemonDetailCoordinator: Coordinator {
    private weak var navigationController: UINavigationController?
    private weak var presentedNavigationController: UINavigationController?
    private let pokemon: PokemonDetailConfig
    init(navigationController: UINavigationController?, pokemon: PokemonDetailConfig) {
        self.navigationController = navigationController
        self.pokemon = pokemon
    }
}

extension PokemonDetailCoordinator {
    func start() {
        let viewModel = AppDIContainer.resolveObject(PokemonDetailViewModel.self)
        viewModel.pokemon = pokemon
        let vc = PokemonDetailViewController()
        vc.viewModel = viewModel
        navigationController?.show(vc, sender: nil)
    }
}
