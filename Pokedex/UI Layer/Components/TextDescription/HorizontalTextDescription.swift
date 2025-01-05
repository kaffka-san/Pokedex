//
//  HorizontalTextDescription.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.11.2023.
//

import SwiftUI

struct HorizontalTextDescription<DataConfigurable: TextDescriptionConfigurable>: View {
    var data: DataConfigurable

    init(_ data: DataConfigurable) {
        self.data = data
    }

    var body: some View {
        HStack(spacing: 12) {
            Text(data.text)
                .font(.labelRegular)
                .foregroundColor(.lightGray)
                .frame(width: 100, alignment: .leading)
            Text(data.description.capitalized)
                .font(.bodyRegular)
                .foregroundColor(.darkGray)
                .frame(alignment: .leading)
        }
    }
}

#Preview {
    HorizontalTextDescription(
        TextDescriptionConfiguration(
            text: "Label Name",
            description: "Label description"
        )
    )
}
