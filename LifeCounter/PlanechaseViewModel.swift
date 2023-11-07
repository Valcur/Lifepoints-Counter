//
//  PlanechaseViewModel.swift
//  LifeCounter
//
//  Created by Loic D on 29/10/2023.
//

import Foundation
import SwiftUI

class PlanechaseViewModel: ObservableObject {
    var gameVM: GameViewModel
    @Published var isPlaying = false
    @Published var useHellridePNG: Bool
    @Published var biggerCardsOnMap: Bool
    @Published var noHammerRow: Bool
    @Published var noDice: Bool
    @Published var showPlusMinus: Bool
    @Published var lifeCounterOptions: LifeOptions
    var lifeCounterProfiles: [PlayerCustomProfileInfo]
    @Published var isPremium = false
    @Published var showDiscordInvite = false
    @Published var paymentProcessing = false
    @Published var useBlurredBackground = false
    @Published var treacheryOptions: TreacheryOptions
    @Published var treacheryData: TreacheryData
    
    init() {
        let optionToggles = SaveManager.getOptions_Toggles()
        biggerCardsOnMap = optionToggles.0
        useHellridePNG = optionToggles.1
        noHammerRow = optionToggles.2
        noDice = optionToggles.3
        useBlurredBackground = optionToggles.4
        showPlusMinus = optionToggles.5
        lifeCounterOptions = SaveManager.getOptions_LifeOptions()
        lifeCounterProfiles = SaveManager.getOptions_LifePlayerProfiles()
        treacheryOptions = SaveManager.getOptions_TreacheryOptions()
        treacheryData = TreacheryData()
        
        gameVM = GameViewModel()
        isPremium = UserDefaults.standard.object(forKey: "IsPremium") as? Bool ?? false
        showDiscordInvite = UserDefaults.standard.object(forKey: "ShowDiscordInvite") as? Bool ?? true
        treacheryData.filter(getSelectedRarities())
    }
    
    func setLifeOptions(_ life: LifeOptions) {
        withAnimation(.easeInOut(duration: 0.3)) {
            lifeCounterOptions = life
        }
        SaveManager.saveOptions_LifeOptions(life)
    }
    
    func saveTreacheryOptions() {
        SaveManager.saveOptions_TreacheryOptions(treacheryOptions)
    }
    
    func saveProfiles_Info() {
        SaveManager.saveOptions_LifePlayerProfiles(lifeCounterProfiles)
    }
    
    func saveProfiles_Image(index: Int) {
        SaveManager.saveOptions_LifePlayerProfiles_CustomImage(lifeCounterProfiles, i: index)
    }
    
    func saveToggles() {
        SaveManager.saveOptions_Toggles(bigCard: biggerCardsOnMap, hellride: useHellridePNG, noHammer: noHammerRow, noDice: noDice, blurredBackground: useBlurredBackground, showPlusMinus: showPlusMinus)
    }
    
    func getSelectedRarities() -> [TreacheryData.Rarity] {
        var rarities = [TreacheryData.Rarity]()
        if treacheryOptions.isUsingUnco {
            rarities.append(.unco)
        }
        if treacheryOptions.isUsingRare {
            rarities.append(.rare)
        }
        if treacheryOptions.isUsingMythic {
            rarities.append(.mythic)
        }
        return rarities
    }
}
