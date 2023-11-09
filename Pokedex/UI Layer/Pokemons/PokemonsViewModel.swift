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
            } catch {
                await MainActor.run {
                    self.showAlert()
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

            } catch {
                await MainActor.run {
                    self.showAlert()
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
                } catch {
                    await MainActor.run {
                        self.showAlert()
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

    func showAlert() {
        alertConfig = AlertConfig(
            title: L.Errors.genericTitle,
            message: L.Errors.genericMessage
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

struct Location: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

extension CLLocationCoordinate2D {
    /// Generates a random location within a specified radius of the current location.
    func randomLocationWithin(radius: CLLocationDistance) -> CLLocationCoordinate2D {
        // Generate a random bearing (direction) in radians.
        let bearing = Double.random(in: 0..<2 * .pi)

        // Generate a random distance from the current location, up to the specified radius.
        let distance = Double.random(in: 0...radius)

        // Convert current latitude and longitude into radians
        let currentLatitudeRadians = latitude * .pi / 180
        let currentLongitudeRadians = longitude * .pi / 180

        // Calculate the new latitude and longitude based on the random bearing and distance
        let newLatitudeRadians = asin(
            sin(currentLatitudeRadians) * cos(distance / 6_371_000) +
                cos(currentLatitudeRadians) * sin(distance / 6_371_000) * cos(bearing)
        )
        let newLongitudeRadians = currentLongitudeRadians + atan2(
            sin(bearing) * sin(distance / 6_371_000) * cos(currentLatitudeRadians),
            cos(distance / 6_371_000) - sin(currentLatitudeRadians) * sin(newLatitudeRadians)
        )

        // Convert the new latitude and longitude from radians to degrees
        let newLatitude = newLatitudeRadians * 180 / .pi
        let newLongitude = newLongitudeRadians * 180 / .pi

        // Return the new coordinates
        return CLLocationCoordinate2D(latitude: newLatitude, longitude: newLongitude)
    }
}
