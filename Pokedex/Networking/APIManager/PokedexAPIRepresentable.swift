//
//  PokedexAPIRepresentable.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.01.2025.
//

import Foundation

protocol PokedexAPIRepresentable {
    var urlScheme: String { get }
    var urlHost: String { get }
    var urlPath: String { get }
}

struct PokedexAPI: PokedexAPIRepresentable {
    let urlScheme = "https"
    var urlHost: String {
        "pokeapi.co"
    }

    let urlPath = "/api"
}
