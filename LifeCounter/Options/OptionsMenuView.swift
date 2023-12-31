//
//  OptionsMenuView.swift
//  Planechase
//
//  Created by Loic D on 23/02/2023.
//

import SwiftUI

struct OptionsMenuView: View {
    @EnvironmentObject var planechaseVM: PlanechaseViewModel
    @State var selectedMenu: MenuSelection = .options
    
    var body: some View {
        ZStack {
            Color.black
            
            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    MenuSelectionView(menu: .options, selectedMenu: $selectedMenu)
                    
                    MenuSelectionView(menu: .treachery, selectedMenu: $selectedMenu)
                    
                    MenuSelectionView(menu: .rules, selectedMenu: $selectedMenu)
                    
                    MenuSelectionView(menu: .contact, selectedMenu: $selectedMenu)
                    
                    MenuSelectionView(menu: .thanks, selectedMenu: $selectedMenu)
                    
                    Spacer()
                }.frame(width: 200).padding(.top, 15)
                
                if selectedMenu == .options {
                    LifeOptionsPanel()
                } else if selectedMenu == .contact {
                    ContactPanel()
                } else if selectedMenu == .thanks {
                    ThanksPanel()
                } else if selectedMenu == .rules {
                    RulesPanel()
                } else if selectedMenu == .life {
                    LifeOptionsPanel()
                } else if selectedMenu == .treachery {
                    TreacheryOptionsPanel()
                }
            }
        }
    }
    
    struct MenuSelectionView: View {
        let menu: MenuSelection
        @Binding var selectedMenu: MenuSelection
        
        var body: some View {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    selectedMenu = menu
                }
            }, label: {
                Text(menu.title())
                    .title()
            }).opacity(menu == selectedMenu ? 1 : 0.6)
        }
    }
    
    struct RulesPanel: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 30) {
                Text("options_rules_lifepointsCounter_Title".translate())
                    .title()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("options_rules_lifepointsCounter_01".translate())
                        .headline()
                    
                    Text("options_rules_lifepointsCounter_02".translate())
                        .headline()
                    
                    Text("options_rules_lifepointsCounter_03".translate())
                        .headline()
                }
            }.scrollablePanel()
        }
    }
    
    struct ContactPanel: View {
        var body: some View {
            VStack(spacing: 40) {
                VStack(spacing: 20) {
                    Text("options_contact_discord".translate())
                        .headline()
                    
                    Link(destination: URL(string: "https://discord.com/invite/wzm7bu6KDJ")!) {
                        VStack {
                            Text("options_contact_discordJoin".translate()).headline()
                            Image("Discord")
                                .resizable()
                                .frame(width: 280, height: 78)
                        }
                    }
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("options_contact_link_title".translate())
                            .title()
                        
                        Link(destination: URL(string: "https://apps.apple.com/us/app/planechase-companion/id6445894290?platform=iphone")!) {
                            Text("options_contact_linkPC".translate()).underlinedLink()
                        }
                        Link(destination: URL(string: "https://against-the-horde.com")!) {
                            Text("options_contact_linkHordeWeb".translate()).underlinedLink()
                        }
                        Link(destination: URL(string: "https://apps.apple.com/us/app/against-the-horde/id1631351942?platform=iphone")!) {
                            Text("options_contact_linkHordeiOS".translate()).underlinedLink()
                        }
                    }
                    Spacer()
                }
            }.scrollablePanel()
        }
    }
    
    struct ThanksPanel: View {
        var body: some View {
            VStack(spacing: 20) {
                Text("options_thanks_wizards".translate())
                    .headline()
                    .padding(.bottom, 40)
                
                Text("options_thanks_appIcon".translate())
                    .headline()

                Text("options_thanks_monarch".translate())
                    .headline()
                // shield by Maniprasanth
            }.scrollablePanel()
        }
    }
    
    enum MenuSelection {
        case options
        case contact
        case thanks
        case rules
        case life
        case treachery
        
        func title() -> String {
            switch self {
            case .options:
                return "options_optionsTitle".translate()
            case .contact:
                return "options_contactTitle".translate()
            case .thanks:
                return "options_thanksTitle".translate()
            case .rules:
                return "options_rulesTitle".translate()
            case .life:
                return "options_lifeTitle".translate()
            case .treachery:
                return "Treachery"
            }
        }
    }
}

struct OptionsMenuView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsMenuView()
    }
}
