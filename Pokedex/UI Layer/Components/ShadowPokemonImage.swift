//
//  ShadowPokemonImage.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 02.01.2025.
//

import SwiftUI

struct ShadowPokemonImage: View {
    private let url: String?

    init(url: String?) {
        self.url = url
    }

    var body: some View {
        CacheAsyncImage(url: URL(string: url ?? "")) { phase in
            switch phase {
            case let .success(image):
                image
                    .resizable()
                    .saturation(0.3)
                    .contrast(0.0)
                    .scaledToFit()
                    .overlay(Color.black)
                    .mask(image.resizable())
                    .opacity(0.2)
            case .empty, .failure:
                Color.clear
            }
        }
    }
}

#Preview {
    ShadowPokemonImage(url: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png")
        .background(.blue)
}
