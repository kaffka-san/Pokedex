//
//  UIViewController+Ext.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 28.12.2024.
//

import UIKit
import SwiftUI

extension UIViewController {
    /// Presents a SwiftUI-based view controller within the current `UIViewController`.
    ///
    /// - Parameters:
    ///   - swiftUIController: A `SwiftUIRepresentableController` containing a SwiftUI `View` to be presented.
    ///
    /// - Discussion:
    ///   This method allows embedding a SwiftUI-based view controller into a UIKit view controller seamlessly.
    ///   The `SwiftUIRepresentableController` is added as a child view controller, its view is added to the current
    ///   view controller's view hierarchy, and lifecycle events are properly handled.
    ///
    /// - Example:
    ///   ```swift
    ///   struct MySwiftUIView: View {
    ///       var body: some View {
    ///           Text("Hello from SwiftUI")
    ///       }
    ///   }
    ///
    ///   let swiftUIController = SwiftUIRepresentableController(rootView: MySwiftUIView())
    ///   someViewController.present(swiftUIController: swiftUIController)
    ///   ```
    func present<Content: View>(swiftUIController: SwiftUIRepresentableController<Content>) {
        // Add the SwiftUI controller as a child view controller
        addChild(swiftUIController)
        
        // Add the SwiftUI controller's view to the current view hierarchy
        view.addSubview(swiftUIController.view)
        
        // Notify the SwiftUI controller that it has moved to the current parent
        swiftUIController.didMove(toParent: self)
    }
}
