//
//  HeadLineText.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 06.11.2023.
//

import SwiftUI

struct HeadLineText: View {
    private let text: String

    init(text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.headlineSmall)
            .foregroundColor(PokedexColors.dark)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    HeadLineText(text: "Location")
}
