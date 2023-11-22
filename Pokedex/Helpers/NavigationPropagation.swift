//
//  NavigationPropagation.swift
//  UIKit-Coordinator-Sample-George
//
//  Created by Michal Sverak on 26.06.2023.
//

import Combine
import SwiftUI

class NavigationPropagation {
    let leadingNavigationButtonsSubject: CurrentValueSubject<[UIBarButtonItem], Never>
    let trailingNavigationButtonsSubject: CurrentValueSubject<[UIBarButtonItem], Never>
    let screenTitleSubject: CurrentValueSubject<String?, Never>

    init(
        screenTitle: String? = nil,
        leadingNavigationButtons: [UIBarButtonItem] = [],
        trailingNavigationButtons: [UIBarButtonItem] = []
    ) {
        screenTitleSubject = CurrentValueSubject(screenTitle)
        leadingNavigationButtonsSubject = CurrentValueSubject(leadingNavigationButtons)
        trailingNavigationButtonsSubject = CurrentValueSubject(trailingNavigationButtons)
    }
}
