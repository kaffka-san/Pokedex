//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.11.2023.
//

import NukeUI
import SwiftUI
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
            scrollView
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

private extension PokemonDetailView {
    var scrollView: some View {
        GeometryReader { geometry in
            ZStack {
                Color(viewModel.colorBackground)
                    .edgesIgnoringSafeArea(.all)
            }
            ScrollView {
                VStack {
                    ZStack(alignment: .top) {
                        Color.clear.frame(height: geometry.size.height * 0.32)
                        pokemonTypes
                    }
                    VStack {
                        ZStack(alignment: .top) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .frame(
                                    width: geometry.size.width,
                                    height: geometry.size.height
                                )
                                .shadow(radius: 10)
                            horizontalPokemonImages
                            VStack(alignment: .leading) {
                                description
                                sizeCard
                                verticalStatistics
                            }
                        }
                    }
                }
                // Detect scroll position
                .background(GeometryReader { geometry in
                    Color.clear
                        .preference(
                            key: ScrollOffsetPreferenceKey.self,
                            value: geometry.frame(
                                in: .named(Constants.scrollName)
                            )
                            .origin
                        )
                })
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    viewModel.scrollPosition = value
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .coordinateSpace(name: Constants.scrollName)
            .navigationTitle(viewModel.pokemon.name.capitalized)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    backButton
                }
                ToolbarItem(placement: .topBarTrailing) {
                    loveButton
                }
            }
        }
    }

    var loveButton: some View {
        Button {
            viewModel.toggleFavourite()
        } label: {
            if viewModel.isFavourite {
                AssetsImages.heartFill
            } else {
                AssetsImages.heart
            }
        }
        .tint(.white)
    }

    var backButton: some View {
        Button {
            viewModel.goBack()
        } label: {
            Image(AssetsImagesString.backIcon)
        }
        .tint(.white)
    }

    var pokemonTypes: some View {
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

    var verticalStatistics: some View {
        VStack(alignment: .leading, spacing: 18) {
            HeadLineLabel(text: L.PokemonDetail.breeding)
                .padding(.vertical, 6)
            genderStatistic
            HorizontalLabel(
                text: viewModel.pokemonSpecies.eggGroups.first ?? "",
                descriptionText: L.PokemonDetail.eggGroups
            )
            HorizontalLabel(
                text: viewModel.pokemonSpecies.hatchCounter,
                descriptionText: L.PokemonDetail.eggCylce
            )
            HeadLineLabel(text: L.PokemonDetail.training)
                .padding(.vertical, 6)
            HorizontalLabel(
                text: viewModel.pokemon.baseExperience,
                descriptionText: L.PokemonDetail.experience
            )
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 26)
        .padding(.top, 24)
    }

    var genderStatistic: some View {
        HStack(spacing: 12) {
            Text(L.PokemonDetail.gender)
                .font(PokedexFonts.label1)
                .foregroundColor(PokedexColors.lightGray)
                .frame(width: 100, alignment: .leading)
            switch viewModel.pokemonSpecies.gender.genderCase {
            case .genderless:
                Text(viewModel.pokemonSpecies.gender.genderless)
                    .font(PokedexFonts.body3)
                    .foregroundColor(PokedexColors.dark)
                    .frame(alignment: .leading)
            case .male:
                Label(viewModel.pokemonSpecies.gender.male, image: AssetsImagesString.male)
                    .font(PokedexFonts.body3)
            case .female:
                Label(viewModel.pokemonSpecies.gender.female, image: AssetsImagesString.female)
                    .font(PokedexFonts.body3)
                    .foregroundColor(PokedexColors.dark)
            case .maleFemale:
                Label(viewModel.pokemonSpecies.gender.male, image: AssetsImagesString.male)
                    .font(PokedexFonts.body3)
                    .foregroundColor(PokedexColors.dark)
                Label(viewModel.pokemonSpecies.gender.female, image: AssetsImagesString.female)
                    .font(PokedexFonts.body3)
                    .foregroundColor(PokedexColors.dark)
            }
        }
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

    var horizontalPokemonImages: some View {
        HStack {
            GrayImage(url: viewModel.previousImageUrl)
                .offset(x: 0, y: -190)
                .frame(width: 80, height: 100)

            pokemonImage
            GrayImage(url: viewModel.nextImageUrl)
                .offset(x: 0, y: -190)
                .frame(width: 80, height: 100)
        }
        .frame(width: UIScreen.main.bounds.width)
        .opacity(viewModel.scrollPosition < CGPoint(x: 0.0, y: -90.0) ? 1 : 0)
        .animation(.easeInOut, value: viewModel.scrollPosition)
    }

    var pokemonImage: some View {
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
        .padding(.top, 26)
        .padding(.horizontal, 26)
    }

    func configNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 22, weight: .black)]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 36, weight: .black)]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().layoutMargins.left = 26
    }

    struct ScrollOffsetPreferenceKey: PreferenceKey {
        static var defaultValue: CGPoint = .zero
        static func reduce(
            value _: inout CGPoint,
            nextValue _: () -> CGPoint
        ) {}
    }
}

#Preview {
    PokemonDetailView(
        viewModel: PokemonDetailViewModel(
            coordinator: nil,
            // TODO: create Mock
            pokemonsAPI: PokemonsAPI(
                apiClient: APIClient(),
                router: PokemonsRouter()
            ),
            pokemon: PokemonDetailConfig(
                id: 4,
                url: "https://pokeapi.co/api/v2/pokemon/4/",
                name: "Charmander",
                types: ["Fire"],
                imgUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/4.png",
                weight: "13.2 lbs (6.9 kg)",
                height: "1' 04 (0.70 cm)",
                baseExperience: "65"
            ),
            favouriteIds: Binding.constant([1, 2, 3, 4])
        )
    )
}
