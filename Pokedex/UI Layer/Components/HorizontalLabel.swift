//
//  HorizontalLabel.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.11.2023.
//

import SwiftUI

struct HorizontalLabel<DataConfigurable: LabelConfigurable>: View {
    var data: DataConfigurable

    init(_ data: DataConfigurable) {
        self.data = data
    }

    var body: some View {
        HStack(spacing: 12) {
            Text(data.description)
                .font(PokedexFonts.label1)
                .foregroundColor(PokedexColors.lightGray)
                .frame(width: 100, alignment: .leading)
            Text(data.text.capitalized)
                .font(PokedexFonts.body3)
                .foregroundColor(PokedexColors.dark)
                .frame(alignment: .leading)
        }
    }
}

#Preview {
    HorizontalLabel(
        LabelConfiguration(
            text: "Label Name",
            description: "Label description"
        )
    )
}
