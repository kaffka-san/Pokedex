//
//  Localization.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.11.2023.
//

import Foundation

typealias L = LocalizedString

extension String {
    var tr: String { tr() }

    private func tr(_ stringValue: String) -> String {
        String(format: tr, stringValue)
    }

    func tr(_ stringValues: [String]) -> String {
        String(format: tr, arguments: stringValues)
    }

    func tr(_ intValue: Int) -> String {
        String(format: tr, intValue)
    }

    func tr(_ intValues: [Int]) -> String {
        String(format: tr, arguments: intValues)
    }

    func tr(withComment comment: String = "") -> String {
        NSLocalizedString(self, comment: comment)
    }
}

enum LocalizedString {
    enum Pokemons {
        static let pokemonsTitle = "pokemons_title".tr
    }

    enum PokemonDetail {
        static let height = "pokemon_detail_height".tr
        static let weight = "pokemon_detail_weight".tr
        static let breeding = "pokemon_detail_breeding".tr
        static let gender = "pokemon_detail_gender".tr
        static let eggGroups = "pokemon_detail_egg_groups".tr
        static let eggCylce = "pokemon_detail_egg_cycle".tr
        static let location = "pokemon_detail_location".tr
        static let training = "pokemon_detail_training".tr
    }

    enum Errors {
        static let genericTitle = "error_generic_title".tr
        static let genericMessage = "error_generic_message".tr
    }
}
