//
//  NetworkingError.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 27.12.2024.
//

import Foundation

enum NetworkingError: Error {
    case apiError
    case apiErrorWithMessage(String)
    case invalidEndpoint
    case invalidResponse
    case invalidUrlRequest // using
    case noData
    case other(Error)

    var description: String {
        switch self {
        case .apiError: return LocalizedString.Errors.unexpectedErrorOccurred
        case let .apiErrorWithMessage(message): return message
        case .invalidEndpoint: return "#invalidEndpoint"
        case .invalidResponse: return "#invalidResponse"
        case .invalidUrlRequest: return "#invalidURLRequest"
        case .noData: return "#noData"
        case let .other(err): return err.localizedDescription
        }
    }

    static func map(_ error: Error) -> NetworkingError {
        (error as? NetworkingError) ?? .other(error)
    }
}
