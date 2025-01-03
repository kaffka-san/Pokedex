//
//  APICommunication.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 28.12.2024.
//

import Foundation
import UIKit

final class APICommunication: APIManager {
    private let reachability: ReachabilityManagerProtocol

    init(reachability: ReachabilityManagerProtocol) {
        self.reachability = reachability
    }

    func request<T: Decodable>(request: APIConvertible) async throws -> T {
        // Begin background task
        let backgroundTaskID = UUID().uuidString
        let backgroundTask = await UIApplication.shared.beginBackgroundTask(withName: backgroundTaskID) {
            print("Background task expired...")
        }

        guard isNetworkAvailable else {
            throw NetworkingError.networkConnection
        }

        do {
            // Convert your APIConvertible to a URLRequest
            let urlRequest = try request.createUrlRequest()

            // Perform data task with async/await
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            // Ensure valid status code
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode
            else {
                throw NetworkingError.invalidResponse
            }

            await UIApplication.shared.endBackgroundTask(backgroundTask)
            return try decoder.decode(T.self, from: data)
        } catch {
            await UIApplication.shared.endBackgroundTask(backgroundTask)
            throw NetworkingError.map(error)
        }
    }

    // MARK: - Helpers

    /// JSON decoder for all requests
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        // decoder.keyDecodingStrategy = .convertFromSnakeCase
        // Customize if needed
        return decoder
    }

    private var isNetworkAvailable: Bool {
        !reachability.hasNoConnection
    }
}

protocol ReachabilityManagerProtocol {
    var hasNoConnection: Bool { get }
}
