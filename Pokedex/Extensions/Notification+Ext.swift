//
//  Notification+Ext.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 29.12.2024.
//

import Foundation

extension Notification.Name {
    static let updateFavouritePokemon = Notification.Name("pokedex/favourite/pokemon/update")
}

extension Notification {
    static let updateFavouritePokemon = Notification(name: .updateFavouritePokemon)
}
