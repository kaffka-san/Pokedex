//
//  AllPokemonView.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.11.2023.
//

import SwiftUI

struct AllPokemonView: View {
    @ObservedObject var viewModel: AllPokemonViewModel
    @State var showSettingsMenu = false
    var body: some View {
        content
            .onAppear { viewModel.loadPokemons(isInitialLoad: true) }
            .refreshable { viewModel.refresh() }
            .onChange(of: viewModel.favouriteIds) { viewModel.getFavourite() }
            .alert(item: $viewModel.alertConfig) { item in
                Alert(title: Text(item.title), message: Text(item.message))
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
        Text(LocalizedString.Pokemons.title)
            .font(.title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 26)
    }

    var settingsMenu: some View {
        Button {
            showSettingsMenu.toggle()
        } label: {
            Image(fromImageLiteral: .settings)
                .padding(.trailing, 26)
                .shadow(radius: 20)
        }
    }

    var filterView: some View {
        SettingsView(
            config: FilterViewConfiguration(
                responseHandler: { response in
                    switch response {
                    case .close:
                        showSettingsMenu.toggle()
                    case .favouriteSelected:
                        viewModel.getFavourite()
                    case .showAll:
                        showSettingsMenu.toggle()
                        viewModel.showAllPokemons()
                    case let .generationSelected(generationId):
                        showSettingsMenu.toggle()
                        viewModel.loadGeneration(index: generationId)
                    }
                }
            )
        )
        .opacity(showSettingsMenu ? 1 : 0)
        .animation(.easeInOut, value: showSettingsMenu)
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
        PokemonCell(
            pokemon: viewModel.pokemonsDetailed.first(where: { $0.id == pokemon.id }) ?? PokemonDetail()
        )
        .environmentObject(viewModel)
        .onAppear {
            viewModel.loadPokemons(triggerPokemon: pokemon)
        }
    }

    @ViewBuilder
    func progressView() -> some View {
        if viewModel.isLoading {
            ProgressView()
        }
    }
}

struct AllPokemonView_Previews: PreviewProvider {
    static var previews: some View {
        AllPokemonView(
            viewModel: AllPokemonViewModel(
                pokemonService: PokemonService(apiManager: MockAPIManager())
            )
        )
    }
}
