//
//  Sequence+Ext.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.01.2025.
//

import Foundation

extension Sequence where Element: Sendable & Hashable {
    func asyncMap<T>(_ transform: (Element) async throws -> T) async rethrows -> [T] {
        var results = [T]()
        for element in self {
            try results.append(await transform(element))
        }
        return results
    }
}
