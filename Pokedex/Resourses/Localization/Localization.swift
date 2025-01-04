//
//  Localization.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.11.2023.
//

import Foundation

extension String {
    func localized(withStringValue stringValue: String) -> String {
        String(format: localized, stringValue)
    }

    func localized(withStringValues stringValues: [String]) -> String {
        String(format: localized, arguments: stringValues)
    }

    func localized(withComment comment: String = "") -> String {
        NSLocalizedString(self, comment: comment)
    }

    var localized: String {
        localized()
    }
}

enum LocalizedString {
    static let cancel = "cancel".localized

    enum Pokemons {
        static let pokemonsTitle = "pokemons_title".localized
    }

    enum PokemonDetail {
        static let height = "pokemon_detail_height".localized
        static let weight = "pokemon_detail_weight".localized
        static let breeding = "pokemon_detail_breeding".localized
        static let gender = "pokemon_detail_gender".localized
        static let eggGroups = "pokemon_detail_egg_groups".localized
        static let eggCylce = "pokemon_detail_egg_cycle".localized
        static let location = "pokemon_detail_location".localized
        static let training = "pokemon_detail_training".localized
        static let experience = "pokemon_detail_base_experience".localized
        static let steps = "pokemon_detail_steps".localized
        static let defaultString = "pokemon_detail_default_string".localized
    }

    enum Settings {
        static let favouritePokemon = "pokemon_settings_favourite".localized
        static let allType = "pokemon_settings_all_type".localized
        static let allGen = "pokemon_settings_all_gen".localized
        static let generationTitle = "pokemon_settings_generation_title".localized
    }

    enum Errors {
        static let genericTitle = "error_generic_title".localized
        static let genericMessage = "error_generic_message".localized
        static let invalidUrlTile = "invalid_url_title".localized
        static let invalidUrlMessage = "invalid_url_message".localized
        static let invalidDataTile = "invalid_data_title".localized
        static let invalidDataMessage = "invalid_data_message".localized
        static let invalidResponseTile = "invalid_response_title".localized
        static let invalidResponseMessage = "invalid_response_message".localized
        static let unknownTile = "unknown_title".localized
        static let unknownMessage = "unknown_message".localized
        static let unexpectedErrorOccurred = "an_unexpected_error_occurred_please_try_again_later".localized
    }

    enum InternetConnection {
        static let connectionError = "connect_error".localized
        static let title = "connection_title".localized
        static let description = "connection_description".localized
        static let tryAgain = "try_again".localized
        static let statusDescription = "status_description".localized
    }
}
