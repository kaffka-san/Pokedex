//
//  SettingsView.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 06.11.2023.
//

import SwiftUI

struct SettingsView<FilterViewData: FilterViewConfigurable>: View {
    var config: FilterViewData
    @State var showAllGeneration = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            background
            settingButtons
                .sheet(isPresented: $showAllGeneration) {
                    generationMenu
                }
                .padding(.trailing, 26)
        }
    }
}

private extension SettingsView {
    var background: some View {
        Rectangle()
            .fill(.black)
            .opacity(0.6)
            .ignoresSafeArea()
            .onTapGesture {
                config.responseHandler(.close)
            }
    }

    var settingButtons: some View {
        VStack(alignment: .trailing) {
            ForEach(SettingsOption.allCases, id: \.self) { option in
                CapsuleLabel(data: CapsuleLabelConfiguration(
                    text: option.text,
                    image: option.image
                ))
                .onTapGesture {
                    handleTap(for: option)
                }
            }
            closeButton()
        }
    }

    @ViewBuilder
    func closeButton() -> some View {
        Image(fromImageLiteral: .close)
            .padding(.top, 10)
            .onTapGesture {
                config.responseHandler(.close)
            }
    }

    var generationMenu: some View {
        GenerationMenuView { generation in
            showAllGeneration.toggle()
            config.responseHandler(.generationSelected(generationId: generation.index))
        }
    }
}

// MARK: - Utilities
private extension SettingsView {
    func handleTap(for option: SettingsOption) {
        switch option {
        case .favourite:
            config.responseHandler(.favouriteSelected)
            config.responseHandler(.close)
        case .allTypes:
            config.responseHandler(.showAll)
        case .allGenerations:
            showAllGeneration.toggle()
        }
    }
}

// MARK: - Setting view configuration
private extension SettingsView {
    enum SettingsOption: Hashable, CaseIterable {
        case favourite
        case allTypes
        case allGenerations

        var text: String {
            switch self {
            case .favourite: return LocalizedString.Settings.favouritePokemon
            case .allTypes: return LocalizedString.Settings.allType
            case .allGenerations: return LocalizedString.Settings.allGen
            }
        }

        var image: ImageName {
            switch self {
            case .favourite: return .loveFill
            case .allTypes, .allGenerations: return .pokeballFill
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            config: FilterViewConfiguration(responseHandler: { _ in })
        )
    }
}
