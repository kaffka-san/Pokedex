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
        content
            .onAppear {
                viewModel.requestLocation()
                viewModel.loadPokemons()
            }
            .refreshable { viewModel.refresh() }
            .onChange(of: viewModel.favouriteIds) {
                if viewModel.showingFavourites {
                    viewModel.getFavourite()
                }
            }
    }
}

private extension AllPokemonView {
    var content: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                title
                pokemonList
            }
            settingsMenu
            filterView
        }
    }

    var title: some View {
        Text(L.Pokemons.pokemonsTitle)
            .font(.system(size: 30).weight(.black))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 26)
    }

    var settingsMenu: some View {
        Button {
            viewModel.showSettingsMenu.toggle()
        } label: {
            AssetsImages.settings
                .padding(.trailing, 26)
                .shadow(radius: 20)
        }
    }

    var filterView: some View {
        FilterView(
            config: FilterViewConfiguration(
                responseHandler: { response in
                    switch response {
                    case .close:
                        viewModel.showSettingsMenu.toggle()
                    case .favouriteSelected:
                        viewModel.getFavourite()
                    case .showAll:
                        viewModel.showSettingsMenu.toggle()
                        viewModel.showAllPokemons()
                    case let .generationSelected(generationId):
                        viewModel.showSettingsMenu.toggle()
                        viewModel.loadGeneration(index: generationId)
                    }
                }
            )
        )
        .opacity(viewModel.showSettingsMenu ? 1 : 0)
        .animation(.easeInOut, value: viewModel.showSettingsMenu)
    }

    var pokemonList: some View {
        VStack {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 155))], spacing: 10) {
                ForEach(viewModel.pokemons, id: \.id) { pokemon in
                    pokemonCell(pokemon)
                }
            }
            progressView()
        }
        .padding(.horizontal, 26)
    }

    @ViewBuilder
    func pokemonCell(_ pokemon: Pokemon) -> some View {
        let sasas = print("🎯 \(viewModel.pokemonsDetailed.first(where: { $0.id == pokemon.id })?.sprites.other)")
        let saeesas = print("🎯 \(viewModel.pokemonsDetailed.first(where: { $0.id == pokemon.id })?.weight)")
        PokemonCell(
            pokemon: viewModel.pokemonsDetailed.first(where: { $0.id == pokemon.id }) ?? PokemonDetail() // TODO: delete !
        )
        .environmentObject(viewModel)
        .onAppear {
            viewModel.loadNextPage(for: pokemon)
        }
    }

    @ViewBuilder
    func progressView() -> some View {
        if viewModel.isLoading {
            ProgressView()
        }
    }
}

#Preview {
    AllPokemonView(
        viewModel: AllPokemonViewModel(
            pokemonService: PokemonService(apiManager: MockAPIManager())
        )
    )
}
