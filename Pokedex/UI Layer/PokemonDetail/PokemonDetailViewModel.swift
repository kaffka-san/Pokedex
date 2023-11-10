//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.11.2023.
//

import AVFoundation
import MapKit
import SwiftUI

class PokemonDetailViewModel: ObservableObject {
    private let pokemonsAPI: PokemonsAPIProtocol
    private var player: AVAudioPlayer?
    private weak var coordinator: PokemonsCoordinator?
    let pokemon: PokemonDetailConfig
    var region: MKCoordinateRegion
    var pokemonsLocations = [Location]()
    var colorBackground: String {
        pokemon.types.first?.capitalized ?? Constants.neutralBackground
    }
    
    var idFormatted: String {
        String(format: "#%03d", pokemon.id)
    }
    
    @Published var pokemonSpecies = MockPokemon.emptyPokemonSpecies
    @Published var alertConfig: AlertConfig?
    @Published var nextImageUrl: String?
    @Published var previousImageUrl: String?
    @Published var scrollPosition: CGPoint = .zero
    @Published var isFavourite: Bool
    @Published var pokemonPinsOpacity = 0.0
    @Binding var userLocation: Location
    @Binding var favouriteIds: Set<Int>
    
    init(
        coordinator: PokemonsCoordinator?,
        pokemonsAPI: PokemonsAPIProtocol,
        pokemon: PokemonDetailConfig,
        userLocation: Binding<Location>,
        favouriteIds: Binding<Set<Int>>
    ) {
        self.coordinator = coordinator
        self.pokemonsAPI = pokemonsAPI
        self.pokemon = pokemon
        _userLocation = userLocation
        _favouriteIds = favouriteIds
        isFavourite = favouriteIds.wrappedValue.contains(pokemon.id)
        region = MKCoordinateRegion(
            center: userLocation.coordinate.wrappedValue,
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
        loadPokemonSpecies()
        loadNextPokemon()
        loadPreviousPokemon()
        pokemonsLocations = getRandomLocationsNearUser(radius: 500)
        configNavigationBar()
    }
    
    @objc
    func goBack() {
        coordinator?.goBack()
    }
    
    @objc
    func toggleFavourite() {
        if isFavourite {
            favouriteIds.remove(pokemon.id)
            
        } else {
            favouriteIds.insert(pokemon.id)
        }
        isFavourite.toggle()
        if let encodedData = try? JSONEncoder().encode(favouriteIds) {
            UserDefaults.standard.set(encodedData, forKey: Constants.favourite)
        }
    }
    
    func loadPokemonSpecies() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let pokemonDetail = try await pokemonsAPI.getPokemonSpecies(name: pokemon.name)
                await self.updateSpecies(pokemonDetail: pokemonDetail)
            } catch let error as APIError {
                await MainActor.run {
                    self.showAlert(for: error)
                }
            }
        }
    }
    
    func refresh() {
        loadPokemonSpecies()
        loadNextPokemon()
        loadPreviousPokemon()
    }
    
    func loadNextPokemon() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let pokemonDetail = try await pokemonsAPI.getPokemonDetail(name: "\(pokemon.id + 1)")
                await self.updateNext(pokemonDetail: pokemonDetail)
            } catch let error as APIError {
                await MainActor.run {
                    self.showAlert(for: error)
                }
            }
        }
    }
    
    func loadPreviousPokemon() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let pokemonDetail = try await pokemonsAPI.getPokemonDetail(name: "\(pokemon.id - 1)")
                await self.updatePrevious(pokemonDetail: pokemonDetail)
            } catch let error as APIError {
                await MainActor.run {
                    self.showAlert(for: error)
                }
            }
        }
    }
    
    func showAlert(for error: APIError) {
        alertConfig = AlertConfig(
            title: error.localizedDescription.title,
            message: error.localizedDescription.message
        )
    }
    
    func playSound() {
        if pokemon.name == Constants.pikachuSound {
            guard let path = Bundle.main.path(forResource: AssetsSound.pikachu, ofType: nil) else {
                return
            }
            let url = URL(fileURLWithPath: path)
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
            } catch {}
        }
    }
    
    @MainActor
    private func updatePrevious(pokemonDetail: PokemonDetail) {
        previousImageUrl = pokemonDetail.sprites.other?.officialArtwork.frontDefault ?? pokemonDetail.sprites.frontDefault
    }
    
    @MainActor
    private func updateNext(pokemonDetail: PokemonDetail) {
        nextImageUrl = pokemonDetail.sprites.other?.officialArtwork.frontDefault ?? pokemonDetail.sprites.frontDefault
    }
    
    @MainActor
    private func updateSpecies(pokemonDetail: PokemonSpecies) {
        pokemonSpecies = PokemonSpeciesConfig(
            description: findLastOccurrence(
                of: pokemon.name,
                in: pokemonDetail.flavorTextEntries.map { $0.flavorText }
            ),
            eggGroups: pokemonDetail.eggGroups.map { $0.name },
            gender: getPokemonGenderChance(femaleEighths: pokemonDetail.genderRate),
            hatchCounter: calculateHatchingSteps(initialHatchCounter: pokemonDetail.hatchCounter)
        )
    }
    
    // The chance of this Pokemon being female, in eighths; or -1 for genderless
    func getPokemonGenderChance(femaleEighths: Int) -> Gender {
        switch femaleEighths {
        case -1:
            return Gender(male: "", female: "", genderCase: .genderless)
        case 0:
            return Gender(male: "100%", female: "", genderCase: .male)
        case 8:
            return Gender(male: "", female: "100%", genderCase: .female)
        default:
            let femalePercentage = (femaleEighths * 100) / 8
            let malePercentage = 100 - femalePercentage
            return Gender(male: "\(malePercentage)%", female: "\(femalePercentage)%", genderCase: .maleFemale)
        }
    }
    
    func findLastOccurrence(
        of name: String,
        in array: [String]
    ) -> String {
        let uppercasedName = name.uppercased()
        let filteredArray = array.filter { $0.contains(uppercasedName) }
        return removeNewLines(from: filteredArray.last ?? L.PokemonDetail.defaultString)
    }
    
    func removeNewLines(from string: String) -> String {
        string.replacingOccurrences(of: "\n", with: "")
    }
    
    // Initial hatch counter: one must walk 255 × (hatch_counter + 1) steps before this Pokemon's egg hatches
    func calculateHatchingSteps(initialHatchCounter: Int?) -> String {
        guard let counter = initialHatchCounter else {
            return L.PokemonDetail.defaultString
        }
        let baseSteps = 255
        return "\(baseSteps * (counter + 1)) \(L.PokemonDetail.steps)"
    }
    
    func getRandomLocationsNearUser(radius: CLLocationDistance) -> [Location] {
        // Generate a random number of locations to create
        let numberOfLocations = Int.random(in: 1...4)
        let locations = (1...numberOfLocations).map { _ in Location(coordinate: userLocation.coordinate.randomLocationWithin(radius: radius)) }
        return locations
    }
    
    private func configNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(named: colorBackground)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(
                ofSize: 22,
                weight: .black
            )
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(
                ofSize: 36,
                weight: .black
            )
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().layoutMargins.left = 26
    }
}
