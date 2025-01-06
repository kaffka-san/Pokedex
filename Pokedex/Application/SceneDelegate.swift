//
//  SceneDelegate.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.11.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var mainAppCoordinator: Coordinator!

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window

        // Dependency injection
        AppDIContainer.assembler.apply(assemblies: [DIAssembly()])

        mainAppCoordinator = MainAppCoordinator(window: window)
        mainAppCoordinator.start()
    }
}
