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
