//
//  OptionsPanel.swift
//  Planechase
//
//  Created by Loic D on 12/03/2023.
//

import SwiftUI

extension OptionsMenuView {
    struct OptionsPanel: View {
        @EnvironmentObject var planechaseVM: PlanechaseViewModel
        
        var body: some View {
            VStack(alignment: .leading, spacing: 15) {
                Text("Treachery".translate())
                    .title()
                
                Toggle("Enabled".translate(), isOn: $planechaseVM.treacheryOptions.isTreacheryEnabled)
                    .font(.subheadline).foregroundColor(.white)
                
                Text("recommanded".translate())
                    .headline()
                
                Toggle("Unco".translate(), isOn: $planechaseVM.treacheryOptions.isUsingUnco)
                    .font(.subheadline).foregroundColor(.white)
                
                Toggle("rare".translate(), isOn: $planechaseVM.treacheryOptions.isUsingRare)
                    .font(.subheadline).foregroundColor(.white)
                
                Toggle("mythic".translate(), isOn: $planechaseVM.treacheryOptions.isUsingMythic)
                    .font(.subheadline).foregroundColor(.white)
                
                
            }.scrollablePanel()
            .onChange(of: planechaseVM.treacheryOptions.isTreacheryEnabled) { _ in
                planechaseVM.saveTreacheryOptions()
            }
            .onChange(of: planechaseVM.treacheryOptions.isUsingUnco) { _ in
                planechaseVM.saveTreacheryOptions()
            }
            .onChange(of: planechaseVM.treacheryOptions.isUsingRare) { _ in
                planechaseVM.saveTreacheryOptions()
            }
            .onChange(of: planechaseVM.treacheryOptions.isUsingMythic) { _ in
                planechaseVM.saveTreacheryOptions()
            }
        }
    }
}
