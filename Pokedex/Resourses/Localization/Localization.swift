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
        static let experience = "pokemon_detail_base_experience".tr
        static let steps = "pokemon_detail_steps".tr
        static let defaultString = "pokemon_detail_default_string".tr
    }

    enum Settings {
        static let favouritePokemon = "pokemon_settings_favourite".tr
        static let allType = "pokemon_settings_all_type".tr
        static let allGen = "pokemon_settings_all_gen".tr
        static let generationTitle = "pokemon_settings_generation_title".tr
    }

    enum Errors {
        static let genericTitle = "error_generic_title".tr
        static let genericMessage = "error_generic_message".tr
        static let invalidUrlTile = "invalid_url_title".tr
        static let invalidUrlMessage = "invalid_url_message".tr
        static let invalidDataTile = "invalid_data_title".tr
        static let invalidDataMessage = "invalid_data_message".tr
        static let invalidResponseTile = "invalid_response_title".tr
        static let invalidResponseMessage = "invalid_response_message".tr
        static let unknownTile = "unknown_title".tr
        static let unknownMessage = "unknown_message".tr
    }
}
