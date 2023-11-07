//
//  SceneDelegate.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.11.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let navigationController = MainCoordinator(
            apiClient: APIClient(),
            pokemonsDataRouter: PokemonsRouter()
        )
        self.window = window
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
