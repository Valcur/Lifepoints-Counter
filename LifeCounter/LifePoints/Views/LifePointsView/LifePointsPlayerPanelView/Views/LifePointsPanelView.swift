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
            VStack {
                Spacer()
                
                if !isMiniView {
                    Text(playerName)
                        .font(.title3)
                        .foregroundColor(.white)
                        .shadow(color: isMiniView ? .clear : Color("ShadowColorDarker"), radius: 3, x: 0, y: 0)
                    
                    Spacer()
                }
                
                Text("\(lifepoints)")
                    .font(.system(size: isMiniView ? 80 : (UIDevice.isIPhone ? 40 : 70)))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: isMiniView ? .clear : Color("ShadowColorDarker"), radius: 3, x: 0, y: 0)
                    .offset(y: UIDevice.isIPhone && !isMiniView ? -10 : 0)
                
                if !isMiniView {
                    Spacer()
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
