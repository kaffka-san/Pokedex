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

    private let viewModel: PokemonDetailViewModel

    init(viewModel: PokemonDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
    }

    func bindCloseView() {
        viewModel.close
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &disposeBag)
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
