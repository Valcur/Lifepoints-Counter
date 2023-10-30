//
//  CircularButtonView.swift
//  Planechase
//
//  Created by Loic D on 25/10/2023.
//

import SwiftUI

struct CircularButtonView: View {
    @State var showMenu: Bool = false
    let spacing: CGFloat = 80
    let buttons: [AnyView]
    @Binding var lifepointHasBeenUsedToggler: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            if UIDevice.isIPad {
                Button(action: {
                    withAnimation(.spring()) {
                        showMenu.toggle()
                    }
                    lifepointHasBeenUsedToggler.toggle()
                }, label: {
                    Image(systemName: showMenu ? "chevron.down.circle" : "chevron.up.circle")
                        .imageButtonLabel(style: .noBackground)
                })
                
                if showMenu {
                    VStack {
                        buttons[0]
                        buttons[1]
                        buttons[2]
                    }
                }
            }
        }
    }
}
