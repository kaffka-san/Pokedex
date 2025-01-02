//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 28.12.2024.
//

import Combine
import UIKit

final class PokemonDetailViewController: UIViewController {
    private weak var pokemonDetailView: SwiftUIRepresentableController<PokemonDetailView>! // swiftlint:disable:this implicitly_unwrapped_optional
    private var disposeBag = Set<AnyCancellable>()

    var viewModel: PokemonDetailViewModel! // swiftlint:disable:this implicitly_unwrapped_optional
}

// MARK: - Life cycle
extension PokemonDetailViewController {
    override func loadView() {
        super.loadView()

        layout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

// MARK: - Prepare methods for View model
private extension PokemonDetailViewController {
    func prepareViewModel() {
        bindCloseView()
        bindIsLoading()
        bindDataLoaded()
    }

    func bindIsLoading() {
        viewModel.$isLoading
            .assign(to: \.isAnimating, on: activityIndicator)
            .store(in: &disposeBag)
    }

    func bindDataLoaded() {
        viewModel.dataLoaded
            .sink { [weak self] result in
                switch result {
                case .success:
                    break
                case let .failure(error):
                    self?.presentErrorAlert(error: error)
                }
            }
            .store(in: &disposeBag)
    }

    func bindCloseView() {
        viewModel.close
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &disposeBag)
    }
}

// MARK: - Actions
private extension PokemonDetailViewController {
    @objc
    func toggleFavourite() {
        if viewModel.isFavourite {
            viewModel.favouriteIds.remove(viewModel.pokemon.id)

        } else {
            viewModel.favouriteIds.insert(viewModel.pokemon.id)
        }
        viewModel.isFavourite.toggle()
        if let encodedData = try? JSONEncoder().encode(viewModel.favouriteIds) {
            UserDefaults.standard.set(encodedData, forKey: Constants.favourite)
        }
    }
}

// MARK: - Auto Layout
private extension PokemonDetailViewController {
    func layout() {
        let swiftUIView = PokemonDetailView(viewModel: viewModel)
        let representable = SwiftUIRepresentableController(rootView: swiftUIView)
        pokemonDetailView = representable
        present(swiftUIController: representable)
    }
}
