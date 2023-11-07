//
//  test.swift
//  Pokedex
//
//  Created by Anastasia Lenina on 06.11.2023.
//

import SwiftUI

struct test: View {
    var body: some View {
        Image("8")
            .resizable()
            .scaledToFit()
            .frame(width: 300)
            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    test()
}
