//
//  PokemonsView.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.11.2023.
//

import SwiftUI

struct PokemonsView: View {
    @StateObject var viewModel: PokemonsViewModel

    init(
        viewModel: PokemonsViewModel

    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

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
                if viewModel.showSettingsMenu {
                    SettingsView(
                        viewModel: SettingsViewModel(
                            close: { viewModel.showSettingsMenu.toggle() },
                            generationSelected: { generationId in
                                viewModel.showSettingsMenu.toggle()
                                viewModel.loadGeneration(index: generationId)
                            },
                            showAll: {
                                viewModel.showSettingsMenu.toggle()
                                viewModel.showAllPokemons()
                            }
                        )
                    )
                }
            }
        }
        .navigationBarHidden(true)
    }
}

private extension PokemonsView {
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
                        viewModel: PokemonCellViewModel(
                            name: pokemon.name,
                            url: pokemon.url,
                            pokemonsAPI: viewModel.pokemonsAPI,
                            coordinator: viewModel.coordinator
                        )
                    )
                    .onAppear {
                        viewModel.loadNextPage(for: pokemon)
                    }
                }
            }
            if viewModel.isLoading {
                ProgressView()
            }
        }
    }
}

#Preview {
    PokemonsView(
        viewModel: PokemonsViewModel(
            coordinator: nil,
            // TODO: create Mock
            pokemonsAPI: PokemonsAPI(
                apiClient: APIClient(),
                router: PokemonsRouter()
            )
        )
    )
}
