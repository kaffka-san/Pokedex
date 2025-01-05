//
//  Color+Ext.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.01.2025.
//

import SwiftUI

extension Color {
    /// A custom dark gray color, used as a general-purpose color for backgrounds, text, or other UI elements.
    static let darkGray = Color(red: 0.19, green: 0.22, blue: 0.26)

    /// A lighter gray color with 40% opacity, suitable for subtle UI elements like borders or placeholders.
    static let lightGray = Color(red: 0.19, green: 0.22, blue: 0.26).opacity(0.4)

    /// A blue color representing "male" gender in the UI.
    static let male = Color(red: 0.42, green: 0.47, blue: 0.86)

    /// A pink color representing "female" gender in the UI.
    static let female = Color(red: 0.94, green: 0.45, blue: 0.63)
}
