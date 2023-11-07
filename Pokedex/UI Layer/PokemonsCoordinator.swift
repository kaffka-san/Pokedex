//
//  PokemonsCoordinator.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.11.2023.
//

import SwiftUI

protocol PokemonsCoordinator: AnyObject {
    func goToDetailView(
        pokemon: PokemonDetailConfig,
        favouriteIds: Binding<[Int]>
    )
    func goBack()
}
