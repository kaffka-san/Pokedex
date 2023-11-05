//
//  CapsuleText.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.11.2023.
//

import SwiftUI

struct CapsuleText: View {
    private let text: String

    init(text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(PokedexFonts.body1)
            .foregroundStyle(.white)
            .frame(width: 34)
            .padding(6)
            .background {
                Color
                    .white
                    .opacity(0.3)
                    .cornerRadius(38)
            }
    }
}

#Preview {
    CapsuleText(text: "Electric")
}
