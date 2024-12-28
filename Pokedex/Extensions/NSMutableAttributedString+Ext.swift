//
//  NSMutableAttributedString+Ext.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 28.12.2024.
//

import Foundation

extension NSMutableAttributedString {
    func addAttribute(_ name: NSAttributedString.Key, value: Any) {
        addAttribute(name, value: value, range: wholeRange)
    }
}

extension NSAttributedString {
    var wholeRange: NSRange {
        return NSMakeRange(0, length)
    }

    /// Returns an array of (value, range) pairs for the given attributed key, where
    /// value of the key is present at the range.
    func attributeRanges<T>(for key: NSAttributedString.Key, in range: NSRange) -> [(value: T, range: NSRange)] {
        var result = [(T, NSRange)]()
        enumerateAttribute(key, in: range, options: []) { val, attrRange, _ in
            guard let val = val as? T else { return }
            result.append((val, attrRange))
        }

        return result
    }
}
