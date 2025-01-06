//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.11.2023.
//

import Combine
import Foundation

final class PokemonDetailViewModel: ObservableObject {
    private let pokemonService: PokemonServiceProtocol
    private let soundManager: SoundManagerProtocol
    private var disposeBag = Set<AnyCancellable>()
    private let dataLoadedSubject = PassthroughSubject<Result<Void, NetworkingError>, Never>()
    private let closeSubject = PassthroughSubject<Void, Never>()
    var pokemon: PokemonDetailConfig?

    @Published var locationManager: LocationManagerProtocol
    @Published var mapManager: MapManagerProtocol
    @Published var pokemonsLocations = [Location]()
    @Published var pokemonInfo = [PokemonSection]()
    @Published var pokemonSpecies = MockPokemon.emptyPokemonSpeciesConfig
    @Published var alertConfig: AlertConfiguration?
    @Published var nextImageUrl: String?
    @Published var previousImageUrl: String?
    @Published var isFavourite = false
    @Published var favouriteIds = Set<Int>()
    @Published private(set) var isLoading = false

    init(
        locationManager: LocationManagerProtocol,
        soundManager: SoundManagerProtocol,
        pokemonService: PokemonServiceProtocol,
        mapManager: MapManagerProtocol
    ) {
        self.locationManager = locationManager
        self.soundManager = soundManager
        self.pokemonService = pokemonService
        self.mapManager = mapManager
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

    func loadNextPokemon() {
        guard let pokemon = pokemon else { return }
        Task { [weak self] in
            guard let self else { return }
            do {
                let pokemonDetail = try await pokemonService.getPokemonDetail(name: "\(pokemon.id + 1)")
                await self.updateNext(pokemonDetail: pokemonDetail)
            } catch {}
        }
    }

    func loadPreviousPokemon() {
        guard let pokemon = pokemon else { return }
        Task { [weak self] in
            guard let self else { return }
            do {
                let pokemonDetail = try await pokemonService.getPokemonDetail(name: "\(pokemon.id - 1)")
                await self.updatePrevious(pokemonDetail: pokemonDetail)
            } catch {}
        }
    }

    func configureMap() {
        mapManager.configureInitialRegion(coordinate: locationManager.location?.coordinate)
        getRandomLocations()
    }

    func requestAndGetLocation() async throws {
        try? await locationManager.requestUserAuthorization()
        try? await locationManager.startCurrentLocationUpdates()
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
            pokemonSpecies: pokemonDetail, pokemonName: pokemon.name
        )
    }

    func getRandomLocations() {
        pokemonsLocations = locationManager.getRandomLocationsNearUser(radius: 500)
    }
}
