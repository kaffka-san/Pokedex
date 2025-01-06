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
                .foregroundColor(.lightGray)
            Text(data.text)
                .font(.bodyRegular)
                .foregroundColor(.darkGray)
        }
    }
}

struct VerticalTextDescription_Previews: PreviewProvider {
    static var previews: some View {
        VerticalTextDescription(
            TextDescriptionConfiguration(
                text: "Label Name",
                description: "Label description"
            )
        )
    }
}
