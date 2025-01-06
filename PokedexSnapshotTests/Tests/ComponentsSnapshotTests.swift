//
//  ComponentsSnapshotTests.swift
//  PokedexSnapshotTests
//
//  Created by Anastasia Lenina on 05.01.2025.
//

@testable import Pokedex
import XCTest

final class ComponentsSnapshotTests: XCTestCase {
    func testCapsuleLabel() {
        assertSnapshot.devices(CapsuleLabel_Previews.previews)
    }

    func testCapsuleText() {
        assertSnapshot.devices(CapsuleText_Previews.previews)
    }

    func testHorizontalTextDescription() {
        assertSnapshot.devices(HorizontalTextDescription_Previews.previews)
    }

    func testVerticalTextDescription() {
        assertSnapshot.devices(VerticalTextDescription_Previews.previews)
    }

    func testSettingsView() {
        assertSnapshot.devices(SettingsView_Previews.previews)
    }

    func testGenerationMenu() {
        assertSnapshot.devices(GenerationMenuView_Previews.previews)
    }
}
