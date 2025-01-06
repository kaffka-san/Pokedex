//
//  View+Ext.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 29.12.2024.
//

import SwiftUI

extension View {
    /// Horizontally aligns the view within its parent by setting its maximum width to `.infinity`.
    ///
    /// - Parameter alignment: The horizontal alignment to apply. For example, `.leading`, `.center`, or `.trailing`.
    /// - Returns: A view with the specified horizontal alignment applied.
    func hAlign(_ alignment: Alignment) -> some View {
        frame(maxWidth: .infinity, alignment: alignment)
    }
}
