//
//  LifePointsPlayerPanelView.swift
//  Planechase
//
//  Created by Loic D on 30/05/2023.
//

import SwiftUI

struct LifePointsPlayerPanelView: View {
    @EnvironmentObject var planechaseVM: PlanechaseViewModel
    @EnvironmentObject var lifePointsViewModel: LifePointsViewModel
    let playerId: Int
    var players: [PlayerProfile] {
        lifePointsViewModel.players
    }
    @Binding var player: PlayerProfile
    @State var prevValue: CGFloat = 0
    @State var totalChange: Int = 0
    @State var totalChangeTimer: Timer?
    let blurEffect: UIBlurEffect.Style = .systemChromeMaterialDark
    let isMiniView: Bool
    let hasBeenChoosenRandomly: Bool
    @Binding var lifepointHasBeenUsedToggler: Bool
    @State private var showingCountersSheet = false
    @State var showTreacheryPanel: Bool = false
    @State var showAlternativeCounters: Bool = false
    var isPlayerOnTheSide: Bool {
        playerId == 0 && lifePointsViewModel.numberOfPlayer % 2 == 1
    }
    var isPlayerOnOppositeSide: Bool {
        (playerId < lifePointsViewModel.numberOfPlayer / 2 + lifePointsViewModel.numberOfPlayer % 2) && (!isPlayerOnTheSide)
    }
    var hideUIElementOpacity: CGFloat {
        !isMiniView && (showAlternativeCounters) ? 0 : 1
    }
    @Binding var isAllowedToChangeProfile: Bool
    
    var body: some View {
        ZStack {
            CommanderDamagesPanel(showSheet: $showingCountersSheet, playerCounters: $player.counters, lifePoints: $player.lifePoints, playerId: playerId)
                .cornerRadius(isMiniView ? 0 : 15).padding(isMiniView ? 0 : (UIDevice.isIPhone ? 2 : 10))
                .allowsHitTesting(showingCountersSheet)
                .opacity(showingCountersSheet ? 1 : 0)

            ZStack(alignment: .bottom) {
                LifePointsPanelBackground(player: $player, isMiniView: isMiniView, isPlayerOnOppositeSide: isPlayerOnOppositeSide)
                
                LifePointsPanelView(playerName: player.name, lifepoints: $player.lifePoints, totalChange: $totalChange, isMiniView: isMiniView, inverseChangeSide: isPlayerOnOppositeSide || isPlayerOnTheSide)
                    .cornerRadius(15)
                    .opacity(hideUIElementOpacity)
                
                if !isMiniView {
                    ZStack {
                        HStack {
                            Spacer()
                            VStack {
                                Spacer()
                                Image(systemName: "plus")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .opacity(0.5)
                                Spacer()
                                Spacer()
                                Image(systemName: "minus")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .opacity(0.5)
                                Spacer()
                            }
                        }.padding(10)
                        VStack(spacing: 0) {
                            Rectangle()
                                .opacity(0.0001)
                                .onTapGesture {
                                    addLifepoint()
                                    startTotalChangeTimer()
                                }
                            Rectangle()
                                .opacity(0.0001)
                                .onTapGesture {
                                    removeLifepoint()
                                    startTotalChangeTimer()
                                }
                        }
                    }
                    
                    if planechaseVM.treacheryOptions.isTreacheryEnabled {
                        GeometryReader { geo in
                            HStack {
                                if isPlayerOnOppositeSide {
                                    Spacer()
                                }
                                Button(action: {
                                    showTreacheryPanel = true
                                    lifepointHasBeenUsedToggler.toggle()
                                }, label: {
                                    Color.black
                                        .frame(width: CardSizes.classic_widthForHeight(geo.size.height ) - (geo.size.height / 3))
                                        .opacity(0.000001)
                                })
                                if !isPlayerOnOppositeSide {
                                    Spacer()
                                }
                            }
                        }
                    }
                    
                    if planechaseVM.lifeCounterOptions.useCommanderDamages {
                        VStack {
                            HStack(alignment: .center, spacing: 0) {
                                ForEach(0..<player.counters.alternativeCounters.count, id: \.self) { i in
                                    if let value = player.counters.alternativeCounters[i].value, value > 0 {
                                        CounterRecapView(value: value, counter: player.counters.alternativeCounters[i])
                                            .padding(4)
                                    }
                                }
                            }
                            .background(VisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialDark)))
                            .cornerRadius(8)
                            .opacity(hideUIElementOpacity)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showAlternativeCounters = true
                                }
                                lifepointHasBeenUsedToggler.toggle()
                            }
                            Spacer()
                        }.padding(.top, 8)
                    }
                    
                    if !showAlternativeCounters {
                        VStack {
                            Spacer()
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showAlternativeCounters = true
                                }
                                lifepointHasBeenUsedToggler.toggle()
                            }, label: {
                                Rectangle()
                                    .foregroundColor(.black.opacity(0.5))
                                    .frame(width: 100, height: 150)
                            })
                            Spacer()
                        }
                    }
                    
                    if planechaseVM.lifeCounterOptions.useCommanderDamages {
                        VStack {
                            Spacer()
                            CommanderRecapView(playerId: playerId, lifePoints: $player.lifePoints, playerCounters: $player.counters)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        showingCountersSheet = true
                                    }
                                    lifepointHasBeenUsedToggler.toggle()
                                }
                        }.padding(22)
                    }
                
                    Group {
                        if showAlternativeCounters {
                            AlternativeCountersView(counters: $player.counters.alternativeCounters, playerId: playerId, showAlternativeCounters: $showAlternativeCounters)
                        }
                        if isAllowedToChangeProfile {
                            ProfileSelector(playerId: playerId, player: $player, lifepointHasBeenUsedToggler: $lifepointHasBeenUsedToggler)
                        }
                        if showTreacheryPanel {
                            TreacheryPanelView(treacheryData: $player.treachery, showPanel: $showTreacheryPanel, lifepointHasBeenUsedToggler: $lifepointHasBeenUsedToggler, isOnTheOppositeSide: isPlayerOnOppositeSide)
                        }
                    }
                }
                
            }.cornerRadius(isMiniView ? 0 : 0).padding(0).padding(.horizontal, isMiniView ? 0 : (isPlayerOnTheSide ? 0 : 0)).padding(.top, isMiniView ? 0 : (isPlayerOnTheSide ? 0 : 0))
                .gesture(DragGesture()
                    .onChanged { value in
                        if !showTreacheryPanel {
                            let newValue = value.translation.height
                            if newValue > prevValue + 6 {
                                prevValue = newValue
                                removeLifepoint()
                            }
                            else if newValue < prevValue - 6 {
                                prevValue = newValue
                                addLifepoint()
                            }
                        }
                    }
                    .onEnded({ _ in
                        if !showTreacheryPanel {
                            startTotalChangeTimer()
                        }
                    })
                )
                .allowsHitTesting(!showingCountersSheet)
                .opacity(!showingCountersSheet ? 1 : 0)
            
            Color.black.opacity(player.lifePoints > 0 ? 0 : 0.7).allowsHitTesting(false)
            
            Color.white.opacity(hasBeenChoosenRandomly ? 1 : 0).cornerRadius(20).padding(isMiniView ? 0 : (UIDevice.isIPhone ? 1 : 1)).allowsHitTesting(false)
        }
    }
    
    private func addLifepoint() {
        totalChangeTimer?.invalidate()
        player.lifePoints += 1
        totalChange += 1
        lifepointHasBeenUsedToggler.toggle()
    }
    
    private func removeLifepoint() {
        totalChangeTimer?.invalidate()
        player.lifePoints -= 1
        totalChange -= 1
        lifepointHasBeenUsedToggler.toggle()
    }
    
    private func startTotalChangeTimer() {
        totalChangeTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
            totalChange = 0
        }
    }
    
    struct CounterRecapView: View {
        let value: Int
        let counter: AlternativeCounter
        let size: CGFloat = 40
        
        var body: some View {
            VStack(spacing: 0) {
                Image(counter.imageName)
                    .resizable()
                    .frame(width: size, height: size)
                    .foregroundColor(Color.white)
                    .opacity(0.6)
                
                Text("\(value)")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                    .shadow(color: Color("ShadowColorDarker"), radius: 3, x: 0, y: 0)
            }
        }
    }
    
    struct ProfileSelector: View {
        @EnvironmentObject var lifePointsViewModel: LifePointsViewModel
        @EnvironmentObject var planechaseVM: PlanechaseViewModel
        let playerId: Int
        @Binding var player: PlayerProfile
        @Binding var lifepointHasBeenUsedToggler: Bool
        var body: some View {
            HStack {
                VStack {
                    ScrollView(.vertical) {
                        VStack {
                            Button(action: {
                                applyProfile(profile: nil, slot: playerId)
                            }, label: {
                                Text("lifepoints_noProfile".translate())
                                    .textButtonLabel()
                            }).padding(.top, 5)
                            ForEach(0..<planechaseVM.lifeCounterProfiles.count, id: \.self) { i in
                                if let profile = planechaseVM.lifeCounterProfiles[i] {
                                    Button(action: {
                                        applyProfile(profile: profile, slot: playerId)
                                    }, label: {
                                        Text(profile.name)
                                            .textButtonLabel(style: player.id == profile.id ? .secondary : .primary)
                                    })
                                }
                            }
                        }.frame(maxWidth: .infinity)
                    }
                }.background(VisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.systemMaterialDark))).frame(maxWidth: 250)
                Spacer()
            }
        }
        
        func applyProfile(profile: PlayerCustomProfile?, slot: Int) {
            let oldPartnerValue = player.partnerEnabled
            if let profile = profile {
                withAnimation(.easeInOut(duration: 0.3)) {
                    var backgroundImage: UIImage? = nil
                    if let imageData = profile.customImageData {
                        if let image = UIImage(data: imageData) {
                            backgroundImage = image
                        }
                    }
                    
                    player.backgroundImage = backgroundImage
                    player.id = profile.id
                    player.name = profile.name
                }
            } else {
                withAnimation(.easeInOut(duration: 0.3)) {
                    player.backgroundImage = nil
                    player.id = UUID()
                    player.name = "\("lifepoints_player".translate()) \(playerId + 1)"
                }
            }
            lifepointHasBeenUsedToggler.toggle()
            lifePointsViewModel.lastUsedSetup.playersProfiles[playerId] = profile
            cancelLastUsedSlot(slot: playerId)
            planechaseVM.saveProfiles_Info()
            if player.partnerEnabled != oldPartnerValue {
                lifePointsViewModel.togglePartnerForPlayer(playerId)
                lifePointsViewModel.savePartnerForPlayer(playerId)
            }
        }
        
        func cancelLastUsedSlot(slot: Int) {
            for i in 0..<lifePointsViewModel.players.count {
                if lifePointsViewModel.players[i].id == player.id && i != slot {
                    print("Found at \(i) for \(slot)")
                    withAnimation(.easeInOut(duration: 0.3)) {
                        lifePointsViewModel.lastUsedSetup.playersProfiles[i] = nil
                        lifePointsViewModel.players[i].backgroundImage = nil
                        lifePointsViewModel.players[i].id = UUID()
                        lifePointsViewModel.players[i].name = "\("lifepoints_player".translate()) \(i + 1)"
                    }
                }
            }
            SaveManager.saveLastUsedSetup(lifePointsViewModel.lastUsedSetup)
            print(lifePointsViewModel.lastUsedSetup)
        }
    }
    
    struct CommanderRecapView: View {
        @EnvironmentObject var lifePointsViewModel: LifePointsViewModel
        var halfNumberOfPlayers: Int {
            lifePointsViewModel.numberOfPlayer / 2
        }
        var isPlayerOnTheSide: Bool {
            playerId == 0 && lifePointsViewModel.numberOfPlayer % 2 == 1
        }
        let playerId: Int
        @Binding var lifePoints: Int
        @Binding var playerCounters: PlayerCounters
        
        var body: some View {
            HStack {
                Spacer()
                ZStack {
                    Color.black.opacity(0.00001)
                    
                    if lifePointsViewModel.numberOfPlayer % 2 == 0 {
                        EvenBlueprint(row1: AnyView(HStack(spacing: 0) {
                            ForEach(1...halfNumberOfPlayers, id: \.self) { i in
                                CommanderDamageRecapPanelView(damageTaken: $playerCounters.commanderDamages[i - 1])
                                    .commanderDamageToYourself(i - 1 == playerId)
                            }
                        }), row2: AnyView(HStack(spacing: 0) {
                            ForEach(1...halfNumberOfPlayers, id: \.self) { i in
                                CommanderDamageRecapPanelView(damageTaken: $playerCounters.commanderDamages[i + halfNumberOfPlayers - 1])
                                    .commanderDamageToYourself(i + halfNumberOfPlayers - 1 == playerId)
                            }
                        }))
                    } else {
                        UnevenBlueprint(row1: AnyView(HStack(spacing: 0) {
                            ForEach(1...halfNumberOfPlayers, id: \.self) { i in
                                CommanderDamageRecapPanelView(damageTaken: $playerCounters.commanderDamages[i])
                                    .commanderDamageToYourself(i == playerId)
                            }
                        }),
                                        row2: AnyView(                    HStack(spacing: 0) {
                            ForEach(1...halfNumberOfPlayers, id: \.self) { i in
                                CommanderDamageRecapPanelView(damageTaken: $playerCounters.commanderDamages[i + halfNumberOfPlayers])
                                    .commanderDamageToYourself(i + halfNumberOfPlayers == playerId)
                            }
                        }),
                                        sideElement: AnyView(CommanderDamageRecapPanelView(damageTaken: $playerCounters.commanderDamages[0])                        .commanderDamageToYourself(0 == playerId))
                        )
                    }
                }
                .frame(maxWidth: 200).frame(maxHeight: UIDevice.isIPhone ? 100 : 100)
                .rotationEffect(.degrees(isPlayerOnTheSide ? 90 : (playerId < halfNumberOfPlayers + lifePointsViewModel.numberOfPlayer % 2 ? 180 : 0)))
                .frame(maxWidth: 200).frame(maxHeight: isPlayerOnTheSide ? 200 : (UIDevice.isIPhone ? 100 : 100))
                // iPhone scaling THIS IS UGLY AS FUCK
                //.offset(y: UIDevice.isIPhone ? (isPlayerOnTheSide ? -60 : 0) : (isPlayerOnTheSide ? 20 : 0))
                //.offset(x: isPlayerOnTheSide ? (UIDevice.isIPhone ? 110 : 10) : 0)
                .scaleEffect(UIDevice.isIPhone ? 0.6 : 1, anchor: .bottom)
                
                if !isPlayerOnTheSide {
                    Spacer()
                }
            }//.frame(maxHeight: .infinity, alignment: isPlayerOnTheSide ? .center : .bottom)
        }
        
        struct CommanderDamageRecapPanelView: View {
            let blurEffect: UIBlurEffect.Style = .systemThinMaterialDark
            @Binding var damageTaken: [Int]
            
            var body: some View {
                HStack(spacing: 2) {
                    ForEach(0..<damageTaken.count, id: \.self) { i in
                        ZStack {
                            VisualEffectView(effect: UIBlurEffect(style: blurEffect))
                            Text("\(damageTaken[i])")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                }.cornerRadius(10).padding(2)
            }
        }
    }
}
