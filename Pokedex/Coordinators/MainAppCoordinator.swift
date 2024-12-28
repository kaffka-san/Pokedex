//
//  MainAppCoordinator.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 28.12.2024.
//

import Combine
import UIKit

final class MainAppCoordinator: Coordinator {
    private weak var navigationController: UINavigationController?
    private let window: UIWindow
    private var disposeBag = Set<AnyCancellable>()

    init(window: UIWindow) {
        self.window = window
    }
}

extension MainAppCoordinator {
    func start() {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.backgroundColor = UIColor.black
        window.makeKeyAndVisible()
        self.navigationController = navigationController

        let startCoordinator = AllPokemonCoordinator(window: window)
        coordinate(to: startCoordinator)
    }
}
