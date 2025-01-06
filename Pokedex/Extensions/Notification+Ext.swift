//
//  Notification+Ext.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 29.12.2024.
//

import Foundation

extension Notification.Name {
    /// A notification name for updating the favorite Pokémon in the app.
    static let updateFavouritePokemon = Notification.Name("pokedex/favourite/pokemon/update")
}

extension Notification {
    /// A pre-configured notification instance for updating the favorite Pokémon.
    static let updateFavouritePokemon = Notification(name: .updateFavouritePokemon)
}
