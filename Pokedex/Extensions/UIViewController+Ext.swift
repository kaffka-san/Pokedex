//
//  UIViewController+Ext.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 28.12.2024.
//

import SwiftUI
import UIKit

// MARK: - SwiftUI
extension UIViewController {
    func present<Content: View>(swiftUIController: SwiftUIRepresentableController<Content>) {
        addChild(swiftUIController)
        view.addSubview(swiftUIController.view)
        swiftUIController.didMove(toParent: self)
    }
}

extension UIViewController {
    var activityIndicator: ActivityIndicatorView {
        if let existedActivityIndicatorView = view.subviews.first(where: { $0 is ActivityIndicatorView }) as? ActivityIndicatorView {
            return existedActivityIndicatorView
        }

        let indicator = ActivityIndicatorView(
            frame: CGRect(
                x: UIScreen.main.bounds.midX - 50,
                y: UIScreen.main.bounds.minY + UIScreen.main.bounds.height / 4,
                width: 100,
                height: 100
            )
        )
        view.addSubview(indicator)
        return indicator
    }
}
