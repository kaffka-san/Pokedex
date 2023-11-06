//
//  HorizontalLabel.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.11.2023.
//

import SwiftUI

struct HorizontalLabel: View {
    let text: String
    let descriptionText: String

    var body: some View {
        HStack(spacing: 12) {
            Text(descriptionText)
                .font(PokedexFonts.label1)
                .foregroundColor(PokedexColors.lightGray)
                .frame(width: 88, alignment: .leading)
            Text(text.capitalized)
                .font(PokedexFonts.body3)
                .foregroundColor(PokedexColors.dark)
                .frame(alignment: .leading)
        }
    }
}

#Preview {
    HorizontalLabel(
        text: "test text",
        descriptionText: L.PokemonDetail.eggGroups
    )
}
