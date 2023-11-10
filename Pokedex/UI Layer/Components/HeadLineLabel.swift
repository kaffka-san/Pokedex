//
//  HeadLineLabel.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 06.11.2023.
//

import SwiftUI

struct HeadLineLabel: View {
    private let text: String
    
    init(text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(PokedexFonts.headline2)
            .foregroundColor(PokedexColors.dark)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    HeadLineLabel(text: "Location")
}
