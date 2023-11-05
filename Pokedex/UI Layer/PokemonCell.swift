//
//  PokemonCell.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.11.2023.
//

import Nuke
import NukeUI
import ProgressHUD
import SwiftUI

struct PokemonCell: View {
    private let progressHudBinding: ProgressHudBinding
    @StateObject var viewModel: PokemonCellViewModel

    init(viewModel: PokemonCellViewModel) {
        progressHudBinding = ProgressHudBinding(
            state: viewModel.$progressHudState
        )
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            backgroundCard
            HStack {
                VStack(
                    alignment: .leading,
                    spacing: 0
                ) {
                    pokemonName
                    VStack(spacing: 0) {
                        ForEach(viewModel.pokemon.types, id: \.self) { type in
                            CapsuleText(text: type)
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
        .frame(height: 110)
    }
}

private extension PokemonCell {
    var pokemonName: some View {
        Text(viewModel.pokemon.name.capitalized)
            .font(PokedexFonts.headline1)
            .frame(
                width: 85,
                alignment: .leading
            )
            .foregroundStyle(.white)
            .padding(.leading, 16)
            .padding(.top, 24)
            .padding(.bottom, 10)
    }

    var backgroundCard: some View {
        RoundedRectangle(cornerRadius: 15)
            .foregroundColor(Color(viewModel.colorBackground))
            .overlay {
                ZStack(alignment: .trailing) {
                    Images.pokeballCard
                        .opacity(0.3)
                        .frame(alignment: .trailing)
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing) {
                            idLabel
                            pokemonImage
                        }
                    }
                }
            }
    }

    var pokemonImage: some View {
        LazyImage(url: URL(string: viewModel.pokemon.imgUrl)) { state in
            if let image = state.image {
                image
                    .resizable()
                    .scaledToFit()
            } else {
                Color.gray.opacity(0.2)
            }
        }
    }

    var idLabel: some View {
        Text(viewModel.id)
            .font(PokedexFonts.headline1)
            .foregroundStyle(
                .black
                    .opacity(0.2)
            )
            .frame(
                width: 56,
                height: 13,
                alignment: .center
            )
            .padding(.top, 10)
    }
}

#Preview {
    PokemonCell(
        viewModel: PokemonCellViewModel(
            name: "Charmeleon",
            // TODO: Create Mock
            pokemonsAPI: PokemonsAPI(
                apiClient: APIClient(),
                router: PokemonsRouter()
            )
        )
    )
}
