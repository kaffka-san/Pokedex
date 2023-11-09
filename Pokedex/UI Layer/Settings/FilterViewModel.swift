//
//  FilterViewModel.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 06.11.2023.
//

import Foundation

final class FilterViewModel: ObservableObject {
    let close: () -> Void
    let generationSelected: (Int) -> Void
    let favouriteSelected: () -> Void
    let showAll: () -> Void
    @Published var showAllGeneration = false

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
    }

    init(
        close: @escaping () -> Void,
        generationSelected: @escaping (Int) -> Void,
        favouriteSelected: @escaping () -> Void,
        showAll: @escaping () -> Void
    ) {
        self.close = close
        self.generationSelected = generationSelected
        self.favouriteSelected = favouriteSelected
        self.showAll = showAll
    }
}
