//
//  PokemonConversionUtilsTests.swift
//  PokedexTests
//
//  Created by Anastasia Lenina on 04.01.2025.
//

import XCTest

final class PokemonConversionUtilsTests: XCTestCase {
    func testConvertToPoundsAndKilograms() {
        let result = PokemonConversionUtils.convertToPoundsAndKilograms(100)
        XCTAssertEqual(result, "22.0 lbs (10.0 kg)")
    }

    func testConvertToFeetInchesAndCentimeters() {
        let result = PokemonConversionUtils.convertToFeetInchesAndCentimeters(32)
        XCTAssertEqual(result, "10'6.0\" (320 cm)")
    }
}
