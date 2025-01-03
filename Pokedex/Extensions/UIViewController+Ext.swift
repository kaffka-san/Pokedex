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

// extension UIViewController {
//    func presentErrorAlert(error _: NetworkingError) {
//        let title = LocalizedString.InternetConnection.connectionError
//        let message = LocalizedString.InternetConnection.title + " " + LocalizedString.InternetConnection.description
//
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//
//        alert.alertDesign(withTitle: title, message: message)
//
//        alert.addAction(UIAlertAction(title: LocalizedString.cancel, style: .cancel, handler: nil))
//
//        DispatchQueue.main.async {
//            self.topMostPresentingController.present(alert, animated: true)
//        }
//    }
// }

// extension UIViewController {
//    var topMostPresentingController: UIViewController {
//        var presentingController = presentedViewController ?? self
//        while presentingController.presentedViewController != nil { presentingController = presentingController.presentedViewController! }
//
//        return presentingController
//    }
// }

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
