//
//  AssertSnapshot.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 05.01.2025.
//

import AckeeSnapshots

public let assertSnapshot = SnapshotTest(
    devices: [
        .iPhone13Pro
    ],

    record: false,
    displayScale: 1,
    contentSizes: [.extraExtraExtraLarge, .large, .small],
    colorSchemes: [.light]
)
