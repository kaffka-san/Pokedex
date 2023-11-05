//
//  PokemonsView.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.11.2023.
//

import SwiftUI

struct PokemonsView: View {
    private let progressHudBinding: ProgressHudBinding
    let navigationPropagation: NavigationPropagation
    @StateObject var viewModel: PokemonsViewModel

    init(
        viewModel: PokemonsViewModel,
        navigationPropagation: NavigationPropagation
    ) {
        progressHudBinding = ProgressHudBinding(
            state: viewModel.$progressHudState
        )
        _viewModel = StateObject(wrappedValue: viewModel)
        self.navigationPropagation = navigationPropagation
        navigationPropagation.screenTitleSubject.send(L.Pokemons.pokemonsTitle)
    }

    var body: some View {
        ScrollView {
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
                                pokemonsAPI: viewModel.pokemonsAPI
                            )
                        )
                    }
                }
            }
            .padding(.horizontal, 26)
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
        ),
        navigationPropagation: NavigationPropagation()
    )
}
