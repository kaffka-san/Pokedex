//
//  AlertConfig.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.11.2023.
//

import Foundation

struct AlertAction {
    let title: String
    let action: () -> Void
}

struct AlertConfig: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let action: AlertAction?

    init(
        title: String,
        message: String,
        action: AlertAction? = nil
    ) {
        self.title = title
        self.message = message
        self.action = action
    }
}
