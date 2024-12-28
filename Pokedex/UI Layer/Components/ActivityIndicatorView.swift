//
//  ActivityIndicatorView.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 28.12.2024.
//

import UIKit

final class ActivityIndicatorView: UIView {
    private weak var activityIndicator: UIActivityIndicatorView!
    private var isVisible: Bool = true {
        didSet { fade(isVisible ? .in : .out) }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        layout()
        prepareUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension ActivityIndicatorView {
    func startAnimating() {
        isVisible = true
        activityIndicator.startAnimating()
    }

    func stopAnimating() {
        isVisible = false
        activityIndicator.stopAnimating()
    }

    var isAnimating: Bool {
        get { isVisible }
        set(animating) { animating ? startAnimating() : stopAnimating() }
    }
}

// MARK: - Prepare methods for UI
private extension ActivityIndicatorView {
    func prepareUI() {
        prepareContainer()
        prepareActivityIndicator()
    }

    func prepareContainer() {
        backgroundColor = .white
        layer.cornerRadius = 14
    }

    func prepareActivityIndicator() {
        activityIndicator.style = .large
        activityIndicator.color = .label
    }
}

// MARK: - Auto layout
private extension ActivityIndicatorView {
    func layout() {
        let indicator = UIActivityIndicatorView(style: .large)
        addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        activityIndicator = indicator
    }
}
