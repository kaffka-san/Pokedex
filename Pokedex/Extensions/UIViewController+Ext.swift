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
