//
//  GenerationMenuView.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 06.01.2025.
//

import SwiftUI

struct GenerationMenuView: View {
    let onGenerationSelected: (PokemonGeneration) -> Void

    var body: some View {
        VStack {
            titleLabel
            generationButtons
        }
        .presentationDetents([.height(580)])
    }
}

private extension GenerationMenuView {
    var titleLabel: some View {
        Text(LocalizedString.Settings.generationTitle)
            .font(.title)
            .padding(.top, 18)
            .padding(.bottom, 24)
            .foregroundColor(.darkGray)
    }

    var generationButtons: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
            ForEach(PokemonGeneration.allCases, id: \.self) { generation in
                generationView(for: generation)
            }
        }
        .padding(.horizontal, 26)
    }

    @ViewBuilder
    func generationView(for generation: PokemonGeneration) -> some View {
        ZStack(alignment: .top) {
            generationImage(for: generation)
            generationText(for: generation)
        }
        .onTapGesture {
            onGenerationSelected(generation)
        }
        .shadow(radius: 20)
    }

    @ViewBuilder
    func generationImage(for generation: PokemonGeneration) -> some View {
        Image(generation.image.rawValue)
            .resizable()
            .scaledToFit()
            .frame(width: 155)
    }

    @ViewBuilder
    func generationText(for generation: PokemonGeneration) -> some View {
        Text("\(LocalizedString.Settings.generationTitle) \(generation.rawValue)")
            .font(.labelRegular)
            .padding(.top, 16)
            .foregroundColor(.darkGray)
    }
}

struct GenerationMenuView_Previews: PreviewProvider {
    static var previews: some View {
        GenerationMenuView(onGenerationSelected: { _ in })
    }
}
