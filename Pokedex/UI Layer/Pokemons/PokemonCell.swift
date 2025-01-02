//
//  PokemonCell.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.11.2023.
//

import CoreLocation
import Nuke
import NukeUI
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
        .onDisappear {
            viewModel.onDisappear()
        }
        .frame(height: 110)
    }
}

private extension PokemonCell {
    var contentInfo: some View {
        HStack {
            VStack(
                alignment: .leading,
                spacing: 0
            ) {
                pokemonName
                VStack(spacing: 0) {
                    ForEach(pokemon.types, id: \.id) { type in
                        CapsuleText(
                            text: type.type.name,
                            font: PokedexFonts.body1,
                            width: 43
                        )
                        .padding(.leading, 16)
                        .padding(.bottom, 6)
                    }
                }
                Spacer()
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    var pokemonName: some View {
        Text(pokemon.name.capitalized)
            .font(PokedexFonts.label1)
            .frame(
                width: 90,
                alignment: .leading
            )
            .foregroundStyle(.white)
            .padding(.leading, 16)
            .padding(.top, 24)
            .padding(.bottom, 10)
    }

    var backgroundCard: some View {
        RoundedRectangle(cornerRadius: 15)
            .foregroundColor(Color(viewModel.getColorBackground(for: pokemon)))
            .overlay {
                ZStack(alignment: .trailing) {
                    AssetsImages.pokeballCard
                        .opacity(0.3)
                        .frame(alignment: .trailing)
                    HStack {
                        Spacer()
                        ZStack(alignment: .topTrailing) {
                            idLabel
                            pokemonImage()
                        }
                    }
                }
            }
    }

    @ViewBuilder
    func pokemonImage() -> some View {
        if let url = pokemon.sprites.other?.officialArtwork.frontDefault ?? pokemon.sprites.frontDefault {
            AsyncImage(url: URL(string: url)) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                        .padding(.top, 20)
                }
            }
        }
    }

    var idLabel: some View {
        Text(pokemon.idFormatted)
            .font(PokedexFonts.label1)
            .foregroundStyle(
                .black
                    .opacity(0.2)
            )
            .frame(
                width: 56,
                height: 13,
                alignment: .trailing
            )
            .padding(.trailing, 10)
            .padding(.top, 10)
    }
}

#Preview {
    PokemonCell(
        pokemon: PokemonDetail(
            id: 6,
            height: 17,
            weight: 905,
            baseExperience: 10,
            types: [PokemonTypes(type: SpecificType(name: "fire"))],
            sprites: Sprites(
                frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/6.png",
                other: nil
            ),
            name: "Charizard"
        )
    )
    .environmentObject(AllPokemonViewModel(pokemonService: PokemonService(apiManager: APICommunication())))
}
