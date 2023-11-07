//
//  APIClient.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 03.11.2023.
//

import Foundation

final class APIClient {
    // MARK: - Private properties

    private let session = URLSession.shared
    private let decoder = JSONDecoder()

    // MARK: - Public functions

    func requestVoid(
        for convertible: URLRequestConvertible

    ) async throws {
        _ = try await requestData(convertible)
    }

    func requestDecodable<T: Decodable>(
        for convertible: URLRequestConvertible
    ) async throws -> T {
        let (data, response) = try await requestData(convertible)
        return try decodeResponse(response, withData: data)
    }

    // MARK: - Private functions

    private func requestData(
        _ convertible: URLRequestConvertible
    ) async throws -> (Data, URLResponse) {
        let request = try await urlRequest(of: convertible)
        // NetworkingLogger.logRequest(request, config: session.configuration)

        do {
            let (data, response) = try await session.data(for: request)
//            NetworkingLogger.logResponse(
//                response as? HTTPURLResponse,
//                data: data,
//                error: nil
            //           )
            if response.isFailure {
                throw decodeError(from: data)
            }

            return (data, response)
        } catch {
            //  NetworkingLogger.log("Error sending request: \(error)")
            throw error
        }
    }

    private func decodeResponse<T: Decodable>(_: URLResponse, withData data: Data) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            //   NetworkingLogger.log("Error decoding successful response: \(error)")
            throw APIError.decodingError(underlyingError: error)
        }
    }

    private func decodeError(from data: Data) -> APIError {
        do {
            return try APIError.apiResponseError(
                underlyingError: decoder.decode(APIResponseError.self, from: data)
            )
        } catch {
            return APIError.decodingError(underlyingError: error)
        }
    }

    private func urlRequest(of convertible: URLRequestConvertible) throws -> URLRequest {
        do {
            return try convertible.asURLRequest()
        } catch {
            throw APIError.wrongUrl(underlyingError: error)
        }
    }
}
