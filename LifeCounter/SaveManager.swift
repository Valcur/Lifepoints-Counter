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
    
    static func saveOptions_TreacheryOptions(_ treacheryOptions: TreacheryOptions) {
        if let encoded = try? JSONEncoder().encode(treacheryOptions) {
            UserDefaults.standard.set(encoded, forKey: "TreacheryOptions")
        }
    }
    
    static func getOptions_TreacheryOptions() -> TreacheryOptions {
        if let data = UserDefaults.standard.object(forKey: "TreacheryOptions") as? Data,
           let treacheryOptions = try? JSONDecoder().decode(TreacheryOptions.self, from: data) {
            return treacheryOptions
        }
        return TreacheryOptions(isTreacheryEnabled: false, isUsingUnco: true, isUsingRare: false, isUsingMythic: false)
    }
    
    static func saveOptions_LifePlayerProfiles(_ profiles: [PlayerCustomProfileInfo]) {
        var profilesData = [PlayerCustomProfile]()
        for profile in profiles {
            profilesData.append(PlayerCustomProfile(profile: profile))
        }

        print(profilesData)
        if let encoded = try? JSONEncoder().encode(profilesData) {
            UserDefaults.standard.set(encoded, forKey: "LifePlayerProfilesOptions")
        }
    }
    
    static func saveOptions_LifePlayerProfiles_CustomImage(_ profiles: [PlayerCustomProfileInfo], i: Int) {
        let profile = profiles[i]
        if let data = profile.customImage?.pngData() {
            let encoded = try! PropertyListEncoder().encode(data)
            UserDefaults.standard.set(encoded, forKey: "ProfileImage_\(profile.id)")
        }
    }
    
    static func deleteOptions_LifePlayerProfile_CustomImage(profile: PlayerCustomProfileInfo) {
        UserDefaults.standard.removeObject(forKey: "ProfileImage_\(profile.id)")
    }
    
    static func getOptions_LifePlayerProfiles() -> [PlayerCustomProfileInfo] {
        if let data = UserDefaults.standard.object(forKey: "LifePlayerProfilesOptions") as? Data,
            var profilesData = try? JSONDecoder().decode([PlayerCustomProfile].self, from: data) {
            // Get images
            var profiles = [PlayerCustomProfileInfo]()
            for i in 0..<profilesData.count {
                if let data = UserDefaults.standard.data(forKey: "ProfileImage_\(profilesData[i].id)") {
                    let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
                    profilesData[i].customImageData = decoded
                }
                profiles.append(PlayerCustomProfileInfo(profileData: profilesData[i]))
            }
            return profiles
        }
        return []
    }
    
    static func saveLastUsedSetup(_ setup: LastUsedSetup) {
        if let encoded = try? JSONEncoder().encode(setup) {
            UserDefaults.standard.set(encoded, forKey: "LastUsedSetup")
            print("Saving setup")
        }
    }
    
    static func getLastUsedSetup() -> LastUsedSetup {
        if let data = UserDefaults.standard.object(forKey: "LastUsedSetup") as? Data,
           let setup = try? JSONDecoder().decode(LastUsedSetup.self, from: data) {
            return setup
        }
        return LastUsedSetup.getDefaultSetup()
    }
    
    static func saveOptions_GradientId(_ gradientId: Int) {
        UserDefaults.standard.set(gradientId, forKey: "GradientId")
    }
    
    static func getOptions_GradientId() -> Int {
        return UserDefaults.standard.object(forKey: "GradientId") as? Int ?? 1
    }
    
    static func saveOptions_Toggles(bigCard: Bool, hellride: Bool, noHammer: Bool, noDice: Bool, blurredBackground: Bool, showPlusMinus: Bool) {
        UserDefaults.standard.set(bigCard, forKey: "BiggerCardsOnMap")
        UserDefaults.standard.set(hellride, forKey: "UseHellridePNG")
        UserDefaults.standard.set(noHammer, forKey: "NoHammer")
        UserDefaults.standard.set(noDice, forKey: "NoDice")
        UserDefaults.standard.set(blurredBackground, forKey: "BlurredBackground")
        UserDefaults.standard.set(showPlusMinus, forKey: "ShowPlusMinus")
    }
    
    static func getOptions_Toggles() -> (Bool, Bool, Bool, Bool, Bool, Bool) {
        let bigCards = UserDefaults.standard.object(forKey: "BiggerCardsOnMap") as? Bool ?? false
        let hellRide = UserDefaults.standard.object(forKey: "UseHellridePNG") as? Bool ?? false
        let noHammer = UserDefaults.standard.object(forKey: "NoHammer") as? Bool ?? true
        let noDice = UserDefaults.standard.object(forKey: "NoDice") as? Bool ?? false
        let blurredBackground = UserDefaults.standard.object(forKey: "BlurredBackground") as? Bool ?? false
        let showPlusMinus = UserDefaults.standard.object(forKey: "ShowPlusMinus") as? Bool ?? true
        return (bigCards, hellRide, noHammer, noDice, blurredBackground, showPlusMinus)
    }
}
