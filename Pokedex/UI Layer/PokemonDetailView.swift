//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.11.2023.
//

import NukeUI
import SwiftUI
import SwiftUIIntrospect
import UIKit

struct PokemonDetailView: View {
    @StateObject private var viewModel: PokemonDetailViewModel

    init(
        viewModel: PokemonDetailViewModel
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        configNavigationBar()
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color(viewModel.colorBackground)
                        .edgesIgnoringSafeArea(.all)
                }
                ScrollView {
                    VStack {
                        // Gap at the top
                        ZStack(alignment: .top) {
                            Color.clear.frame(height: geometry.size.height * 0.32)
                            HStack {
                                ForEach(viewModel.pokemon.types, id: \.self) { type in
                                    CapsuleText(
                                        text: type,
                                        font: PokedexFonts.body2,
                                        width: 70
                                    )
                                }
                                Spacer()
                            }
                            .padding(.leading, 26)
                        }
                        // Card-like view
                        VStack {
                            ZStack(alignment: .top) {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .frame(width: geometry.size.width, height: geometry.size.height * 2.75)
                                    .shadow(radius: 10)
                                pokemonImage
                                VStack(alignment: .leading) {
                                    description
                                    sizeCard
                                    headingLabel
                                    verticalStatistics
                                }
                            }
                        }
                    }
                }

                .navigationTitle(viewModel.pokemon.name.capitalized)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {} label: {
                            Label("fav", systemImage: "heart")
                        }
                        .tint(.white)
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            viewModel.goBack()
                        } label: {
                            Label("back", systemImage: "arrow.backward")
                        }
                        .tint(.white)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

private extension PokemonDetailView {
    var verticalStatistics: some View {
        VStack(alignment: .leading) {
            HorizontalLabel(
                text: viewModel.pokemonSpecies.eggGroups.first ?? "",
                descriptionText: L.PokemonDetail.eggGroups
            )
        }
        .padding(.horizontal, 26)
        .padding(.top, 24)
    }

    var headingLabel: some View {
        Text(L.PokemonDetail.breeding)
            .font(PokedexFonts.headline2)
            .foregroundColor(PokedexColors.dark)
            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
            .padding(.leading, 26)
    }

    var description: some View {
        Text(viewModel.pokemonSpecies.description)
            .font(PokedexFonts.body3)
            .padding(.top, 50)
            .foregroundColor(PokedexColors.dark)
            .lineSpacing(8)
            .padding(.horizontal, 26)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
    }

    var pokemonImage: some View {
        HStack {
            GrayImage(url: viewModel.previousImageUrl)
                .offset(x: 0, y: -190)
                .frame(width: 80, height: 100)

            ZStack {
                AssetsImages.pokeball
                    .resizable()
                    .scaledToFill()
                    .opacity(0.3)
                    .frame(width: 150)
                LazyImage(url: URL(string: viewModel.pokemon.imgUrl)) { state in
                    if let image = state.image {
                        image
                            .resizable()
                            .scaledToFit()
                    } else {
                        Color.gray.opacity(0.4)
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.7, height: 218)
            .offset(y: -190)

            GrayImage(url: viewModel.nextImageUrl)
                .offset(x: 0, y: -190)
                .frame(width: 80, height: 100)
        }
        .frame(width: UIScreen.main.bounds.width)
    }

    var sizeCard: some View {
        HStack(spacing: 45) {
            VerticalLabel(
                text: viewModel.pokemon.height,
                descriptionText: L.PokemonDetail.height
            )
            VerticalLabel(
                text: viewModel.pokemon.weight,
                descriptionText: L.PokemonDetail.weight
            )
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background {
            Color(.white)
                .cornerRadius(20)
        }
        .shadow(radius: 10)
        .padding(26)
    }

    func configNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 22, weight: .black)]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 36, weight: .black)]
        // appearance.backgroundColor = UIColor(named: viewModel.colorBackground) // Choose the background color you want
        UINavigationBar.appearance().standardAppearance = appearance
        // UINavigationBar.appearance().compactAppearance = appearance
        // UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().layoutMargins.left = 26
    }
}

#Preview {
    PokemonDetailView(
        viewModel: PokemonDetailViewModel(
            coordinator: nil,
            pokemonsAPI: PokemonsAPI(
                apiClient: APIClient(),
                router: PokemonsRouter()
            ),
            pokemon: PokemonDetailConfig(
                id: 0,
                name: "",
                types: [],
                imgUrl: "",
                weight: "",
                height: "",
                baseExperience: ""
            )
        )
    )
}
