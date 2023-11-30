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
        if let image = profile.customImage {
            saveUIImage(uiImage: image, fileName: "ProfileImage_\(profile.id).txt")
        }
    }
    
    static func deleteOptions_LifePlayerProfile_CustomImage(profile: PlayerCustomProfileInfo) {
        SaveManager.deleteFromFileManager(fileName: "ProfileImage_\(profile.id).txt")
    }
    
    static func getOptions_LifePlayerProfiles() -> [PlayerCustomProfileInfo] {
        if let data = UserDefaults.standard.object(forKey: "LifePlayerProfilesOptions") as? Data,
            var profilesData = try? JSONDecoder().decode([PlayerCustomProfile].self, from: data) {
            var profiles = [PlayerCustomProfileInfo]()
            for i in 0..<profilesData.count {
                // Get image
                // HANDLING DEPRECATED SYSTEM
                if let deprecatedData = UserDefaults.standard.data(forKey: "ProfileImage_\(profilesData[i].id)") {
                    print("Removing deprecated profile image data")
                    let decoded = try! PropertyListDecoder().decode(Data.self, from: deprecatedData)
                    profilesData[i].customImageData = decoded
                    // Remove deprecated image system
                    UserDefaults.standard.removeObject(forKey: "ProfileImage_\(profilesData[i].id)")
                    if let image = UIImage(data: decoded) {
                        saveUIImage(uiImage: image, fileName: "ProfileImage_\(profilesData[i].id).txt")
                    }
                // END OF HANDLING DEPRECATED SYSTEM
                } else {
                    profilesData[i].customImageData = SaveManager.getSavedUIImageData(fileName: "ProfileImage_\(profilesData[i].id).txt")
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
    
    static func saveOptions_LifeToggles(showPlusMinus: Bool, biggerLifeTotal: Bool, fullscreenCommanderAndCounters: Bool) {
        UserDefaults.standard.set(showPlusMinus, forKey: "ShowPlusMinus")
        UserDefaults.standard.set(biggerLifeTotal, forKey: "BiggerLifeTotal")
        UserDefaults.standard.set(fullscreenCommanderAndCounters, forKey: "FullscreenCommanderAndCounters")
    }
    
    static func getOptions_LifeToggles() -> (Bool, Bool, Bool) {
        let showPlusMinus = UserDefaults.standard.object(forKey: "ShowPlusMinus") as? Bool ?? true
        let biggerLifeTotal = UserDefaults.standard.object(forKey: "BiggerLifeTotal") as? Bool ?? true
        let fullscreenCommanderAndCounters = UserDefaults.standard.object(forKey: "FullscreenCommanderAndCounters") as? Bool ?? UIDevice.isIPhone
        return (showPlusMinus, biggerLifeTotal, fullscreenCommanderAndCounters)
    }
    
    static func getTreacheryRolesRepartition() -> [TreacheryRole] {
        if let data = UserDefaults.standard.object(forKey: "TreacheryRolesRepartition") as? Data,
           let decoded = try? JSONDecoder().decode([TreacheryRole].self, from: data) {
            return decoded
        }
        return TreacheryRole.getDefault()
    }
    
    static func saveTreacheryRolesRepartition(_ roles: [TreacheryRole]) {
        if let encoded = try? JSONEncoder().encode(roles) {
            UserDefaults.standard.set(encoded, forKey: "TreacheryRolesRepartition")
        }
    }
}

// File Manager
extension SaveManager {
    static func deleteFromFileManager(fileName: String) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let customImageURL = documentsURL.appendingPathComponent(fileName)
        do {
            try FileManager.default.removeItem(at: customImageURL)
            print("Successfully deleted file")
        } catch {
            print("Error deleting file: \(error)")
        }
    }
    
    static func getSavedUIImageData(fileName: String) -> Data? {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let customImageURL = documentsURL.appendingPathComponent(fileName)
        
        do {
            let data = try Data(contentsOf: customImageURL)
            let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
            return decoded
        } catch {
            print("Error reading custom image: \(error)")
            return nil
        }
    }
    
    static func getSavedUIImage(fileName: String) -> UIImage? {
        guard let decoded = getSavedUIImageData(fileName: fileName) else {
            return nil
        }
        guard let inputImage = UIImage(data: decoded) else {
            return nil
        }
        return inputImage
    }
    
    static func saveUIImage(uiImage: UIImage?, fileName: String) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let customImageURL = documentsURL.appendingPathComponent(fileName)
        
        guard let image = uiImage else { return }
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        let encoded = try! PropertyListEncoder().encode(data)
        
        do {
            try encoded.write(to: customImageURL)
        } catch {
            print("Error saving custom image to file: \(error)")
        }
    }
}
