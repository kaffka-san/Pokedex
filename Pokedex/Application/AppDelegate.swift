//
//  AppDelegate.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.11.2023.
//

import BackgroundTasks
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, open _: URL, options _: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        true
    }
}
