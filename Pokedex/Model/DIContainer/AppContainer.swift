//
//  AppContainer.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 27.12.2024.
//

import Foundation
import Swinject

final class AppDIContainer {
    static let assembler = Assembler()

    static func resolveObject<T>(_ type: T.Type) -> T {
        guard let resolvedObject = assembler.resolver.resolve(type) else {
            fatalError("Could not resolve object type \(type)")
        }

        return resolvedObject
    }
}
