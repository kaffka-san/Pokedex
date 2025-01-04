//
//  CapsuleLabel.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 06.11.2023.
//

import SwiftUI

struct CapsuleLabel<DataConfigurable: CapsuleLabelConfigurable>: View {
    let data: DataConfigurable

    var body: some View {
        VStack {
            HStack {
                Text(data.text)
                    .font(PokedexFonts.label1)
                    .foregroundColor(PokedexColors.dark)
                Image(fromImageLiteral: data.image)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background { Color.white }
            .clipShape(Capsule())
        }
    }
}

#Preview {
    CapsuleLabel(data: CapsuleLabelConfiguration(text: "All Gen", image: .loveFill))
        .padding()
        .hAlign(.center)
        .background(.gray)
}
