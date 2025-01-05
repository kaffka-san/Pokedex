//
//  PokemonDetailSection.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.01.2025.
//

import Foundation

enum PokemonDetailSection: CaseIterable, Identifiable {
    case breeding
    case training
    case location

    var title: String {
        switch self {
        case .breeding: return LocalizedString.PokemonDetail.breeding
        case .training: return LocalizedString.PokemonDetail.training
        case .location: return LocalizedString.PokemonDetail.location
        }
    }

    var id: String { title }

    var items: [PokemonDetailItem] {
        switch self {
        case .breeding: return PokemonDetailBreeding.allCases
        case .training: return PokemonDetailTraining.allCases
        case .location: return PokemonDetailLocation.allCases
        }
    }
}

protocol PokemonDetailItem {
    var title: String { get }
    func description(using pokemon: PokemonDetailConfig, species: PokemonSpeciesConfig) -> String
    var id: String { get }
    var itemType: ItemType { get }
}

enum ItemType: Equatable {
    case breeding(PokemonDetailBreeding)
    case training(PokemonDetailTraining)
    case location(PokemonDetailLocation)

    static func == (lhs: ItemType, rhs: ItemType) -> Bool {
        switch (lhs, rhs) {
        case let (.breeding(lhsItem), .breeding(rhsItem)):
            return lhsItem.id == rhsItem.id
        case let (.training(lhsItem), .training(rhsItem)):
            return lhsItem.id == rhsItem.id
        case let (.location(lhsItem), .location(rhsItem)):
            return lhsItem.id == rhsItem.id
        default:
            return false
        }
    }
}

enum PokemonDetailBreeding: Identifiable, CaseIterable, PokemonDetailItem {
    case gender
    case eggGroup
    case eggCycle

    var title: String {
        switch self {
        case .gender: return LocalizedString.PokemonDetail.gender
        case .eggGroup: return LocalizedString.PokemonDetail.eggGroups
        case .eggCycle: return LocalizedString.PokemonDetail.eggCycle
        }
    }

    var itemType: ItemType {
        .breeding(self)
    }

    var id: String { title }

    func description(using _: PokemonDetailConfig, species: PokemonSpeciesConfig) -> String {
        switch self {
        case .gender:
            return ""
        case .eggGroup:
            return species.eggGroups.first ?? ""
        case .eggCycle:
            return species.hatchCounter
        }
    }
}

enum PokemonDetailTraining: String, CaseIterable, PokemonDetailItem {
    case baseExp

    var title: String {
        switch self {
        case .baseExp: return LocalizedString.PokemonDetail.baseExperience
        }
    }

    var id: String {
        title
    }

    var itemType: ItemType {
        .training(self)
    }

    func description(using pokemon: PokemonDetailConfig, species _: PokemonSpeciesConfig) -> String {
        pokemon.baseExperience
    }
}

enum PokemonDetailLocation: CaseIterable, PokemonDetailItem {
    var title: String {
        ""
    }

    var id: String {
        title
    }

    var itemType: ItemType {
        .location(self)
    }

    func description(using _: PokemonDetailConfig, species _: PokemonSpeciesConfig) -> String {
        ""
    }
}
