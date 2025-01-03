//
//  AllPokemonViewController.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 28.12.2024.
//

import Combine
import UIKit

final class AllPokemonViewController: UIViewController {
    private weak var allPokemonView: SwiftUIRepresentableController<AllPokemonView>!
    private var disposeBag = Set<AnyCancellable>()

    var viewModel: AllPokemonViewModel!
}

// MARK: - Life cycle
extension AllPokemonViewController {
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
private extension AllPokemonViewController {
    func prepareViewModel() {
        bindIsLoading()
        bindFavouritePokemonChanged()
    }

    func bindIsLoading() {
        viewModel.$isLoading
            .assign(to: \.isAnimating, on: activityIndicator)
            .store(in: &disposeBag)
    }

    func bindFavouritePokemonChanged() {
        NotificationCenter.default.publisher(for: .updateFavouritePokemon)
            .sink { [weak self] _ in
                self?.viewModel.refresh()
            }
            .store(in: &disposeBag)
    }
}

// MARK: - Auto Layout
private extension AllPokemonViewController {
    func layout() {
        let swiftUIView = AllPokemonView(viewModel: viewModel)
        let representable = SwiftUIRepresentableController(rootView: swiftUIView)
        allPokemonView = representable
        present(swiftUIController: representable)
    }
}
