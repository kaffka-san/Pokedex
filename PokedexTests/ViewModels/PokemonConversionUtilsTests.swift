//
//  PokemonConversionUtilsTests.swift
//  PokedexTests
//
//  Created by Anastasia Lenina on 04.01.2025.
//

import XCTest

final class PokemonConversionsUtilsTests: XCTestCase {
    func testConvertToPoundsAndKilograms() {
        let result = PokemonConversionsUtils.convertToPoundsAndKilograms(100)
        XCTAssertEqual(result, "22.0 lbs (10.0 kg)")
    }

    func testConvertToFeetInchesAndCentimeters() {
        let result = PokemonConversionsUtils.convertToFeetInchesAndCentimeters(32)
        XCTAssertEqual(result, "10'6.0\" (320 cm)")
    }

    func testGetPokemonGenderChance() {
        // Test Case 1: Genderless (-1)
        let genderless = PokemonConversionsUtils.getPokemonGenderChance(index: -1)
        XCTAssertEqual(genderless.male, "")
        XCTAssertEqual(genderless.female, "")
        XCTAssertEqual(genderless.genderCase, .genderless)

        // Test Case 2: Fully Male (0)
        let fullyMale = PokemonConversionsUtils.getPokemonGenderChance(index: 0)
        XCTAssertEqual(fullyMale.male, "100%")
        XCTAssertEqual(fullyMale.female, "")
        XCTAssertEqual(fullyMale.genderCase, .male)

        // Test Case 3: Fully Female (8)
        let fullyFemale = PokemonConversionsUtils.getPokemonGenderChance(index: 8)
        XCTAssertEqual(fullyFemale.male, "")
        XCTAssertEqual(fullyFemale.female, "100%")
        XCTAssertEqual(fullyFemale.genderCase, .female)

        // Test Case 4: Mixed Gender (e.g., index 4)
        let mixedGender = PokemonConversionsUtils.getPokemonGenderChance(index: 4)
        XCTAssertEqual(mixedGender.male, "50%")
        XCTAssertEqual(mixedGender.female, "50%")
        XCTAssertEqual(mixedGender.genderCase, .maleFemale)

        // Test Case 5: Mixed Gender (e.g., index 2)
        let anotherMixedGender = PokemonConversionsUtils.getPokemonGenderChance(index: 2)
        XCTAssertEqual(anotherMixedGender.male, "75%")
        XCTAssertEqual(anotherMixedGender.female, "25%")
        XCTAssertEqual(anotherMixedGender.genderCase, .maleFemale)
    }
}
