//
//  LifePointsPanelBackground.swift
//  LifeCounter
//
//  Created by Loic D on 30/10/2023.
//

import SwiftUI

extension LifePointsPlayerPanelView {
    struct LifePointsPanelBackground: View {
        @EnvironmentObject var planechaseVM: PlanechaseViewModel
        @Binding var player: PlayerProfile
        let isMiniView: Bool
        let isPlayerOnOppositeSide: Bool
        let gradientOverlay = Gradient(colors: [.black.opacity(0.4), .black.opacity(0.1), .black.opacity(0.1), .black.opacity(0.1), .black.opacity(0.4)])
        let blurEffect: UIBlurEffect.Style = .systemChromeMaterialDark
        
        var body: some View {
            Group {
                if let image = player.backgroundImage {
                    ZStack {
                        GeometryReader { geo in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .clipped()
                        }
                        if !isMiniView {
                            LinearGradient(gradient: gradientOverlay, startPoint: .leading, endPoint: .trailing)
                        }
                    }
                } else {
                    if planechaseVM.lifeCounterOptions.colorPaletteId == -1 {
                        VisualEffectView(effect: UIBlurEffect(style: blurEffect))
                    } else {
                        //players[playerId].backgroundColor
                        player.backgroundColor
                    }
                }
                
                if planechaseVM.isTreacheryEnable && !isMiniView {
                    TreacheryCardView(player: $player, putCardOnTheRight: isPlayerOnOppositeSide)
                }
                
                Color.black.opacity(0.1)
            }
        }
    }
}
