//
//  CapsuleText.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.11.2023.
//

import SwiftUI

struct CapsuleText<DataConfigurable: CapsuleTextConfigurable>: View {
    let data: DataConfigurable

    var body: some View {
        ZStack {
            Color.white.opacity(0.3)
                .clipShape(Capsule())
                .frame(height: 20)
            Text(data.text)
                .font(data.font)
                .foregroundStyle(.white)
                .padding(6)
        }
    }
}

#Preview {
    CapsuleText(
        data: CapsuleTextConfiguration(
            text: "Electric",
            font: PokedexFonts.body1
        )
    )
    .frame(width: 100)
    .padding()
    .background(.blue)
    .cornerRadius(8)
}
