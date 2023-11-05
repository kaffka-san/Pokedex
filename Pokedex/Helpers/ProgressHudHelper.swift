//
//  ProgressHudHelper.swift
//  hiCarl
//
//  Created by Michal Sverak on 11.09.2023.
//

import Combine
import Foundation
import ProgressHUD

enum ProgressHudHelper {
    static func dismiss(deadline: Double = 0.35) {
        DispatchQueue.main.asyncAfter(deadline: .now() + deadline) {
            ProgressHUD.dismiss()
        }
    }
}

enum ProgressHudState: Equatable {
    case showProgress
    case showSuccess(message: String? = nil)
    case showFailure
    case hide
}

final class ProgressHudBinding {
    private var subscriptions: Set<AnyCancellable> = []

    init(state: Published<ProgressHudState>.Publisher) {
        state
            .receive(on: DispatchQueue.main)
            .sink { state in
                switch state {
                case .showProgress: ProgressHUD.show(interaction: false)
                case let .showSuccess(message): ProgressHUD.showSucceed(message)
                case .showFailure: ProgressHUD.showFailed()
                case .hide: ProgressHudHelper.dismiss()
                }
            }
            .store(in: &subscriptions)
    }
}
