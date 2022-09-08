//
//  Pokemon3App.swift
//  Pokemon3
//
//  Created by Alexandr Rodionov on 2.09.22.
//

import SwiftUI

@main
struct Pokemon3App: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("Pokemons")
            }
        }
    }
}
