//
//  Coordinator.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 28.12.2024.
//

import Foundation

protocol Coordinator {
    func start()
    func coordinate(to coordinator: Coordinator)
}

extension Coordinator {
    func coordinate(to coordinator: Coordinator) {
        coordinator.start()
    }
}
