//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.11.2023.
//

import MapKit
import SwiftUI

struct PokemonDetailView: View {
    private let offsetMinimum = 0.0
    private let coordinateSpaceName = Constants.scrollName
    
    var isLandscape: Bool {
        UIDevice.current.orientation.isLandscape
    }
    
    @ObservedObject var viewModel: PokemonDetailViewModel
    @State private var isLargeTitle = true
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        scrollView
            .coordinateSpace(name: coordinateSpaceName)
            .onAppear {
                viewModel.getFavouritePokemons()
                viewModel.loadPokemonSpecies()
            }
            .refreshable {
                viewModel.refresh()
            }
    }
}

private extension PokemonDetailView {
    var scrollView: some View {
        ZStack {
            Color(viewModel.colorBackground.rawValue)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                customNavigationBar()
                ScrollView {
                    LazyVStack(spacing: 0) {
                        largeTitle()
                        typeIdLabel
                        horizontalPokemonImages
                        whiteCardContent
                    }
                    .scrollBounceBehavior(.basedOnSize)
                    .trackScrollOffset(coordinateSpace: coordinateSpaceName, offset: $scrollOffset)
                }
                .coordinateSpace(name: coordinateSpaceName)
            }
        }
    }
    
    var titleText: some View {
        Text(viewModel.pokemon?.name.capitalized ?? "")
            .foregroundStyle(.white)
            .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    func largeTitle() -> some View {
        titleText
            .font(.system(size: 36, weight: .black))
            .hAlign(.leading)
            .padding(.bottom, 10)
            .opacity(isLargeTitle ? 1 : 0)
            .onAppear {
                withAnimation(.linear(duration: 0.1)) {
                    isLargeTitle = true
                }
            }
            .onDisappear {
                withAnimation(.linear(duration: 0.1)) {
                    isLargeTitle = false
                }
            }
    }
    
    //    var mapView: some View {
    //        VStackLayout(alignment: .leading) {
    //            HeadLineLabel(text: L.PokemonDetail.location)
    //                .padding(.top, 26)
    //            Map(
    //                coordinateRegion: $viewModel.region,
    //                showsUserLocation: true,
    //                annotationItems: viewModel.pokemonsLocations
    //            ) { location in
    //                MapAnnotation(coordinate: location.coordinate) {
    //                    LazyImage(url: URL(string: viewModel.pokemon.imgUrl)) { state in
    //                        if let image = state.image {
    //                            image
    //                                .resizable()
    //                                .scaledToFit()
    //                        } else {}
    //                    }
    //                    .frame(width: 40, height: 40)
    //                    .opacity(viewModel.pokemonPinsOpacity)
    //                    .animation(.easeIn(duration: 1.0), value: viewModel.pokemonPinsOpacity)
    //                    .onAppear {
    //                        viewModel.pokemonPinsOpacity = 1.0
    //                    }
    //                }
    //            }
    //            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
    //            .frame(height: 150)
    //            .cornerRadius(20)
    //            .padding(.vertical, 20)
    //
    //        }
    //        .frame(maxWidth: .infinity)
    //        .padding(.horizontal, isLandscape() ? 100 : 26)
    //    }
}

// MARK: - Custom navigation Bar
private extension PokemonDetailView {
    @ViewBuilder
    func customNavigationBar() -> some View {
        HStack {
            backButton
            Spacer()
            smallTitle()
            loveButton
        }
        .padding(.horizontal, 20)
        .padding(.bottom)
        .padding(.top, isLandscape ? 16 : 0)
    }
    
    @ViewBuilder
    func smallTitle() -> some View {
        titleText
            .font(.system(size: 22, weight: .black))
            .hAlign(.center)
            .padding(.top, 0)
            .opacity(isLargeTitle ? 0 : 1)
    }
    
    var loveButton: some View {
        Button {
            viewModel.toggleFavourite()
        } label: {
            Group {
                if viewModel.isFavourite {
                    Image(sfSymbol: .heartFill)
                        .resizable()
                } else {
                    Image(sfSymbol: .heart)
                        .resizable()
                }
            }
            
            .frame(width: 20, height: 20)
            .scaledToFit()
        }
        .tint(.white)
    }
    
    var backButton: some View {
        Button {
            viewModel.goBack()
        } label: {
            Image(fromImageLiteral: .backIcon)?
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
        }
        .tint(.white)
    }
}

// MARK: - Type and Id for the pokemon
private extension PokemonDetailView {
    var typeIdLabel: some View {
        HStack {
            pokemonTypes()
            Spacer()
            pokemonId
        }
        .sensoryFeedback(.impact, trigger: isLargeTitle)
    }
    
    @ViewBuilder
    func pokemonTypes() -> some View {
        if let pokemon = viewModel.pokemon {
            HStack {
                ForEach(pokemon.types, id: \.self) { type in
                    CapsuleText(
                        CapsuleTextConfiguration(
                            text: type,
                            font: PokedexFonts.body2
                        )
                    )
                    .frame(width: 70)
                }
            }
            .padding(.leading, isLandscape ? 46 : 20)
        }
    }
    
    var pokemonId: some View {
        Text(viewModel.idFormatted)
            .font(PokedexFonts.headline1)
            .foregroundColor(.white)
            .padding(.trailing, 20)
            .padding(.trailing, isLandscape ? 46 : 0)
    }
}

// MARK: - Pokemon Images
private extension PokemonDetailView {
    var horizontalPokemonImages: some View {
        HStack(spacing: 0) {
            ShadowPokemonImage(url: viewModel.previousImageUrl)
                .scaleEffect(0.9)
            pokemonImage()
                .frame(width: isLandscape ? UIScreen.main.bounds.width * 0.3 : UIScreen.main.bounds.width * 0.55)
                .onTapGesture {
                    viewModel.playSound()
                }
            ShadowPokemonImage(url: viewModel.nextImageUrl)
                .scaleEffect(0.9)
        }
        .opacity(scrollOffset > -190 ? 1 : 0)
        .animation(.smooth, value: scrollOffset)
        .offset(y: isLandscape ? 40 : 35)
        .zIndex(5)
    }
    
    @ViewBuilder
    func pokemonImage() -> some View {
        if let pokemon = viewModel.pokemon {
            ZStack {
                Image(fromImageLiteral: .pokeball)?
                    .resizable()
                    .scaledToFill()
                    .opacity(0.3)
                    .frame(width: 150)
                CacheAsyncImage(url: URL(string: pokemon.imgUrl)) { state in
                    if let image = state.image {
                        image
                            .resizable()
                            .scaledToFit()
                    } else {
                        ProgressView()
                    }
                }
            }
        }
    }
}

// MARK: - White Card Content
private extension PokemonDetailView {
    var whiteCardContent: some View {
        VStack(spacing: 0) {
            description
            sizeCard
            resolveStatistics()
            Rectangle()
                .fill(.indigo)
                .frame(height: 160)
                .padding(.horizontal, 20)
            // mapView
            // }
        }
        .padding(.bottom, 40)
        .background {
            Color(.white).cornerRadius(20)
                .shadow(radius: 10)
        }
    }
    
    @ViewBuilder
    func resolveStatistics() -> some View {
        if isLandscape {
            horizontalStatics
        } else {
            verticalStatistics()
        }
    }
    
    var description: some View {
        Text(viewModel.pokemonSpecies.description)
            .font(PokedexFonts.body3)
            .padding(.top, 50)
            .padding(.horizontal, isLandscape ? 100 : 20)
            .padding(.bottom, isLandscape ? 0 : 20)
            .foregroundColor(PokedexColors.dark)
            .lineSpacing(8)
            .hAlign(.leading)
    }
    
    var sizeCard: some View {
        HStack(spacing: 45) {
            VerticalLabel(
                LabelConfiguration(
                    text: viewModel.pokemon?.height ?? "",
                    description: L.PokemonDetail.height
                )
            )
            VerticalLabel(
                LabelConfiguration(
                    text: viewModel.pokemon?.weight ?? "",
                    description: L.PokemonDetail.weight
                )
            )
        }
        .padding(isLandscape ? 10 : 20)
        .frame(maxWidth: .infinity)
        .background { Color(.white).cornerRadius(20) }
        .shadow(radius: 10)
        .padding(.top, 20)
        .padding(.horizontal, isLandscape ? 100 : 20)
    }
    
    @ViewBuilder
    func verticalStatistics() -> some View {
        VStack(spacing: 10) {
            ForEach(PokemonDetailSection.allCases) { section in
                HeadLineLabel(text: section.title)
                    .padding(.vertical)
                sectionStatistics(for: section)
            }
        }
        .padding(20)
    }
    
    @ViewBuilder
    func sectionStatistics(for section: PokemonDetailSection) -> some View {
        ForEach(section.items, id: \.id) { item in
            switch item.itemType {
            case let .breeding(breedingItem) where breedingItem == .gender:
                genderStatistic
            default:
                defaultStatistics(for: item)
            }
        }
    }
    
    @ViewBuilder
    func defaultStatistics(for item: PokemonDetailItem) -> some View {
        if let pokemon = viewModel.pokemon {
            HorizontalLabel(
                LabelConfiguration(
                    text: item.title,
                    description: item.description(
                        using: pokemon,
                        species: viewModel.pokemonSpecies
                    )
                )
            )
            .hAlign(.leading)
        }
    }
    
    var horizontalStatics: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 250))], spacing: 10) {
            ForEach(PokemonDetailSection.allCases) { section in
                switch section {
                case .breeding, .training:
                    GridRow {
                        VStack(alignment: .center, spacing: 10) {
                            HeadLineLabel(text: section.title)
                                .padding(.vertical)
                            sectionStatistics(for: section)
                            Spacer()
                        }
                    }
                case .location:
                    HeadLineLabel(text: section.title)
                        .padding(.vertical)
                }
            }
        }
        .padding(.horizontal, isLandscape ? 100 : 20)
        .padding(.vertical, 20)
    }
}

// MARK: - Gender Statistics
private extension PokemonDetailView {
    var genderStatistic: some View {
        HStack(spacing: 12) {
            genderTitle()
            switch viewModel.pokemonSpecies.gender.genderCase {
            case .genderless:
                genderlessView()
            case .male:
                maleView()
            case .female:
                femaleView()
            case .maleFemale:
                maleFemaleView()
            }
        }
        .hAlign(.leading)
    }
    
    @ViewBuilder
    func genderTitle() -> some View {
        Text(L.PokemonDetail.gender)
            .font(PokedexFonts.label1)
            .foregroundColor(PokedexColors.lightGray)
            .frame(width: 100, alignment: .leading)
    }
    
    @ViewBuilder
    func genderlessView() -> some View {
        Text(viewModel.pokemonSpecies.gender.genderless)
            .font(PokedexFonts.body3)
            .foregroundColor(PokedexColors.dark)
            .frame(alignment: .leading)
    }
    
    @ViewBuilder
    func maleView() -> some View {
        Label(viewModel.pokemonSpecies.gender.male, image: .male)
            .font(PokedexFonts.body3)
    }
    
    @ViewBuilder
    func femaleView() -> some View {
        Label(viewModel.pokemonSpecies.gender.female, image: .female)
            .font(PokedexFonts.body3)
            .foregroundColor(PokedexColors.dark)
    }
    
    @ViewBuilder
    func maleFemaleView() -> some View {
        Label(viewModel.pokemonSpecies.gender.male, image: .male)
            .font(PokedexFonts.body3)
            .foregroundColor(PokedexColors.dark)
        Label(viewModel.pokemonSpecies.gender.female, image: .female)
            .font(PokedexFonts.body3)
            .foregroundColor(PokedexColors.dark)
    }
}

// MARK: - Utilities
private extension PokemonDetailView {
    enum AnimationNameSpace: String {
        case title
    }
}

struct PokemonDetailView_Previews: PreviewProvider {
    static var viewModel = PokemonDetailViewModel(
        pokemonService: PokemonService(
            apiManager: MockAPIManager()
        )
    )
    
    static var previews: some View {
        PokemonDetailView(viewModel: viewModel)
            .onAppear {
                viewModel.pokemon = PokemonDetailConfig(
                    id: 1,
                    url: "https://pokeapi.co/api/v2/pokemon/1/",
                    name: "Bulbasaur",
                    types: ["Grass", "Poison"],
                    imgUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png",
                    weight: "13.2 lbs (6.9 kg)",
                    height: "1' 04 (0.70 cm)",
                    baseExperience: "64"
                )
                viewModel.loadPokemonSpecies()
            }
    }
}
