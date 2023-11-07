//
//  SettingsViewModel.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 06.11.2023.
//

import Foundation

final class SettingsViewModel: ObservableObject {
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

    func integerToRoman(_ value: Int) -> String {
        let romanNumerals = [
            1: "I", 2: "II", 3: "III", 4: "IV",
            5: "V", 6: "VI", 7: "VII", 8: "VIII"
        ]
        return romanNumerals[value] ?? ""
    }
}
