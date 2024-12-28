//
//  AllPokemonView.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.11.2023.
//

import SwiftUI

struct AllPokemonView: View {
    @ObservedObject var viewModel: AllPokemonViewModel

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    Text(L.Pokemons.pokemonsTitle)
                        .font(.system(size: 30).weight(.black))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 26)
                    pokemonList
                        .padding(.horizontal, 26)
                }
                Button {
                    viewModel.showSettingsMenu.toggle()
                } label: {
                    AssetsImages.settings
                        .padding(.trailing, 26)
                        .shadow(radius: 20)
                }

                FilterView(
                    viewModel: FilterViewModel(
                        close: { viewModel.showSettingsMenu.toggle() },
                        generationSelected: { generationId in
                            viewModel.showSettingsMenu.toggle()
                            viewModel.loadGeneration(index: generationId)
                        },
                        favouriteSelected: { viewModel.getFavourite() },
                        showAll: {
                            viewModel.showSettingsMenu.toggle()
                            viewModel.showAllPokemons()
                        }
                    )
                )
                .opacity(viewModel.showSettingsMenu ? 1 : 0)
                .animation(.easeInOut, value: viewModel.showSettingsMenu)
            }
            .onAppear {
                viewModel.requestLocation()
            }
            .refreshable {
                viewModel.refresh()
            }
        }
        .navigationBarHidden(true)
    }
}

private extension AllPokemonView {
    var pokemonList: some View {
        VStack {
            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 155))
                ],
                spacing: 10
            ) {
                ForEach(viewModel.pokemons, id: \.id) { pokemon in
                    PokemonCell(
                        pokemon: viewModel.pokemonsDetailed.first(where: { $0.imageUrl == pokemon.url })! // TODO: delete !
                    )
                    .environmentObject(viewModel)
                    .onAppear {
                        viewModel.loadNextPage(for: pokemon)
                    }
                    .onChange(of: viewModel.favouriteIds) {
                        if viewModel.showingFavourites {
                            viewModel.getFavourite()
                        }
                    }
                }
            }
            if viewModel.isLoading {
                ProgressView()
            }
        }
    }
}

// #Preview {
//    PokemonsView(
//        viewModel: PokemonsViewModel(
//            coordinator: nil,
//            pokemonsAPI: MockPokemonsAPI()
//        )
//    )
// }
