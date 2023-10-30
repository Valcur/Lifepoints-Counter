//
//  LifeOptionsPanel.swift
//  Planechase
//
//  Created by Loic D on 25/09/2023.
//

import SwiftUI

extension OptionsMenuView {
    struct LifeOptionsPanel: View {
        @EnvironmentObject var planechaseVM: PlanechaseViewModel
        @State var profiles: [PlayerCustomProfile] = []
        
        var body: some View {
            VStack(alignment: .leading, spacing: 15) {
                Group {
                    Text("options_life_title".translate())
                        .title()
                    
                    Toggle("options_life_useCommanderDamages".translate(), isOn: $planechaseVM.lifeCounterOptions.useCommanderDamages)
                        .font(.subheadline).foregroundColor(.white)
                    
                    HStack {
                        Text("options_life_nbrPlayers".translate())
                            .headline()
                        
                        Spacer()
                        
                        MenuNumberOfPlayerChoiceView(numberOfPlayers: 2)
                        MenuNumberOfPlayerChoiceView(numberOfPlayers: 3)
                        MenuNumberOfPlayerChoiceView(numberOfPlayers: 4)
                        MenuNumberOfPlayerChoiceView(numberOfPlayers: 5)
                        MenuNumberOfPlayerChoiceView(numberOfPlayers: 6)
                        if !UIDevice.isIPhone {
                            MenuNumberOfPlayerChoiceView(numberOfPlayers: 7)
                            MenuNumberOfPlayerChoiceView(numberOfPlayers: 8)
                        }
                    }
                    
                    HStack {
                        Text("options_life_startingLife".translate())
                            .headline()
                        
                        Spacer()
                        
                        MenuStartingLifeChoiceView(startingLife: 20)
                        MenuStartingLifeChoiceView(startingLife: 30)
                        MenuStartingLifeChoiceView(startingLife: 40)
                        MenuStartingLifeChoiceView(startingLife: 50)
                        MenuStartingLifeChoiceView(startingLife: 60)
                    }
                }
                
                Group {
                    Text("options_profiles_title".translate())
                        .title()
                    
                    Text("options_profiles_intro".translate())
                        .headline()
                    
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(0..<profiles.count, id: \.self) { i in
                            CustomProfileView(profileIndex: i, profiles: $profiles, profileId: profiles[i].id).id(profiles[i].id)
                        }
                        Button(action: {
                            if planechaseVM.lifeCounterProfiles.count >= 10 {
                                return
                            }
                            planechaseVM.lifeCounterProfiles.append(PlayerCustomProfile(name: "\("lifepoints_player".translate()) \(planechaseVM.lifeCounterProfiles.count + 1)"))
                            planechaseVM.saveProfiles_Info()
                            profiles = planechaseVM.lifeCounterProfiles
                        }, label: {
                            Text("+")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .frame(width: 150)
                                .buttonLabel()
                        }).opacity(planechaseVM.lifeCounterProfiles.count >= 10 ? 0 : 1)
                    }
                }
            }.scrollablePanel()
            .onChange(of: planechaseVM.lifeCounterOptions.useCommanderDamages) { _ in
                planechaseVM.setLifeOptions(planechaseVM.lifeCounterOptions)
            }
            .onAppear() {
                profiles = planechaseVM.lifeCounterProfiles
            }
        }
        
        struct CustomProfileView: View {
            @EnvironmentObject var planechaseVM: PlanechaseViewModel
            let profileIndex: Int
            var profile: PlayerCustomProfile {
                if profileIndex < planechaseVM.lifeCounterProfiles.count {
                    return planechaseVM.lifeCounterProfiles[profileIndex]
                }
                return PlayerCustomProfile()
            }
            @State var profileName = ""
            @State var showingImagePicker: Bool = false
            @State private var inputImage: UIImage?
            @State var saveChangesTimer: Timer?
            @Binding var profiles: [PlayerCustomProfile]
            @State var imageView: Image?
            private let maxNameLength = 15
            let profileId: UUID
            
            var body: some View {
                HStack(spacing: 20) {
                    Button(action: {
                        showingImagePicker = true
                    }, label: {
                        if let image = imageView {
                            image
                                .resizable()
                                .scaledToFill()
                        } else {
                            ZStack {
                                Color.black.opacity(0.5)
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                        }
                    }).frame(width: 80, height: 50).cornerRadius(8).clipped()
                        .onChange(of: inputImage) { _ in saveProfileImage() }
                        .sheet(isPresented: $showingImagePicker) {
                            ImagePicker(image: $inputImage).preferredColorScheme(.dark)
                        }
                    
                    TextField("", text: $profileName)
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(Color.black.opacity(0.2).cornerRadius(5))
                        .onAppear() {
                            updateImageView()
                            profileName = profile.name
                        }
                        .onChange(of: profileName) { _ in
                            if profileName.count > maxNameLength {
                                profileName = String(profileName.prefix(maxNameLength))
                            }
                            saveChangesTimer?.invalidate()
                            saveChangesTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { timer in
                                if let index = planechaseVM.lifeCounterProfiles.firstIndex(where: {$0.id == profileId}) {
                                    planechaseVM.lifeCounterProfiles[index].name = profileName
                                    planechaseVM.saveProfiles_Info()
                                }
                            }
                            profiles = planechaseVM.lifeCounterProfiles
                        }
                    
                    Button(action: {
                        saveChangesTimer?.invalidate()
                        if let index = planechaseVM.lifeCounterProfiles.firstIndex(where: {$0.id == profileId}) {
                            SaveManager.deleteOptions_LifePlayerProfile_CustomImage(profile: planechaseVM.lifeCounterProfiles[index])
                            planechaseVM.lifeCounterProfiles.remove(at: index)
                            planechaseVM.saveProfiles_Info()
                            profiles = planechaseVM.lifeCounterProfiles
                        }
                    }, label: {
                        Image(systemName: "trash")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.red)
                            .padding(15)
                    })
                }.padding(10).blurredBackground()
            }
            
            private func saveProfileImage() {
                guard let inputImage = inputImage else { return }
                withAnimation(.easeInOut(duration: 0.3)) {
                    planechaseVM.lifeCounterProfiles[profileIndex].customImageData = inputImage.pngData()
                    planechaseVM.saveProfiles_Image(index: profileIndex)
                    profiles = planechaseVM.lifeCounterProfiles
                    updateImageView()
                }
            }
            
            private func updateImageView() {
                DispatchQueue.main.async {
                    if let imageData = profile.customImageData {
                        if let image = UIImage(data: imageData) {
                            imageView = Image(uiImage: image)
                        }
                    }
                }
            }
            
            private func resetSaveChangesTimer() {
                saveChangesTimer?.invalidate()
                saveChangesTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { timer in
                    planechaseVM.saveProfiles_Info()
                }
            }
        }
    }
}

struct PlayerCustomProfile: Codable, Identifiable {
    var id = UUID()
    var name: String
    var lastUsedSlot: Int
    var customImageData: Data?
    
    init(name: String = "", lastUsedSlot: Int = -1, customImageData: Data? = nil) {
        self.name = name
        self.lastUsedSlot = lastUsedSlot
        self.customImageData = customImageData
    }
}