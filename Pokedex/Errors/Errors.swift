//
//  Errors.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.11.2023.
//

import Foundation

enum GenericError: Error {
    case unexpectedError
}

enum NetworkingError: Error {
    case missingInvite
    case notAuthenticated
    case invalidData
    case inviteConsumedAlready
    case dataNotSaved
}
