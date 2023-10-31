//
//  LifePointsPanelView.swift
//  Planechase
//
//  Created by Loic D on 29/10/2023.
//

import SwiftUI

struct LifePointsPanelView: View {
    @EnvironmentObject var lifePointsViewModel: LifePointsViewModel
    
    let playerName: String
    @Binding var lifepoints: Int
    @Binding var totalChange: Int
    let isMiniView: Bool
    let inverseChangeSide: Bool
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                if !isMiniView {
                    Text(playerName)
                        .font(.title3)
                        .foregroundColor(.white)
                        .shadow(color: isMiniView ? .clear : Color("ShadowColorDarker"), radius: 3, x: 0, y: 0)
                        .frame(height: 20)
                }
                
                Text("\(lifepoints)")
                    .font(.system(size: isMiniView ? 80 : (UIDevice.isIPhone ? 50 : 110)))
                    //.fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: isMiniView ? .clear : Color("ShadowColorDarker"), radius: 3, x: 0, y: 0)
                
                if !isMiniView {
                    Rectangle()
                        .opacity(0)
                        .frame(height: 20)
                }
                Spacer()
            }
            
            if totalChange != 0 {
                VStack {
                    HStack {
                        if !(inverseChangeSide) {
                            Spacer()
                        }
                        Text(totalChange > 0  ? "+\(totalChange)" : "\(totalChange)")
                            .font(UIDevice.isIPhone ? .title2 : .title)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .shadow(color: isMiniView ? .clear : Color("ShadowColorDarker"), radius: 3, x: 0, y: 0)
                            .padding(20)
                        if inverseChangeSide {
                            Spacer()
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}
