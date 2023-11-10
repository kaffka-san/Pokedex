//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.11.2023.
//

import MapKit
import NukeUI
import SwiftUI
import UIKit

struct PokemonDetailView: View {
    @StateObject private var viewModel: PokemonDetailViewModel

    init(
        viewModel: PokemonDetailViewModel
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
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
    var typeIdLabel: some View {
        HStack {
            pokemonTypes
            Spacer()
            pokemonId
        }
        .opacity(viewModel.scrollPosition < CGPoint(x: 0.0, y: -10.0) ? 1 : 0)
        .animation(.easeInOut, value: viewModel.scrollPosition)
    }

    var scrollView: some View {
        GeometryReader { geometry in
            ZStack {
                Color(viewModel.colorBackground)
                    .edgesIgnoringSafeArea(.all)
            }
            ScrollView {
                VStack {
                    ZStack(alignment: .top) {
                        Color.clear.frame(height: isLandscape() ? geometry.size.height * 0.7 : geometry.size.height * 0.32)
                        typeIdLabel
                    }
                    VStack {
                        ZStack(alignment: .top) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .frame(
                                    width: geometry.size.width,
                                    height: isLandscape() ? geometry.size.height * 1.7 : geometry.size.height * 1.1
                                )
                                .shadow(radius: 10)
                            horizontalPokemonImages
                            VStack(alignment: .leading, spacing: 0) {
                                description
                                sizeCard
                                if isLandscape() {
                                    horizontalStatics
                                } else {
                                    verticalStatistics
                                }
                                mapView
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
            .edgesIgnoringSafeArea(.horizontal)
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
        .refreshable {
            viewModel.refresh()
        }
    }

    var mapView: some View {
        VStackLayout(alignment: .leading) {
            HeadLineLabel(text: L.PokemonDetail.location)
                .padding(.top, 26)
            Map(
                coordinateRegion: $viewModel.region,
                showsUserLocation: true,
                annotationItems: viewModel.pokemonsLocations
            ) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    LazyImage(url: URL(string: viewModel.pokemon.imgUrl)) { state in
                        if let image = state.image {
                            image
                                .resizable()
                                .scaledToFit()
                        } else {}
                    }
                    .frame(width: 40, height: 40)
                    .opacity(viewModel.pokemonPinsOpacity)
                    .animation(.easeIn(duration: 1.0), value: viewModel.pokemonPinsOpacity)
                    .onAppear {
                        viewModel.pokemonPinsOpacity = 1.0
                    }
                }
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .frame(height: 150)
            .cornerRadius(20)
            .padding(.vertical, 20)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, isLandscape() ? 100 : 26)
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
        .padding(.leading, isLandscape() ? 46 : 0)
    }

    var pokemonId: some View {
        Text(viewModel.idFormatted)
            .font(PokedexFonts.headline1)
            .foregroundColor(.white)
            .padding(.trailing, 26)
            .padding(.trailing, isLandscape() ? 46 : 0)
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
        .padding(.horizontal, isLandscape() ? 100 : 26)
        .padding(.top, 24)
    }

    var horizontalStatics: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 10) {
                HeadLineLabel(text: L.PokemonDetail.breeding)
                genderStatistic
                HorizontalLabel(
                    text: viewModel.pokemonSpecies.eggGroups.first ?? "",
                    descriptionText: L.PokemonDetail.eggGroups
                )
                HorizontalLabel(
                    text: viewModel.pokemonSpecies.hatchCounter,
                    descriptionText: L.PokemonDetail.eggCylce
                )
            }
            VStack(alignment: .leading, spacing: 10) {
                HeadLineLabel(text: L.PokemonDetail.training)
                HorizontalLabel(
                    text: viewModel.pokemon.baseExperience,
                    descriptionText: L.PokemonDetail.experience
                )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, isLandscape() ? 100 : 26)
        .padding(.top, 14)
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
            .padding(.horizontal, isLandscape() ? 100 : 26)
            .padding(.bottom, isLandscape() ? 0 : 20)
            .foregroundColor(PokedexColors.dark)
            .lineSpacing(8)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
    }

    var horizontalPokemonImages: some View {
        HStack {
            GrayImage(url: viewModel.previousImageUrl)
                .frame(width: 80, height: 100)
            pokemonImage
                .onTapGesture {
                    viewModel.playSound()
                }
            GrayImage(url: viewModel.nextImageUrl)
                .offset(y: 0)
                .frame(width: 80, height: 100)
        }
        .frame(width: UIScreen.main.bounds.width)
        .opacity(viewModel.scrollPosition < CGPoint(x: 0.0, y: -90.0) ? 1 : 0)
        .animation(.easeInOut, value: viewModel.scrollPosition)
        .offset(y: isLandscape() ? -190 : -190)
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
        .padding(isLandscape() ? 10 : 20)
        .frame(maxWidth: .infinity)
        .background {
            Color(.white)
                .cornerRadius(20)
        }
        .shadow(radius: 10)
        .padding(.top, 20)
        .padding(.horizontal, isLandscape() ? 100 : 26)
    }

    struct ScrollOffsetPreferenceKey: PreferenceKey {
        static var defaultValue: CGPoint = .zero
        static func reduce(
            value _: inout CGPoint,
            nextValue _: () -> CGPoint
        ) {}
    }

    func isLandscape() -> Bool {
        UIDevice.current.orientation.isLandscape
    }
}

#Preview {
    PokemonDetailView(
        viewModel: PokemonDetailViewModel(
            coordinator: nil,
            pokemonsAPI: MockPokemonsAPI(),
            pokemon: PokemonDetailConfig(
                id: 1,
                url: "https://pokeapi.co/api/v2/pokemon/1/",
                name: "Bulbasaur",
                types: ["Grass", "Poison"],
                imgUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png",
                weight: "13.2 lbs (6.9 kg)",
                height: "1' 04 (0.70 cm)",
                baseExperience: "65"
            ),
            userLocation: Binding.constant(
                MockLocation.location
            ),
            favouriteIds: Binding.constant([1, 2, 3, 4])
        )
    )
}
