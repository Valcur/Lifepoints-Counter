//
//  LifeCounterApp.swift
//  LifeCounter
//
//  Created by Loic D on 29/10/2023.
//

import SwiftUI

@main
struct LifeCounterApp: App {
    var body: some Scene {
        WindowGroup {
            LifeCounterAppView(lifeCounterOptions: LifeOptions(useLifeCounter: true, useCommanderDamages: true, colorPaletteId: 1, nbrOfPlayers: 4, startingLife: 40, backgroundStyleId: 0, autoHideLifepointsCooldown: -1, useMonarchToken: true, monarchTokenStyleId: 0), profiles: [], playWithTreachery: true).ignoresSafeArea()
                .statusBar(hidden: true)
                .onAppear() {
                    UIApplication.shared.isIdleTimerDisabled = true
                }
        }
    }
}

