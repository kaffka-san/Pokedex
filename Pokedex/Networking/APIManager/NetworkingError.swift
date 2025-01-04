//
//  NetworkingError.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.11.2023.
//

import Foundation

enum NetworkingError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case genericError
    case networkConnection
    case unknown(_ error: Error)

    var localizedDescription: ErrorDescription {
        switch self {
        case .genericError:
            return ErrorDescription(LocalizedString.Errors.genericTitle, LocalizedString.Errors.genericMessage)
        case .invalidURL:
            return ErrorDescription(LocalizedString.Errors.invalidUrlTile, LocalizedString.Errors.invalidUrlMessage)
        case .invalidData:
            return ErrorDescription(LocalizedString.Errors.invalidDataTile, LocalizedString.Errors.invalidDataMessage)
        case .invalidResponse:
            return ErrorDescription(LocalizedString.Errors.invalidResponseTile, LocalizedString.Errors.invalidResponseMessage)
        case .networkConnection:
            return ErrorDescription(
                LocalizedString.InternetConnection.connectionError,
                LocalizedString.InternetConnection.title + " " + LocalizedString.InternetConnection.description
            )
        case .unknown:
            return ErrorDescription(LocalizedString.Errors.unknownTile, LocalizedString.Errors.unknownMessage)
        }
    }

    struct ErrorDescription {
        let title: String
        let message: String

        init(_ title: String, _ message: String) {
            self.title = title
            self.message = message
        }
    }

    static func map(_ error: Error) -> NetworkingError {
        (error as? NetworkingError) ?? .unknown(error)
    }
}
