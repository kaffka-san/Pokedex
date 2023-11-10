//
//  APIError.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.11.2023.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case genericError
    case unknown
    
    var localizedDescription: ErrorDescription {
        switch self {
        case .genericError:
            return ErrorDescription(L.Errors.genericTitle, L.Errors.genericMessage)
        case .invalidURL:
            return ErrorDescription(L.Errors.invalidUrlTile, L.Errors.invalidUrlMessage)
        case .invalidData:
            return ErrorDescription(L.Errors.invalidDataTile, L.Errors.invalidDataMessage)
        case .invalidResponse:
            return ErrorDescription(L.Errors.invalidResponseTile, L.Errors.invalidResponseMessage)
        case .unknown:
            return ErrorDescription(L.Errors.unknownTile, L.Errors.unknownMessage)
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
}
