//
//  MockAPIManager.swift
//  PokedexTests
//
//  Created by Anastasia Lenina on 29.12.2024.
//

import Combine
import Foundation

final class MockAPIManager: APIManager {
    enum ResultType {
        case success
        case error
    }

    var resultType: ResultType = .success

    func request<T: Decodable>(request: APIConvertible) async throws -> T {
        guard resultType == .success else {
            throw NetworkingError.genericError
        }

        do {
            let fileName = request.httpMethod.rawValue + "-" + request.path.replacingOccurrences(of: "/", with: "-")
            let data: T = try JSONLoader().loadJSON(fileName: fileName)

            return data
        } catch {
            throw NetworkingError.invalidResponse
        }
    }

    func downloadFile(from _: URL) async throws -> (file: Data, title: String) {
        throw NetworkingError.invalidData
    }
}
