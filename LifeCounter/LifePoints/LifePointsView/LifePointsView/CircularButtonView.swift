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
    @State private var showingRestartAlert = false
    @Binding var showMonarchToken: Bool
    @Binding var playersChoosenRandomly: [Bool]
    
    var body: some View {
        ZStack {
            if UIDevice.isIPhone {
                HStack(alignment: .top) {
                    VStack {
                        Button(action: {
                            withAnimation(.spring()) {
                                showMenu.toggle()
                            }
                            lifepointHasBeenUsedToggler.toggle()
                        }, label: {
                            Image(systemName: "chevron.right")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 40, height: 40)
                                .rotationEffect(.degrees(showMenu ? 180 : 0))
                                .offset(x: 14, y: 10)
                        })
                        Spacer()
                    }
                    
                    if showMenu {
                        VStack {
                            Spacer()
                            
                            Button(action: {
                                showingRestartAlert = true
                            }, label: {
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 40, height: 40)
                            })
                            
                            buttons[0]
                            buttons[1]
                            buttons[2]
                            buttons[3]
                            
                            Spacer()
                        }
                    }
                }
            } else {
                VStack {
                    Spacer()
                    
                    Button(action: {
                        showingRestartAlert = true
                    }, label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 40, height: 40)
                    })
                    
                    buttons[0]
                    buttons[1]
                    buttons[2]
                    buttons[3]
                    
                    Spacer()
                }
            }
        }
        .alert(isPresented: $showingRestartAlert) {
            Alert(
                title: Text("game_exit_title".translate()),
                message: Text("game_exit_content".translate()),
                primaryButton: .destructive(Text("confirm".translate())) {
                    resetGame()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    func resetGame() {
        showMonarchToken = false
        lifePointsViewModel.newGame(numberOfPlayer: planechaseVM.lifeCounterOptions.nbrOfPlayers,
                                    startingLife: planechaseVM.lifeCounterOptions.startingLife, colorPalette: planechaseVM.lifeCounterOptions.colorPaletteId, playWithTreachery: planechaseVM.treacheryOptions.isTreacheryEnabled,
                                    treacheryData: planechaseVM.treacheryData,
                                    customProfiles: planechaseVM.lifeCounterProfiles)
        
        if !planechaseVM.treacheryOptions.isTreacheryEnabled {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                let player = Int.random(in: 0..<lifePointsViewModel.numberOfPlayer)
                playersChoosenRandomly[player] = true
                withAnimation(.easeInOut(duration: 1).delay(0.15)) {
                    playersChoosenRandomly[player] = false
                }
            }
        }
    }
}
