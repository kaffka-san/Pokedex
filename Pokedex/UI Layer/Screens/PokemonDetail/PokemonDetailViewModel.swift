//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.11.2023.
//

import AVFoundation
import Combine
import MapKit
import SwiftUI

final class PokemonDetailViewModel: ObservableObject {
    private let pokemonService: PokemonServiceProtocol! // swiftlint:disable:this implicitly_unwrapped_optional
    private var disposeBag = Set<AnyCancellable>()
    private let dataLoadedSubject = PassthroughSubject<Result<Void, NetworkingError>, Never>()
    private let closeSubject = PassthroughSubject<Void, Never>()
    private var player: AVAudioPlayer?

    var pokemon: PokemonDetailConfig?
    // var region: MKCoordinateRegion?
    // var pokemonsLocations = [Location]()

    @Published var pokemonSpecies = MockPokemon.emptyPokemonSpecies
    @Published var alertConfig: AlertConfig?
    @Published var nextImageUrl: String?
    @Published var previousImageUrl: String?
    @Published var scrollPosition: CGPoint = .zero {
        didSet {
            print(scrollPosition)
        }
    }

    @Published var isFavourite = false
    @Published var pokemonPinsOpacity = 0.0

    // @Binding var userLocation: Location
    @Published var favouriteIds = Set<Int>()
    @Published private(set) var isLoading = false

    //    init(
    //        coordinator: PokemonsCoordinator?,
    //        pokemonsAPI: PokemonsAPIProtocol,
    //        pokemon: PokemonDetailConfig,
    //        userLocation: Binding<Location>,
    //        favouriteIds: Binding<Set<Int>>
    //    ) {
    //        self.coordinator = coordinator
    //        self.pokemonsAPI = pokemonsAPI
    //        self.pokemon = pokemon
    //        _userLocation = userLocation
    //        _favouriteIds = favouriteIds
    //        isFavourite = favouriteIds.wrappedValue.contains(pokemon.id)
    //        region = MKCoordinateRegion(
    //            center: userLocation.coordinate.wrappedValue,
    //            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    //        )
    //        loadPokemonSpecies()
    //        loadNextPokemon()
    //        loadPreviousPokemon()
    //        pokemonsLocations = getRandomLocationsNearUser(radius: 500)
    //    }

    init(pokemonService: PokemonServiceProtocol) {
        self.pokemonService = pokemonService
    }
}

// MARK: - Public properties
extension PokemonDetailViewModel {
    var dataLoaded: AnyPublisher<Result<Void, NetworkingError>, Never> {
        dataLoadedSubject.eraseToAnyPublisher()
    }

    var close: AnyPublisher<Void, Never> {
        closeSubject.eraseToAnyPublisher()
    }

    var colorBackground: ColorType {
        ColorType(rawValue: pokemon?.types.first?.capitalized ?? "") ?? ColorType.basic
    }

    var idFormatted: String {
        String(format: "#%03d", pokemon?.id ?? "")
    }
}

// MARK: - Public methods
extension PokemonDetailViewModel {
    func goBack() {
        closeSubject.send()
    }

    func getFavouritePokemons() {
        if let decodedData = UserDefaults.standard.data(forKey: Constants.favourite), let id = pokemon?.id {
            if let decodedSet = try? JSONDecoder().decode(
                Set<Int>.self,
                from: decodedData
            ) {
                favouriteIds = decodedSet
                isFavourite = favouriteIds.contains(id)
            }
        }
    }

    func toggleFavourite() {
        guard let id = pokemon?.id else { return }
        if isFavourite {
            favouriteIds.remove(id)

        } else {
            favouriteIds.insert(id)
        }
        isFavourite.toggle()

        if let encodedData = try? JSONEncoder().encode(favouriteIds) {
            UserDefaults.standard.set(encodedData, forKey: Constants.favourite)
            NotificationCenter.default.post(.updateFavouritePokemon)
        }
    }

    @MainActor
    func loadPokemonSpecies() {
        guard let pokemon = pokemon else { return }
        isLoading = true
        Task { [weak self] in
            guard let self else { return }
            do {
                let pokemonDetail = try await pokemonService.getPokemonSpecies(name: String(pokemon.id))
                updateSpecies(pokemonDetail: pokemonDetail)
                isLoading = false
            } catch let error as APIError {
                showAlert(for: error)
                isLoading = false
            }
        }
    }

    @MainActor
    func refresh() {
        loadPokemonSpecies()
        loadNextPokemon()
        loadPreviousPokemon()
    }

    func loadNextPokemon() {
        guard let pokemon = pokemon else { return }
        Task { [weak self] in
            guard let self else { return }
            do {
                let pokemonDetail = try await pokemonService.getPokemonDetail(name: "\(pokemon.id + 1)")
                await self.updateNext(pokemonDetail: pokemonDetail)
            } catch let error as APIError {
                await MainActor.run {
                    self.showAlert(for: error)
                }
            }
        }
    }

    func loadPreviousPokemon() {
        guard let pokemon = pokemon else { return }
        Task { [weak self] in
            guard let self else { return }
            do {
                let pokemonDetail = try await pokemonService.getPokemonDetail(name: "\(pokemon.id - 1)")
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
        guard let pokemon = pokemon else { return }
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
        guard let pokemon = pokemon else { return }
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

//    func getRandomLocationsNearUser(radius: CLLocationDistance) -> [Location] {
//        // Generate a random number of locations to create
//        let numberOfLocations = Int.random(in: 1...4)
//        let locations = (1...numberOfLocations).map { _ in Location(coordinate: userLocation.coordinate.randomLocationWithin(radius: radius)) }
//        return locations
//    }
}
