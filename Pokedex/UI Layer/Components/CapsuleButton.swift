//
//  CapsuleButton.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 06.11.2023.
//

import SwiftUI

struct CapsuleButton: View {
    private let labelText: String
    private let icon: ImageName

    init(
        labelText: String,
        icon: ImageName
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
                Image(fromImageLiteral: icon)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background { Color.white }
            .clipShape(Capsule())
        }
    }
}

#Preview {
    CapsuleButton(
        labelText: "All Gen",
        icon: .pokeballFill
    )
    .padding()
    .hAlign(.center)
    .background(.gray)
}
