//
//  Router.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.11.2023.
//

import Foundation

/// - Router protocol for concrete Route which is suggested to be an enum.
/// - Creates URLRequest for given route of type Route.
protocol Router<Route> {
    associatedtype Route
    func urlRequest(for route: Route) throws -> URLRequestConvertible
}

extension Router {
    func buildRequest(
        method: HTTPMethod,
        url: @autoclosure () -> URLConvertible,
        headers: HTTPHeaders,
        body: @escaping () throws -> Data?
    ) -> URLRequestConvertible {
        URLRequestBuilder(
            method: method,
            url: url(),
            headers: headers,
            body: body
        )
    }
}
