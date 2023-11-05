//
//  HostingController.swift
//  UIKit-Coordinator-Sample-George
//
//  Created by Michal Sverak on 26.06.2023.
//

import Combine
import SwiftUI

class HostingController<Content: View>: UIHostingController<Content> {
    var subscriptions = Set<AnyCancellable>()

    init(navigationPropagation: NavigationPropagation = NavigationPropagation(), @ViewBuilder _ view: () -> Content) {
        super.init(rootView: view())

        navigationPropagation.screenTitleSubject
            .sink { [weak self] screenTitle in
                self?.navigationItem.title = screenTitle
            }
            .store(in: &subscriptions)

        navigationPropagation.leadingNavigationButtonsSubject
            .sink { [weak self] leadingButtons in
                self?.navigationItem.leftBarButtonItems = leadingButtons
            }
            .store(in: &subscriptions)

        navigationPropagation.trailingNavigationButtonsSubject
            .sink { [weak self] trailingButtons in
                self?.navigationItem.rightBarButtonItems = trailingButtons
            }
            .store(in: &subscriptions)
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent is UINavigationController {
            parent?.navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
        }
    }

    @available(*, unavailable)
    @MainActor
    dynamic required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
