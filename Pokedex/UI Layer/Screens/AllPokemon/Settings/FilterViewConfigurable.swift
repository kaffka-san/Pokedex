//
//  FilterViewConfigurable.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 02.01.2025.
//

import Foundation

protocol FilterViewConfigurable {
    var responseHandler: (FilterAction) -> Void { get set }
}

enum FilterAction {
    case close, favouriteSelected, showAll
    case generationSelected(generationId: Int)
}

struct FilterViewConfiguration: FilterViewConfigurable {
    var responseHandler: (FilterAction) -> Void
}
