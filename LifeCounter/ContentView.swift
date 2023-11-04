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
        planeChaseVM = PlanechaseViewModel()
        lifePointsViewModel = LifePointsViewModel(numberOfPlayer: planeChaseVM.lifeCounterOptions.nbrOfPlayers,
                                                  startingLife: planeChaseVM.lifeCounterOptions.startingLife, colorPalette: planeChaseVM.lifeCounterOptions.colorPaletteId, playWithTreachery: planeChaseVM.treacheryOptions.isTreacheryEnabled, treacheryData: planeChaseVM.treacheryData)
    }
    
    var body: some View {
        ZStack {
            // Options
            
            ZStack(alignment: .bottomLeading) {
                OptionsMenuView()
                    .environmentObject(planeChaseVM)
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        planeChaseVM.gameVM.showLifePointsView = true
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
                .ignoresSafeArea()
        }
        .background(Color.black)
    }
}

class GameViewModel: ObservableObject {
    @Published var showLifePointsView = true
}
