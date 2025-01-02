//
//  VerticalLabel.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.11.2023.
//

import SwiftUI

struct VerticalLabel<DataConfigurable: LabelConfigurable>: View {
    var data: DataConfigurable

    init(_ data: DataConfigurable) {
        self.data = data
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(data.description)
                .font(PokedexFonts.label1)
                .foregroundColor(PokedexColors.lightGray)
            Text(data.text)
                .font(PokedexFonts.body3)
                .foregroundColor(PokedexColors.dark)
        }
    }
}

#Preview {
    VerticalLabel(
        LabelConfiguration(
            text: "Label Name",
            description: "Label description"
        )
    )
}
