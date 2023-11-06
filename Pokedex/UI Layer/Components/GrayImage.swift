//
//  GrayImage.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.11.2023.
//

import NukeUI
import SwiftUI

struct GrayImage: View {
    let url: String?

    var body: some View {
        LazyImage(url: URL(string: url ?? "")) { state in
            if let image = state.image {
                image
                    .resizable()
                    .saturation(0.3)
                    .contrast(0.0)
                    .scaledToFill()
                    .overlay(Color.black)
                    .mask(image.resizable())
                    .opacity(0.2)
            }
        }
    }
}

#Preview {
    GrayImage(url: "")
}
