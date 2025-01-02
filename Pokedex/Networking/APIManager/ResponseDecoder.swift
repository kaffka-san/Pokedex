//
//  ResponseDecoder.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 29.12.2024.
//

import Foundation

var decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
//    decoder.dateDecodingStrategy = .custom { decoder -> Date in
//        let container = try decoder.singleValueContainer()
//        let dateString = try container.decode(String.self)
//
//        if let date = DateFormatter.yyyyMMdd.date(from: dateString) {
//            return date
//        } else if let datetime = DateFormatter.yyyyMMddHHmmss.date(from: dateString) {
//            return datetime
//        } else if let datetime = DateFormatter.ios8601.date(from: dateString) {
//            return datetime
//        } else {
//            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
//        }
//    }
    // .formatted(DateFormatter.yyyyMMdd)
    return decoder
}()
