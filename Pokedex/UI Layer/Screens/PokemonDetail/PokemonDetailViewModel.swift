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
    private let soundManager: SoundManagerProtocol
    private var disposeBag = Set<AnyCancellable>()
    private let dataLoadedSubject = PassthroughSubject<Result<Void, NetworkingError>, Never>()
    private let closeSubject = PassthroughSubject<Void, Never>()
    var pokemon: PokemonDetailConfig?

    @Published var locationManager: LocationManagerProtocol
    @Published var region = MapCameraPosition.region(MKCoordinateRegion())
    @Published var pokemonsLocations = [Location]()
    @Published var pokemonInfo = [PokemonSection]()
    @Published var pokemonSpecies = MockPokemon.emptyPokemonSpecies
    @Published var alertConfig: AlertConfiguration?
    @Published var nextImageUrl: String?
    @Published var previousImageUrl: String?
    @Published var isFavourite = false
    @Published var favouriteIds = Set<Int>()
    @Published private(set) var isLoading = false

    init(
        locationManager: LocationManagerProtocol,
        soundManager: SoundManagerProtocol,
        pokemonService: PokemonServiceProtocol
    ) {
        self.locationManager = locationManager
        self.soundManager = soundManager
        self.pokemonService = pokemonService
    }
}

// MARK: - Public properties
extension PokemonDetailViewModel {
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
    func configureMap() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        region = MapCameraPosition.region(MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        ))
        pokemonsLocations = getRandomLocationsNearUser(radius: 500)
    }

    func goBack() {
        closeSubject.send()
    }

    func getFavouritePokemons() {
        favouriteIds = UserDefaultsValue.favouriteIds
        if let id = pokemon?.id {
            isFavourite = favouriteIds.contains(id)
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
        UserDefaultsValue.favouriteIds = favouriteIds

        NotificationCenter.default.post(.updateFavouritePokemon)
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
                loadNextPokemon()
                loadPreviousPokemon()
                isLoading = false
            } catch let error as NetworkingError {
                showAlert(for: error)
                isLoading = false
            }
        }
    }

    func playSound() {
        guard let pokemon = pokemon else { return }
        if pokemon.name == Constants.pikachuSound {
            soundManager.playSound(named: AssetsSound.pikachu)
        }
    }
}

// MARK: - Private methods
private extension PokemonDetailViewModel {
    func showAlert(for error: NetworkingError) {
        alertConfig = AlertConfiguration(
            title: error.localizedDescription.title,
            message: error.localizedDescription.message
        )
    }

    func loadNextPokemon() {
        guard let pokemon = pokemon else { return }
        Task { [weak self] in
            guard let self else { return }
            do {
                let pokemonDetail = try await pokemonService.getPokemonDetail(name: "\(pokemon.id + 1)")
                await self.updateNext(pokemonDetail: pokemonDetail)
            } catch let error as NetworkingError {
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
            } catch let error as NetworkingError {
                await MainActor.run {
                    self.showAlert(for: error)
                }
            }
        }
    }

    @MainActor
    func updatePrevious(pokemonDetail: PokemonDetail) {
        previousImageUrl = pokemonDetail.sprites.other?.officialArtwork.frontDefault ?? pokemonDetail.sprites.frontDefault
    }

    @MainActor
    func updateNext(pokemonDetail: PokemonDetail) {
        nextImageUrl = pokemonDetail.sprites.other?.officialArtwork.frontDefault ?? pokemonDetail.sprites.frontDefault
    }

    @MainActor
    func updateSpecies(pokemonDetail: PokemonSpecies) {
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

    func findLastOccurrence(of name: String, in array: [String]) -> String {
        let uppercasedName = name.uppercased()
        let filteredArray = array.filter { $0.contains(uppercasedName) }
        return removeNewLines(from: filteredArray.last ?? LocalizedString.PokemonDetail.defaultString)
    }

    func removeNewLines(from string: String) -> String {
        string.replacingOccurrences(of: "\n", with: "")
    }

    // Initial hatch counter: one must walk 255 × (hatch_counter + 1) steps before this Pokemon's egg hatches
    func calculateHatchingSteps(initialHatchCounter: Int?) -> String {
        guard let counter = initialHatchCounter else {
            return LocalizedString.PokemonDetail.defaultString
        }
        let baseSteps = 255
        return "\(baseSteps * (counter + 1)) \(LocalizedString.PokemonDetail.steps)"
    }

    func getRandomLocationsNearUser(radius: CLLocationDistance) -> [Location] {
        guard let coordinate = locationManager.location?.coordinate else { return [] }
        // Generate a random number of locations to create
        let numberOfLocations = Int.random(in: 1...4)
        let locations = (1...numberOfLocations).map { _ in Location(coordinate: coordinate.randomLocationWithin(radius: radius)) }
        return locations
    }
}
