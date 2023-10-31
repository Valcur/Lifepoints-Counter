//
//  LifePointsViewModel.swift
//  Planechase
//
//  Created by Loic D on 28/10/2023.
//

import SwiftUI

class LifePointsViewModel: ObservableObject {
    @Published var numberOfPlayer: Int
    @Published var players: [PlayerProfile]
    @Published var lastUsedSetup: LastUsedSetup
    
    init(numberOfPlayer: Int, startingLife: Int, colorPalette: Int, playWithTreachery: Bool) {
        self.lastUsedSetup = SaveManager.getLastUsedSetup()
        self.numberOfPlayer = numberOfPlayer
        self.players = []
        
        iniGame(numberOfPlayer: numberOfPlayer, startingLife: startingLife, colorPalette: colorPalette, playWithTreachery: playWithTreachery)
    }
    
    func newGame(numberOfPlayer: Int, startingLife: Int, colorPalette: Int, playWithTreachery: Bool) {
        self.lastUsedSetup = SaveManager.getLastUsedSetup()
        self.numberOfPlayer = numberOfPlayer
        self.players = []
        
        iniGame(numberOfPlayer: numberOfPlayer, startingLife: startingLife, colorPalette: colorPalette, playWithTreachery: playWithTreachery)
    }
    
    private func iniGame(numberOfPlayer: Int, startingLife: Int, colorPalette: Int, playWithTreachery: Bool) {
        var colors = [
            Color("\(colorPalette) Player 1"),
            Color("\(colorPalette) Player 2"),
            Color("\(colorPalette) Player 3"),
            Color("\(colorPalette) Player 4"),
            Color("\(colorPalette) Player 5"),
            Color("\(colorPalette) Player 6"),
            Color("\(colorPalette) Player 7"),
            Color("\(colorPalette) Player 8"),
        ]
        colors.shuffle()
        
        var treacheryRoles: [TreacheryPlayer.TreacheryRole] = []
        if playWithTreachery {
            treacheryRoles = TreacheryPlayer.getRandomizedRoleArray(nbrOfPlayer: numberOfPlayer)
        }
        
        for i in 1...numberOfPlayer {
            var backgroundImage: UIImage? = nil
            var name = "\("lifepoints_player".translate()) \(i)"
            var id = UUID()
            if let customProfile = lastUsedSetup.playersProfiles[i - 1] {
                name = customProfile.name
                id = customProfile.id
                if let imageData = customProfile.customImageData {
                    if let image = UIImage(data: imageData) {
                        backgroundImage = image
                    }
                }
            }
            
            var role: TreacheryPlayer? = nil
            if playWithTreachery {
                if treacheryRoles.count > 0 {
                    role = TreacheryPlayer(role: treacheryRoles.removeFirst())
                }
            }
            
            players.append(PlayerProfile(id: id, name: name, backgroundColor: colors[i - 1], backgroundImage: backgroundImage, lifePoints: startingLife, counters: PlayerCounters(countersEnabled: lastUsedSetup.alternativeCountersEnabled[i - 1]), treachery: role))
        }
        
        // Toggle partner
        for i in 0..<lastUsedSetup.partnerEnabled.count {
            if lastUsedSetup.partnerEnabled[i] {
                togglePartnerForPlayer(i)
            }
        }
    }
    
    func togglePartnerForPlayer(_ playerId: Int) {
        let isPartnerEnabled = players[playerId].counters.commanderDamages[playerId].count == 2
        for i in 0..<players.count {
            if isPartnerEnabled {
                players[i].counters.commanderDamages[playerId].remove(at: 1)
            } else {
                players[i].counters.commanderDamages[playerId].append(0)
            }
        }
    }
    
    func savePartnerForPlayer(_ playerId: Int) {
        lastUsedSetup.partnerEnabled[playerId] = players[playerId].counters.commanderDamages[playerId].count == 2
        SaveManager.saveLastUsedSetup(lastUsedSetup)
    }
    
    func saveAlternativeCounters(_ playerId: Int) {
        lastUsedSetup.alternativeCountersEnabled[playerId] = []
        for counter in players[playerId].counters.alternativeCounters {
            lastUsedSetup.alternativeCountersEnabled[playerId].append(counter.imageName)
        }
        SaveManager.saveLastUsedSetup(lastUsedSetup)
    }
}

struct PlayerProfile {
    var id: UUID
    var name: String
    var backgroundColor: Color
    var backgroundImage: UIImage?
    var lifePoints: Int
    var counters: PlayerCounters
    var treachery: TreacheryPlayer?
    var partnerEnabled: Bool = false
}

struct PlayerCounters {
    var alternativeCounters: [AlternativeCounter]
    var commanderDamages: [[Int]]
    
    init(countersEnabled: [String]) {
        self.alternativeCounters = []
        for counter in countersEnabled {
            alternativeCounters.append(AlternativeCounter(imageName: counter, value: 0))
        }
        self.commanderDamages = [[0], [0], [0], [0], [0], [0], [0], [0]]
    }
}
