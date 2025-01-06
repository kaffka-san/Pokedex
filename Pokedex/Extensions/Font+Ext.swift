//
//  Font+Ext.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.01.2025.
//

import SwiftUI

extension Font {
    // MARK: - Titles

    /// A large title font with a size of 36 and black weight.
    static let largeTitle = Font.system(size: 36, weight: .black)

    /// A standard title font with a size of 30 and black weight.
    static let title = Font.system(size: 30, weight: .black)

    /// A small title font with a size of 22 and black weight.
    static let smallTitle = Font.system(size: 22, weight: .black)

    // MARK: - Headlines

    /// A large headline font with a size of 18 and black weight.
    static let headlineLarge = Font.system(size: 18, weight: .black)

    /// A small headline font with a size of 16 and bold weight.
    static let headlineSmall = Font.system(size: 16, weight: .bold)

    // MARK: - Body Text

    /// A small body font with a size of 12 and bold weight.
    static let bodySmall = Font.system(size: 12, weight: .bold)

    /// A regular body font with a size of 14.
    static let bodyRegular = Font.system(size: 14)

    /// A large body font with a size of 18 and semibold weight.
    static let bodyLarge = Font.system(size: 18, weight: .semibold)

    // MARK: - Labels

    /// A small label font with a size of 8 and bold weight.
    static let labelSmall = Font.system(size: 8, weight: .bold)

    /// A regular label font with a size of 14 and bold weight.
    static let labelRegular = Font.system(size: 14, weight: .bold)
}
