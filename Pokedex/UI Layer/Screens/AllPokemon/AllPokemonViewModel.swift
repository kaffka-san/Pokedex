//
//  AllPokemonViewModel.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.11.2023.
//

import Combine
import Foundation

final class AllPokemonViewModel: NSObject, ObservableObject {
    private let pokemonService: PokemonServiceProtocol
    var coordinator: AllPokemonFlow?

    @Published var pokemonsDetailed = [PokemonDetail]()
    @Published var alertConfig: AlertConfiguration?
    @Published var isLoading = false
    @Published var disablePagination = false
    @Published var favouriteIds = Set<Int>()
    @Published var showingFavourites = false
    @Published private var lastGenerationIndex = 0
    @Published var pokemons = [Pokemon]() {
        didSet {
            _ = pokemons.map { loadPokemonDetail(for: $0) }
        }
    }

    init(pokemonService: PokemonServiceProtocol) {
        self.pokemonService = pokemonService
    }
}

// MARK: - Public properties
extension AllPokemonViewModel {
    enum LoadState {
        case initial
        case pagination(triggerPokemon: Pokemon?)
    }
}

// MARK: - Public methods
extension AllPokemonViewModel {
    @MainActor
    func loadPokemons(state: LoadState) {
        guard canLoadPokemons(for: state) else { return }
        isLoading = true

        Task { [weak self] in
            defer { self?.isLoading = false }
            guard let self else { return }
            do {
                let offset = offsetForLoadState(state)
                let pokemonsList = try await pokemonService.getPokemons(offset: offset)
                self.handleFetchedPokemons(pokemonsList, for: state)
            } catch let error as NetworkingError {
                self.showAlert(for: error)
            }
        }
    }

    @MainActor
    func refresh() {
        if showingFavourites {
            getFavourite()
        } else if disablePagination {
            loadGeneration(index: lastGenerationIndex)
        } else {
            loadPokemons(state: .initial)
        }
    }

    func getFavourite() {
        showingFavourites = true
        favouriteIds = UserDefaultsValue.favouriteIds
        pokemons = []
        pokemons = favouriteIds.map { id in
            Pokemon(name: "", url: "\(id)")
        }
    }

    @MainActor
    func showAllPokemons() {
        loadPokemons(state: .initial)
        showingFavourites = false
        disablePagination = false
        lastGenerationIndex = 0
    }

    @MainActor
    func loadGeneration(index: Int) {
        isLoading = true
        lastGenerationIndex = index
        disablePagination = true
        Task { [weak self] in
            guard let self else { return }
            do {
                let pokemonsList = try await pokemonService.getPokemonForGeneration(generation: index)
                self.updateGeneration(pokemonsList: pokemonsList)
                isLoading = false
            } catch let error as NetworkingError {
                isLoading = false
                self.showAlert(for: error)
            }
        }
    }

    func loadPokemonDetail(for pokemon: Pokemon) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let pokemonDetail = try await pokemonService.getPokemonDetail(name: String(pokemon.id))
                await self.update(pokemonDetail: pokemonDetail)
                await MainActor.run {
                    self.isLoading = false
                }
            } catch let error as NetworkingError {
                await MainActor.run {
                    self.showAlert(for: error)
                    self.isLoading = false
                }
            }
        }
    }

    func getColorBackground(for pokemon: PokemonDetail) -> String {
        pokemon.types.first?.type.name.capitalized ?? Constants.neutralBackground
    }

    func goToDetailView(for pokemon: PokemonDetail) {
        let pokemonConfig = PokemonDetailConfig(
            pokemonDetail: pokemon,
            url: pokemons.first(where: { $0.id == pokemon.id })?.url ?? "",
            baseExperience: describeValue(pokemon.baseExperience)
        )

        coordinator?.showDetail(pokemon: pokemonConfig)
    }
}

// MARK: - Private methods
private extension AllPokemonViewModel {
    private func canLoadPokemons(for state: LoadState) -> Bool {
        switch state {
        case .initial:
            return !isLoading
        case let .pagination(triggerPokemon):
            return !isLoading && !disablePagination && !showingFavourites && pokemons.last?.id == triggerPokemon?.id
        }
    }

    func offsetForLoadState(_ state: LoadState) -> Int {
        switch state {
        case .initial:
            return 0
        case .pagination:
            return pokemons.count
        }
    }

    @MainActor
    private func handleFetchedPokemons(_ pokemonsList: Pokemons, for state: LoadState) {
        switch state {
        case .initial:
            pokemons = pokemonsList.results
        case .pagination:
            pokemons.append(contentsOf: pokemonsList.results)
        }
    }

    @MainActor
    func updateGeneration(pokemonsList: PokemonsGeneration) {
        pokemons = pokemonsList.pokemonSpecies
    }

    @MainActor
    func update(pokemonsList: Pokemons) {
        pokemons = pokemonsList.results
    }

    @MainActor
    func update(pokemonDetail: PokemonDetail) {
        pokemonsDetailed.append(pokemonDetail)
    }

    func describeValue(_ value: Int?) -> String {
        guard let intValue = value else {
            return LocalizedString.PokemonDetail.defaultString
        }
        return "\(intValue)"
    }

    func showAlert(for error: NetworkingError) {
        alertConfig = AlertConfiguration(
            title: error.localizedDescription.title,
            message: error.localizedDescription.message
        )
    }
}
