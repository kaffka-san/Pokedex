//
//  ApiConvertible.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 27.12.2024.
//

import Foundation

enum RequestType: CaseIterable, Codable {
    case pokemon

    var title: String {
        switch self {
        case .pokemon:
            return "Pokemon"
        }
    }
}

protocol APIConvertible {
    var path: String { get }
    var baseURLComponents: URLComponents { get }
    var parameters: [URLQueryItem]? { get }
    var httpMethod: HTTPMethod { get }
    var httpBody: Data? { get }
    var apiVersion: ApiVersion { get }
    var urlRequest: URLRequest? { get }
    var requestType: RequestType? { get }
    func createUrlRequest() throws -> URLRequest
}

extension APIConvertible {
    var parameters: [URLQueryItem]? {
        nil
    }

    var httpBody: Data? {
        nil
    }

    var apiVersion: ApiVersion {
        ApiVersion.defaultVersion
    }
}

extension APIConvertible {
    var baseURLComponents: URLComponents {
        var components = URLComponents()
        components.scheme = PokedexAPI().urlScheme
        components.host = PokedexAPI().urlHost
        components.path = PokedexAPI().urlPath
        components.queryItems = parameters

        return components
    }

    var urlRequest: URLRequest? {
        guard let url = baseURLComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiVersion.rawValue, forHTTPHeaderField: "api-version")
        request.url?.appendPathComponent("\(apiVersion.rawValue)/\(path)")
        request.httpMethod = httpMethod.rawValue
        return request
    }
}
