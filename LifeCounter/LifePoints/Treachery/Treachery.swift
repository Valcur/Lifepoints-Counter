//
//  Treachery.swift
//  Planechase
//
//  Created by Loic D on 17/10/2023.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct TreacheryPlayer {
    var role: TreacheryRole
    var cardImageName: String
    var roleUrl: String
    var QRCode: UIImage
    var isRoleRevealed: Bool
    
    init(role: TreacheryRole, data: TreacheryData) {
        self.role = role
        self.isRoleRevealed = true //role == .leader ? true : false
        let roleData = data.getRandomRole(role) ?? TreacheryData.TreacheryRoleData(name: "", rarity: .unco, role: .traitor)
        self.roleUrl = roleData.roleUrl
        self.cardImageName = roleData.name
        self.QRCode = UIImage()
        self.QRCode = generateQRCode(from: roleData.roleUrl)
    }
    
    func generateQRCode(from string: String) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    static func getRandomizedRoleArray(nbrOfPlayer: Int) -> [TreacheryRole] {
        var array = [TreacheryRole]()
        if nbrOfPlayer >= 2 {
            array.append(.leader)
            array.append(.traitor)
        }
        if nbrOfPlayer >= 3 {
            array.append(.assassin)
        }
        if nbrOfPlayer >= 4 {
            array.append(.assassin)
        }
        if nbrOfPlayer >= 5 {
            array.append(.guardian)
        }
        if nbrOfPlayer >= 6 {
            array.append(.assassin)
        }
        if nbrOfPlayer >= 7 {
            array.append(.guardian)
        }
        if nbrOfPlayer >= 8 {
            array.append(.traitor)
        }
        return array.shuffled()
    }
}

class TreacheryData: ObservableObject {
    let allLeaders = [
        TreacheryRoleData(name: "The Blood Empress", rarity: .unco, role: .leader),
        TreacheryRoleData(name: "The Chaos Bringer", rarity: .unco, role: .leader),
        TreacheryRoleData(name: "The Corrupted Regent", rarity: .mythic, role: .leader),
        TreacheryRoleData(name: "The Gathering", rarity: .mythic, role: .leader),
        TreacheryRoleData(name: "Her Seedborn Highness", rarity: .unco, role: .leader),
        TreacheryRoleData(name: "His Beloved Majesty", rarity: .mythic, role: .leader),
        TreacheryRoleData(name: "The King over the Scrapyard", rarity: .rare, role: .leader),
        TreacheryRoleData(name: "The Old Ruler", rarity: .unco, role: .leader),
        TreacheryRoleData(name: "The Queen of Light", rarity: .unco, role: .leader),
        TreacheryRoleData(name: "The Twin Princesses", rarity: .rare, role: .leader),
        TreacheryRoleData(name: "The Void Tyrant", rarity: .rare, role: .leader)
    ]
    
    let allGuardians = [
        TreacheryRoleData(name: "The Ætherist", rarity: .rare, role: .guardian),
        TreacheryRoleData(name: "The Augur", rarity: .rare, role: .guardian),
        TreacheryRoleData(name: "The Bodyguard", rarity: .unco, role: .guardian),
        TreacheryRoleData(name: "The Cathar", rarity: .unco, role: .guardian),
        TreacheryRoleData(name: "The Cryomancer", rarity: .rare, role: .guardian),
        TreacheryRoleData(name: "The Flickering Mage", rarity: .unco, role: .guardian),
        TreacheryRoleData(name: "The Golem", rarity: .unco, role: .guardian),
        TreacheryRoleData(name: "The Great Martyr", rarity: .mythic, role: .guardian),
        TreacheryRoleData(name: "The Hieromancer", rarity: .rare, role: .guardian),
        TreacheryRoleData(name: "The Immortal", rarity: .rare, role: .guardian),
        TreacheryRoleData(name: "The Marshal", rarity: .unco, role: .guardian),
        TreacheryRoleData(name: "The Oracle", rarity: .mythic, role: .guardian),
        TreacheryRoleData(name: "The Spellsnatcher", rarity: .unco, role: .guardian),
        TreacheryRoleData(name: "The Summoner", rarity: .rare, role: .guardian),
        TreacheryRoleData(name: "The Supplier", rarity: .rare, role: .guardian),
        TreacheryRoleData(name: "The Warlock", rarity: .mythic, role: .guardian)
    ]
    
    let allAssassins = [
        TreacheryRoleData(name: "The Ambitious Queen", rarity: .unco, role: .assassin),
        TreacheryRoleData(name: "The Beastmaster", rarity: .unco, role: .assassin),
        TreacheryRoleData(name: "The Bio-Engineer", rarity: .unco, role: .assassin),
        TreacheryRoleData(name: "The Corpse Snatcher", rarity: .unco, role: .assassin),
        TreacheryRoleData(name: "The Demon", rarity: .unco, role: .assassin),
        TreacheryRoleData(name: "The Depths Caller", rarity: .unco, role: .assassin),
        TreacheryRoleData(name: "The Madwoman", rarity: .unco, role: .assassin),
        TreacheryRoleData(name: "The Necromancer", rarity: .unco, role: .assassin),
        TreacheryRoleData(name: "The Pyromancer", rarity: .unco, role: .assassin),
        TreacheryRoleData(name: "The Rebel General", rarity: .unco, role: .assassin),
        TreacheryRoleData(name: "The Seer", rarity: .unco, role: .assassin),
        TreacheryRoleData(name: "The Shapeshifting Slayer", rarity: .unco, role: .assassin),
        TreacheryRoleData(name: "The Sigil Mage", rarity: .unco, role: .assassin),
        TreacheryRoleData(name: "The Sorceress", rarity: .unco, role: .assassin),
        TreacheryRoleData(name: "The War Shaman", rarity: .unco, role: .assassin),
        TreacheryRoleData(name: "The Witch", rarity: .unco, role: .assassin),
    ]
    
    let allTraitors = [
        TreacheryRoleData(name: "The Banisher", rarity: .unco, role: .traitor),
        TreacheryRoleData(name: "The Cleaner", rarity: .unco, role: .traitor),
        TreacheryRoleData(name: "The Ferryman", rarity: .unco, role: .traitor),
        TreacheryRoleData(name: "The Gatekeeper", rarity: .unco, role: .traitor),
        TreacheryRoleData(name: "The Grenadier", rarity: .unco, role: .traitor),
        TreacheryRoleData(name: "The Metamorph", rarity: .unco, role: .traitor),
        TreacheryRoleData(name: "The Oneiromancer", rarity: .unco, role: .traitor),
        //TreacheryRoleData(name: "The Puppet Master", rarity: .unco, role: .traitor),
        TreacheryRoleData(name: "The Reflector", rarity: .unco, role: .traitor),
        TreacheryRoleData(name: "The Time Bender", rarity: .unco, role: .traitor),
        TreacheryRoleData(name: "The Wearer of Masks", rarity: .unco, role: .traitor),
    ]
    
    var leaders = [TreacheryRoleData]()
    
    var guardians = [TreacheryRoleData]()
    
    var assassins = [TreacheryRoleData]()
    
    var traitors = [TreacheryRoleData]()
    
    init() {
        leaders = allLeaders
        guardians = allGuardians
        assassins = allAssassins
        traitors = allTraitors
    }
    
    func filter(_ rarities: [Rarity]) {
        leaders = allLeaders
        leaders.removeAll(where: { isRarityFiltered($0.rarity, allowed: rarities)})
        guardians = allGuardians
        guardians.removeAll(where: { isRarityFiltered($0.rarity, allowed: rarities)})
        assassins = allAssassins
        assassins.removeAll(where: { isRarityFiltered($0.rarity, allowed: rarities)})
        traitors = allTraitors
        traitors.removeAll(where: { isRarityFiltered($0.rarity, allowed: rarities)})
    }
    
    private func isRarityFiltered(_ rarity: Rarity, allowed: [Rarity]) -> Bool {
        var shouldBeRemoved = true
        for r in allowed {
            if r == rarity {
                shouldBeRemoved = false
            }
        }
        return shouldBeRemoved
    }
    
    func getAllRole() -> [TreacheryRoleData] {
        return leaders + guardians + assassins + traitors
    }
    
    func getRandomRole(_ role: TreacheryRole) -> TreacheryRoleData? {
        switch role {
        case .leader:
            return leaders.randomElement()
        case .guardian:
            return guardians.randomElement()
        case .assassin:
            return assassins.randomElement()
        case .traitor:
            return traitors.randomElement()
        }
    }
    
    struct TreacheryRoleData {
        let roleUrl: String
        let name: String
        let rarity: Rarity
        
        init(name: String, rarity: Rarity, role: TreacheryRole) {
            var fixedName = name
            if name == "The Ætherist" {
                fixedName = "the Ætherist"
            } else {
                fixedName = fixedName.lowercased()
            }
            self.roleUrl = "https://mtgtreachery.net/rules/oracle/?card=\(fixedName.replacingOccurrences(of: " ", with: "-"))"
            self.name = name
            self.rarity = rarity
        }
    }
    
    enum Rarity {
        case unco
        case rare
        case mythic
    }
}

enum TreacheryRole {
    case leader
    case guardian
    case assassin
    case traitor
    
    func name() -> String {
        switch self {
        case .leader:
            return "Leader"
        case .guardian:
            return "Guardian"
        case .assassin:
            return "Assassin"
        case .traitor:
            return "Traitor"
        }
    }
}
