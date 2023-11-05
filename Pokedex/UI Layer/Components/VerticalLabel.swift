//
//  VerticalLabel.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.11.2023.
//

import SwiftUI

struct VerticalLabel: View {
    let text: String
    let descriptionText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(descriptionText)
                .font(PokedexFonts.label1)
                .foregroundColor(PokedexColors.lightGray)
            Text(text)
                .font(PokedexFonts.body3)
                .foregroundColor(PokedexColors.dark)
        }
    }
}

#Preview {
    VerticalLabel(
        text: "test text",
        descriptionText: "description"
    )
}
