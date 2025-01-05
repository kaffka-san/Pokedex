//
//  Font+Ext.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.01.2025.
//

import SwiftUI

extension Font {
    // Titles
    static let largeTitle = Font.system(size: 36, weight: .black)
    static let title = Font.system(size: 30, weight: .black)
    static let smallTitle = Font.system(size: 22, weight: .black)

    // Headlines
    static let headlineLarge = Font.system(size: 18, weight: .black)
    static let headlineSmall = Font.system(size: 16, weight: .bold)

    // Body Text
    static let bodySmall = Font.system(size: 12, weight: .bold)
    static let bodyRegular = Font.system(size: 14)
    static let bodyLarge = Font.system(size: 18, weight: .semibold)

    // Labels
    static let labelSmall = Font.system(size: 8, weight: .bold)
    static let labelRegular = Font.system(size: 14, weight: .bold)
}
