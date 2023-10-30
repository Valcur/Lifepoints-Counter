//
//  SaveManager.swift
//  Planechase
//
//  Created by Loic D on 20/02/2023.
//

import SwiftUI

class SaveManager {
    
}

// Options
extension SaveManager {
    static func saveOptions_LifeOptions(_ lifeOptions: LifeOptions) {
        if let encoded = try? JSONEncoder().encode(lifeOptions) {
            UserDefaults.standard.set(encoded, forKey: "LifeOptions")
        }
    }
    
    static func getOptions_LifeOptions() -> LifeOptions {
        if let data = UserDefaults.standard.object(forKey: "LifeOptions") as? Data,
           let lifeOptions = try? JSONDecoder().decode(LifeOptions.self, from: data) {
            return lifeOptions
        }
        return LifeOptions(useLifeCounter: true, useCommanderDamages: true, colorPaletteId: 0, nbrOfPlayers: 4, startingLife: 40, backgroundStyleId: -1, autoHideLifepointsCooldown: -1,  useMonarchToken: true, monarchTokenStyleId: -1)
    }
    
    static func saveOptions_LifePlayerProfiles(_ profiles: [PlayerCustomProfile]) {
        var profilesData = profiles
        for i in 0..<profilesData.count {
            profilesData[i].customImageData = nil
        }
        print(profilesData)
        if let encoded = try? JSONEncoder().encode(profilesData) {
            UserDefaults.standard.set(encoded, forKey: "LifePlayerProfilesOptions")
        }
    }
    
    static func saveOptions_LifePlayerProfiles_CustomImage(_ profiles: [PlayerCustomProfile], i: Int) {
        let profile = profiles[i]
        if let data = profile.customImageData {
            let encoded = try! PropertyListEncoder().encode(data)
            UserDefaults.standard.set(encoded, forKey: "ProfileImage_\(profile.id)")
        }
    }
    
    static func deleteOptions_LifePlayerProfile_CustomImage(profile: PlayerCustomProfile) {
        UserDefaults.standard.removeObject(forKey: "ProfileImage_\(profile.id)")
    }
    
    static func getOptions_LifePlayerProfiles() -> [PlayerCustomProfile] {
        if let data = UserDefaults.standard.object(forKey: "LifePlayerProfilesOptions") as? Data,
            var profiles = try? JSONDecoder().decode([PlayerCustomProfile].self, from: data) {
            // Get images
            for i in 0..<profiles.count {
                if let data = UserDefaults.standard.data(forKey: "ProfileImage_\(profiles[i].id)") {
                    let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
                    profiles[i].customImageData = decoded
                }
            }
            
            return profiles
        }
        return []
    }
    
    static func saveOptions_GradientId(_ gradientId: Int) {
        UserDefaults.standard.set(gradientId, forKey: "GradientId")
    }
    
    static func getOptions_GradientId() -> Int {
        return UserDefaults.standard.object(forKey: "GradientId") as? Int ?? 1
    }
    
    static func saveOptions_Toggles(bigCard: Bool, hellride: Bool, noHammer: Bool, noDice: Bool, blurredBackground: Bool) {
        UserDefaults.standard.set(bigCard, forKey: "BiggerCardsOnMap")
        UserDefaults.standard.set(hellride, forKey: "UseHellridePNG")
        UserDefaults.standard.set(noHammer, forKey: "NoHammer")
        UserDefaults.standard.set(noDice, forKey: "NoDice")
        UserDefaults.standard.set(blurredBackground, forKey: "BlurredBackground")
    }
    
    static func getOptions_Toggles() -> (Bool, Bool, Bool, Bool, Bool) {
        let bigCards = UserDefaults.standard.object(forKey: "BiggerCardsOnMap") as? Bool ?? false
        let hellRide = UserDefaults.standard.object(forKey: "UseHellridePNG") as? Bool ?? false
        let noHammer = UserDefaults.standard.object(forKey: "NoHammer") as? Bool ?? true
        let noDice = UserDefaults.standard.object(forKey: "NoDice") as? Bool ?? false
        let blurredBackground = UserDefaults.standard.object(forKey: "BlurredBackground") as? Bool ?? false
        return (bigCards, hellRide, noHammer, noDice, blurredBackground)
    }
}
