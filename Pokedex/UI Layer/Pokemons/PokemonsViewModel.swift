//
//  PokemonsViewModel.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.11.2023.
//

import CoreLocation
import Foundation

final class PokemonsViewModel: NSObject, ObservableObject {
    weak var coordinator: PokemonsCoordinator?
    let pokemonsAPI: PokemonsAPIProtocol
    let locationManager = CLLocationManager()
    @Published var pokemons = [Pokemon]()
    @Published var alertConfig: AlertConfig?
    @Published var isLoading = false
    @Published var showSettingsMenu = false
    @Published var disablePagination = false
    @Published var favouriteIds = Set<Int>()
    @Published var showingFavourites = false
    @Published var userLocation = MockLocation.location

    init(
        coordinator: PokemonsCoordinator?,
        pokemonsAPI: PokemonsAPIProtocol
    ) {
        self.coordinator = coordinator
        self.pokemonsAPI = pokemonsAPI
        super.init()
        loadPokemons()
        getFavouritePokemons()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    func getFavouritePokemons() {
        if let decodedData = UserDefaults.standard.data(forKey: Constants.favourite) {
            if let decodedSet = try? JSONDecoder().decode(Set<Int>.self, from: decodedData) {
                favouriteIds = decodedSet
            }
        }
    }

    func loadPokemons() {
        Task { [weak self] in
            guard let self else { return }
            do {
                let pokemonsList = try await pokemonsAPI.getPokemons(offset: 0)
                await self.update(pokemonsList: pokemonsList)
            } catch let error as APIError {
                await MainActor.run {
                    self.showAlert(for: error)
                }
            }
        }
    }

    func getFavourite() {
        showingFavourites = true
        pokemons = []
        pokemons = favouriteIds.map { id in
            Pokemon(name: "", url: "\(id)")
        }
    }

    func showAllPokemons() {
        loadPokemons()
        showingFavourites = false
        disablePagination = false
    }

    func loadGeneration(index: Int) {
        disablePagination = true
        isLoading = false
        Task { [weak self] in
            guard let self else { return }
            do {
                let pokemonsList = try await pokemonsAPI.getPokemonForGeneration(generation: index)
                await self.updateGeneration(pokemonsList: pokemonsList)

            } catch let error as APIError {
                await MainActor.run {
                    self.showAlert(for: error)
                }
            }
        }
    }

    func loadNextPage(for pokemon: Pokemon) {
        guard !isLoading && !disablePagination && !showingFavourites else { return }
        let isLastPost = pokemons.last?.id == pokemon.id
        if isLastPost {
            isLoading = true
            Task { [weak self] in
                guard let self else { return }
                do {
                    let pokemons = try await pokemonsAPI.getPokemons(offset: self.pokemons.count)
                    await MainActor.run {
                        self.pokemons.append(contentsOf: pokemons.results)
                        self.isLoading = false
                    }
                } catch let error as APIError {
                    await MainActor.run {
                        self.showAlert(for: error)
                    }
                }
            }
        }
    }

    @MainActor
    private func updateGeneration(pokemonsList: PokemonsGeneration) {
        pokemons = pokemonsList.pokemonSpecies
    }

    @MainActor
    private func update(pokemonsList: Pokemons) {
        pokemons = pokemonsList.results
    }

    func showAlert(for error: APIError) {
        alertConfig = AlertConfig(
            title: error.localizedDescription.title,
            message: error.localizedDescription.message
        )
    }
}

extension PokemonsViewModel: CLLocationManagerDelegate {
    func requestLocation() {
        locationManager.requestLocation()
    }

    func locationManager(
        _: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first?.coordinate {
            userLocation = Location(coordinate: location)
        }
    }

    func locationManager(
        _: CLLocationManager,
        didFailWithError _: Error
    ) {}

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            break
        case .restricted, .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
}
