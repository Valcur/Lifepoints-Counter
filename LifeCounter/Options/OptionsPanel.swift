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

            }.scrollablePanel()
        }
    }
}
