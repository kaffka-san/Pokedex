//
//  UIView+Ext.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 28.12.2024.
//

import UIKit

extension UIView {
    enum FadeStyle {
        case `in`, out, inOut
    }

    func fade(_ style: FadeStyle, duration: Double = 0.2, finished: (() -> Void)? = nil) {
        layer.removeAllAnimations()
        switch style {
        case .in:
            isHidden = false
            UIView.animate(withDuration: duration, animations: { [weak self] in
                self?.alpha = 1
            }) { _ in
                finished?()
            }
        case .out:
            UIView.animate(withDuration: duration, animations: { [weak self] in
                self?.alpha = 0
            }) { [weak self] in
                self?.isHidden = $0
                finished?()
            }
        case .inOut:
            fade(.out) { [weak self] in
                self?.fade(.in, finished: {
                    finished?()
                })
            }
        }
    }
}
