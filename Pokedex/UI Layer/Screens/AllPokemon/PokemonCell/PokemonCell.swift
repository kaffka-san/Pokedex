//
//  PokemonCell.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.11.2023.
//

import CoreLocation
import SwiftUI

struct PokemonCell: View {
    @EnvironmentObject var viewModel: AllPokemonViewModel
    let pokemon: PokemonDetail

    var body: some View {
        ZStack {
            backgroundCard
            contentInfo
        }
        .onTapGesture {
            viewModel.goToDetailView(for: pokemon)
        }
        .frame(height: 110)
    }
}

private extension PokemonCell {
    var contentInfo: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                pokemonName
                types
                Spacer()
            }
            VStack(spacing: 10) {
                idLabel
                pokemonImage()
            }
        }
        .hAlign(.leading)
    }

    var types: some View {
        VStack(spacing: 6) {
            ForEach(pokemon.types, id: \.id) { type in
                CapsuleText(
                    CapsuleTextConfiguration(
                        text: type.type.name,
                        font: PokedexFonts.body1
                    )
                )
                .frame(width: 43)
                .padding(.leading, 16)
            }
        }
    }

    var pokemonName: some View {
        Text(pokemon.name.capitalized)
            .font(PokedexFonts.label1)
            .frame(width: 90, alignment: .leading)
            .foregroundStyle(.white)
            .padding(.leading, 16)
            .padding(.top, 24)
            .padding(.bottom, 10)
    }

    var backgroundCard: some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color(viewModel.getColorBackground(for: pokemon)))
            Image(fromImageLiteral: .pokeballCard)
                .opacity(0.3)
                .frame(alignment: .bottom)
        }
    }

    @ViewBuilder
    func pokemonImage() -> some View {
        if let url = pokemon.sprites.other?.officialArtwork.frontDefault ?? pokemon.sprites.frontDefault {
            CacheAsyncImage(url: URL(string: url)) { phase in
                switch phase {
                case .empty, .failure:
                    ProgressView()
                case let .success(image):
                    image.resizable().scaledToFit()
                }
            }
        }
    }

    var idLabel: some View {
        Text(pokemon.idFormatted)
            .font(PokedexFonts.label1)
            .foregroundStyle(.black.opacity(0.2))
            .multilineTextAlignment(.trailing)
    }
}

#Preview {
    PokemonCell(
        pokemon: PokemonDetail(
            id: 6,
            height: 17,
            weight: 905,
            baseExperience: 10,
            types: [PokemonTypes(type: SpecificType(name: "fire")), PokemonTypes(type: SpecificType(name: "flying"))],
            sprites: Sprites(
                frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/6.png",
                other: Other(officialArtwork: OfficialArtwork(frontDefault: nil))
            ),
            name: "Charizard"
        )
    )
    .frame(width: 160)
    .environmentObject(AllPokemonViewModel(pokemonService: PokemonService(apiManager: APICommunication(reachability: ReachabilityManager()))))
}
