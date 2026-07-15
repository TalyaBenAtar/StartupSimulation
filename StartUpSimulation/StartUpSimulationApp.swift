//
//  StartUpSimulationApp.swift
//  StartUpSimulation
//
//  Created by Talya Benatar on 15/07/2026.
//

import SwiftUI

@main
struct StartUpSimulationApp: App {
    @StateObject private var gameViewModel = GameViewModel()

    var body: some Scene {
        WindowGroup {
            MainMenuView()
                .environmentObject(gameViewModel)
        }
    }
}
