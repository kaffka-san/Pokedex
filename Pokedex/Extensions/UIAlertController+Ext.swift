//
//  UIAlertController+Ext.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 28.12.2024.
//

import UIKit

extension UIAlertController {
    func alertDesign(withTitle title: String? = nil, message: String? = nil) {
        if let title = title {
            alertTitleDesign(title: title)
        }

        if let message = message {
            alertMessageDesign(message: message)
        }
    }

    func alertTitleDesign(title: String) {
        let alertTitleFont = UIFont.systemFont(ofSize: 17, weight: .bold)
        let attrString = NSMutableAttributedString(string: title)
        attrString.addAttribute(.font, value: alertTitleFont)
        attrString.addAttribute(.foregroundColor, value: UIColor.label)

        setValue(attrString, forKey: "attributedTitle")
    }

    func alertMessageDesign(message: String) {
        let alertMessageFont = UIFont.systemFont(ofSize: 15, weight: .regular)
        let attrMessageString = NSMutableAttributedString(string: message)
        attrMessageString.addAttribute(.font, value: alertMessageFont)
        attrMessageString.addAttribute(.foregroundColor, value: UIColor.secondaryLabel)

        setValue(attrMessageString, forKey: "attributedMessage")
    }
}
