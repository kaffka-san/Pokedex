//
//  PokemonConversionsUtils.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 04.01.2025.
//

import Foundation

enum PokemonConversionsUtils {
    static func convertToPoundsAndKilograms(_ value: Int) -> String {
        let weightInKilograms = Double(value) / 10.0
        let weightInPounds = weightInKilograms * 2.20462 // Convert kg to lbs
        let formattedWeightInKilograms = String(format: "%.1f kg", weightInKilograms)
        let formattedWeightInPounds = String(format: "%.1f lbs", weightInPounds)

        return "\(formattedWeightInPounds) (\(formattedWeightInKilograms))"
    }

    static func convertToFeetInchesAndCentimeters(_ decimeters: Int) -> String {
        let centimetersPerDecimeter = 10.0
        let centimetersPerInch = 2.54
        let inchesPerFoot = 12.0
        // Convert decimeters to centimeters
        let centimeters = Double(decimeters) * centimetersPerDecimeter
        // Convert centimeters to inches
        let totalInches = centimeters / centimetersPerInch
        // Calculate feet and the remaining inches
        let feet = Int(totalInches / inchesPerFoot)
        let inches = totalInches.truncatingRemainder(dividingBy: inchesPerFoot)
        // Format the height in feet and inches
        let formattedHeightInFeetAndInches = "\(feet)'\(String(format: "%.1f", inches))\""
        // Format the height in centimeters
        let formattedHeightInCentimeters = String(format: "%.0f cm", centimeters)
        return "\(formattedHeightInFeetAndInches) (\(formattedHeightInCentimeters))"
    }

    // Initial hatch counter: one must walk 255 × (hatch_counter + 1) steps before this Pokemon's egg hatches
    static func calculateHatchingSteps(initialHatchCounter: Int?) -> String {
        guard let counter = initialHatchCounter else {
            return LocalizedString.PokemonDetail.defaultString
        }
        let baseSteps = 255
        return "\(baseSteps * (counter + 1)) \(LocalizedString.PokemonDetail.steps)"
    }

    // The chance of this Pokemon being female, in eighths; or -1 for genderless

    static func getPokemonGenderChance(index: Int) -> Gender {
        switch index {
        case -1:
            return Gender(male: "", female: "", genderCase: .genderless)
        case 0:
            return Gender(male: "100%", female: "", genderCase: .male)
        case 8:
            return Gender(male: "", female: "100%", genderCase: .female)
        default:
            let femalePercentage = (index * 100) / 8
            let malePercentage = 100 - femalePercentage
            return Gender(male: "\(malePercentage)%", female: "\(femalePercentage)%", genderCase: .maleFemale)
        }
    }
}
