//
//  Fonts.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.11.2023.
//

import SwiftUI

enum PokedexFonts {
    static let title = Font
        .system(size: 30)
        .weight(.black)

    static let headline2 = Font
        .system(size: 16)
        .weight(.bold)

    static let body1 = Font
        .system(size: 8)
        .weight(.bold)

    static let body2 = Font
        .system(size: 12)
        .weight(.bold)

    static let body3 = Font
        .system(size: 14)

    static let label1 = Font
        .system(size: 14)
        .weight(.bold)

    static let primaryButton = Font.system(size: 18, weight: .semibold)
    static let secondaryButton = Font.system(size: 18, weight: .semibold)
    static let AuthButton = Font.system(size: 18, weight: .regular)
}
