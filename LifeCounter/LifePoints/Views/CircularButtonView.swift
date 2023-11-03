//
//  CircularButtonView.swift
//  Planechase
//
//  Created by Loic D on 25/10/2023.
//

import SwiftUI

struct CircularButtonView: View {
    @EnvironmentObject var planechaseVM: PlanechaseViewModel
    @EnvironmentObject var lifePointsViewModel: LifePointsViewModel
    @State var showMenu: Bool = true
    let buttons: [AnyView]
    @Binding var lifepointHasBeenUsedToggler: Bool
    
    var body: some View {
        if UIDevice.isIPhone {
            HStack(alignment: .top) {
                Button(action: {
                    withAnimation(.spring()) {
                        showMenu.toggle()
                    }
                    lifepointHasBeenUsedToggler.toggle()
                }, label: {
                    Image(systemName: "chevron.right.circle")
                        .imageButtonLabel(style: .noBackground)
                        .rotationEffect(.degrees(showMenu ? 0 : 180))
                })
                
                if showMenu {
                    VStack {
                        Button(action: {
                            lifePointsViewModel.newGame(numberOfPlayer: planechaseVM.lifeCounterOptions.nbrOfPlayers,
                                                        startingLife: planechaseVM.lifeCounterOptions.startingLife, colorPalette: planechaseVM.lifeCounterOptions.colorPaletteId, playWithTreachery: planechaseVM.treacheryOptions.isTreacheryEnabled,
                                                        treacheryData: planechaseVM.treacheryData)
                        }, label: {
                            Image(systemName: "arrow.counterclockwise.circle")
                                .imageButtonLabel(style: .noBackground)
                        })
                        
                        Spacer()
                        
                        buttons[0]
                        buttons[1]
                        buttons[2]
                        
                        Spacer()
                    }
                }
            }
        } else {
            VStack {
                Button(action: {
                    lifePointsViewModel.newGame(numberOfPlayer: planechaseVM.lifeCounterOptions.nbrOfPlayers,
                                                startingLife: planechaseVM.lifeCounterOptions.startingLife, colorPalette: planechaseVM.lifeCounterOptions.colorPaletteId, playWithTreachery: planechaseVM.treacheryOptions.isTreacheryEnabled,
                                                treacheryData: planechaseVM.treacheryData)
                }, label: {
                    Image(systemName: "arrow.counterclockwise.circle")
                        .imageButtonLabel(style: .noBackground)
                })
                
                Spacer()
                
                buttons[0]
                buttons[1]
                buttons[2]
                
                Spacer()
            }
        }
    }
}
