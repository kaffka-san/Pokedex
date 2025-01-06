//
//  PokemonGeneration.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 10.11.2023.
//

import Foundation

enum PokemonGeneration: String, CaseIterable {
    case one = "I"
    case two = "II"
    case three = "III"
    case four = "IV"
    case five = "V"
    case six = "VI"
    case seven = "VII"
    case eight = "VIII"

    var index: Int {
        switch self {
        case .one:
            return 1
        case .two:
            return 2
        case .three:
            return 3
        case .four:
            return 4
        case .five:
            return 5
        case .six:
            return 6
        case .seven:
            return 7
        case .eight:
            return 8
        }
    }

    var image: ImageName {
        switch self {
        case .one:
            .generation1
        case .two:
            .generation2
        case .three:
            .generation3
        case .four:
            .generation4
        case .five:
            .generation5
        case .six:
            .generation6
        case .seven:
            .generation7
        case .eight:
            .generation8
        }
    }
}
