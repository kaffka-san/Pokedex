//
//  SwiftUIRepresentable.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 28.12.2024.
//

import SwiftUI

class SwiftUIRepresentableController<Content: View>: UIViewController {
    private weak var hostingController: UIHostingController<Content>!

    init(rootView: Content) {
        let hosting = UIHostingController(rootView: rootView)
        hostingController = hosting
        super.init(nibName: nil, bundle: nil)
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension SwiftUIRepresentableController {
    func set(backgroundColor: UIColor) {
        hostingController.view?.backgroundColor = backgroundColor
    }
}

private extension SwiftUIRepresentableController {
    func layout() {
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        hostingController.didMove(toParent: self)
    }
}

final class HostingController<Content: View>: UIHostingController<Content> {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        view.setNeedsUpdateConstraints()
    }
}
