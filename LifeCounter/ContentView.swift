//
//  ContentView.swift
//  LifeCounter
//
//  Created by Loic D on 29/10/2023.
//

import SwiftUI

struct LifeCounterAppView: View {
    let lifePointsViewModel: LifePointsViewModel
    let planeChaseVM: PlanechaseViewModel
    
    init(lifeCounterOptions: LifeOptions, profiles: [PlayerCustomProfile], playWithTreachery: Bool) {
        lifePointsViewModel = LifePointsViewModel(numberOfPlayer: lifeCounterOptions.nbrOfPlayers,
                                                  startingLife: lifeCounterOptions.startingLife, colorPalette: lifeCounterOptions.colorPaletteId, playWithTreachery: playWithTreachery)
        planeChaseVM = PlanechaseViewModel()
    }
    
    var body: some View {
        ZStack {
            // Options
            ZStack(alignment: .bottomLeading) {
                OptionsMenuView()
                    .environmentObject(planeChaseVM)
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        planeChaseVM.gameVM.showLifePointsView.toggle()
                    }
                }, label: {
                    Image(systemName: "xmark")
                        .imageButtonLabel(style: .noBackground)
                })
            }
            
            // LifeApp
            LifePointsView()
                .environmentObject(lifePointsViewModel)
                .environmentObject(planeChaseVM)
                .environmentObject(planeChaseVM.gameVM)
        }
        .background(Color.black)
    }
}

class GameViewModel: ObservableObject {
    @Published var showLifePointsView = true
}

struct LifeOptions: Codable {
    var useLifeCounter: Bool
    var useCommanderDamages: Bool
    var colorPaletteId: Int
    var nbrOfPlayers: Int
    var startingLife: Int
    var backgroundStyleId: Int
    var autoHideLifepointsCooldown: Double
    var useMonarchToken: Bool
    var monarchTokenStyleId: Int
}
