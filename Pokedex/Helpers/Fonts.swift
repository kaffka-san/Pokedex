//
//  Fonts.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.11.2023.
//

import SwiftUI

enum PokedexFonts {
    static let title = Font
        .custom("SF Pro Display", size: 30)
        .weight(.black)

    static let headline1 = Font
        .custom("SF Pro Display", size: 14)
        .weight(.bold)

    static let body1 = Font
        .custom("SF Pro Display", size: 8)
        .weight(.bold)

    static let primaryButton = Font.system(size: 18, weight: .semibold)
    static let secondaryButton = Font.system(size: 18, weight: .semibold)
    static let AuthButton = Font.system(size: 18, weight: .regular)
}
