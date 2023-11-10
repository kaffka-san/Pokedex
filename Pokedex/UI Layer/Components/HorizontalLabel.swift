//
//  HorizontalLabel.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.11.2023.
//

import SwiftUI

struct HorizontalLabel: View {
    private let text: String
    private let descriptionText: String
    
    init(
        text: String,
        descriptionText: String
    ) {
        self.text = text
        self.descriptionText = descriptionText
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Text(descriptionText)
                .font(PokedexFonts.label1)
                .foregroundColor(PokedexColors.lightGray)
                .frame(width: 100, alignment: .leading)
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
