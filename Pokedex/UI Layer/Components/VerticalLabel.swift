//
//  VerticalLabel.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.11.2023.
//

import SwiftUI

struct VerticalLabel: View {
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
