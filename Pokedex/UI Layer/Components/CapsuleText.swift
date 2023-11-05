//
//  CapsuleText.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.11.2023.
//

import SwiftUI

struct CapsuleText: View {
    private let text: String
    private let font: Font
    private let width: CGFloat

    init(
        text: String,
        font: Font,
        width: CGFloat
    ) {
        self.text = text
        self.font = font
        self.width = width
    }

    var body: some View {
        Text(text)
            .font(font)
            .foregroundStyle(.white)
            .frame(width: width)
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
    CapsuleText(
        text: "Electric",
        font: PokedexFonts.body2,
        width: 70
    )
}
