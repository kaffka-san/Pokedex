//
//  View+Ext.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 29.12.2024.
//

import SwiftUI

extension View {
    func hAlign(_ alignment: Alignment) -> some View {
        frame(maxWidth: .infinity, alignment: alignment)
    }
}
