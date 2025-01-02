//
//  JSONLoader.swift
//  PokedexTests
//
//  Created by Anastasia Lenina on 29.12.2024.
//

import Foundation

final class JSONLoader {
    enum TestError: Error {
        case fileNotFound
        case fileNotDecoded
    }

    /// JSON decoder for all requests
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }

    func getData(fromJSON fileName: String) throws -> Data {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            throw TestError.fileNotFound
        }
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            throw TestError.fileNotDecoded
        }
    }

    func loadJSON<T: Decodable>(fileName: String) throws -> T {
        do {
            let data = try getData(fromJSON: fileName)

            let decodedObject = try decoder.decode(T.self, from: data)
            return decodedObject
        } catch {
            print("❌ error \(error)")
            throw error
        }
    }

    func getExample<T: Decodable>(request: APIConvertible) -> T? {
        let fileName = request.httpMethod.rawValue + "-" + request.path.replacingOccurrences(of: "/", with: "-")
        do {
            let data: T = try loadJSON(fileName: fileName)
            return data
        } catch {
            print("❌ Can't get the file \(fileName) \(error)")
            return nil
        }
    }
}
