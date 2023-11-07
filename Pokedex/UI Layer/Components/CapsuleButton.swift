//
//  CapsuleButton.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 06.11.2023.
//

import SwiftUI

struct CapsuleButton: View {
    private let labelText: String
    private let icon: Image

    init(
        labelText: String,
        icon: Image
    ) {
        self.labelText = labelText
        self.icon = icon
    }

    var body: some View {
        VStack {
            HStack {
                Text(labelText)
                    .font(PokedexFonts.label1)
                    .foregroundColor(PokedexColors.dark)
                icon
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background {
                Color.white
            }
            .clipShape(Capsule())
        }
    }
}

#Preview {
    CapsuleButton(
        labelText: "All Gen",
        icon: AssetsImages.pokeballFill
    )
}
