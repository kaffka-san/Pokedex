//
//  Localization.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.11.2023.
//

import Foundation

enum LocalizedString {
    static let cancel = R.string.localizable.cancel()

    enum Pokemons {
        static let title = R.string.localizable.pokemons_title()
    }

    enum PokemonDetail {
        static let height = R.string.localizable.pokemon_detail_height()
        static let weight = R.string.localizable.pokemon_detail_weight()
        static let breeding = R.string.localizable.pokemon_detail_breeding()
        static let gender = R.string.localizable.pokemon_detail_gender()
        static let eggGroups = R.string.localizable.pokemon_detail_egg_groups()
        static let eggCycle = R.string.localizable.pokemon_detail_egg_cycle()
        static let location = R.string.localizable.pokemon_detail_location()
        static let training = R.string.localizable.pokemon_detail_training()
        static let baseExperience = R.string.localizable.pokemon_detail_base_experience()
        static let steps = R.string.localizable.pokemon_detail_steps()
        static let defaultString = R.string.localizable.pokemon_detail_default_string()
    }

    enum Settings {
        static let favouritePokemon = R.string.localizable.pokemon_settings_favourite()
        static let allType = R.string.localizable.pokemon_settings_all_type()
        static let allGen = R.string.localizable.pokemon_settings_all_gen()
        static let generationTitle = R.string.localizable.pokemon_settings_generation_title()
    }

    enum Errors {
        static let genericTitle = R.string.localizable.error_generic_title()
        static let genericMessage = R.string.localizable.error_generic_message()
        static let invalidUrlTitle = R.string.localizable.invalid_url_title()
        static let invalidUrlMessage = R.string.localizable.invalid_url_message()
        static let invalidDataTitle = R.string.localizable.invalid_data_title()
        static let invalidDataMessage = R.string.localizable.invalid_data_message()
        static let invalidResponseTitle = R.string.localizable.invalid_response_title()
        static let invalidResponseMessage = R.string.localizable.invalid_response_message()
        static let unknownTitle = R.string.localizable.unknown_title()
        static let unknownMessage = R.string.localizable.unknown_message()
        static let unexpectedErrorOccurred = R.string.localizable.an_unexpected_error_occurred_please_try_again_later()
    }

    enum InternetConnection {
        static let connectionError = R.string.localizable.connect_error()
        static let title = R.string.localizable.connection_title()
        static let description = R.string.localizable.connection_description()
        static let tryAgain = R.string.localizable.try_again()
        static let statusDescription = R.string.localizable.status_description()
    }
}
