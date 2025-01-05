//
//  VerticalTextDescription.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.11.2023.
//

import SwiftUI

struct VerticalTextDescription<DataConfigurable: TextDescriptionConfigurable>: View {
    var data: DataConfigurable

    init(_ data: DataConfigurable) {
        self.data = data
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(data.description)
                .font(.labelRegular)
                .foregroundColor(PokedexColors.lightGray)
            Text(data.text)
                .font(.bodyRegular)
                .foregroundColor(PokedexColors.dark)
        }
    }
}

#Preview {
    VerticalTextDescription(
        TextDescriptionConfiguration(
            text: "Label Name",
            description: "Label description"
        )
    )
}
