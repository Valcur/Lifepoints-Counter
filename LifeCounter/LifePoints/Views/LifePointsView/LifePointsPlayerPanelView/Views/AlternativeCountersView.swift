//
//  AlternativeCountersView.swift
//  LifeCounter
//
//  Created by Loic D on 30/10/2023.
//

import SwiftUI

struct AlternativeCountersView: View {
    @EnvironmentObject var lifePointsViewModel: LifePointsViewModel
    @Binding var counters: [AlternativeCounter]
    let playerId: Int
    @State var showCountersList: Bool = false
    let existingCounters = ["Poison", "Exp", "Treasure"]
    
    var body: some View {
        HStack {
            ForEach(0..<counters.count, id: \.self) { i in
                if counters[i].enabled {
                    CounterView(counter: $counters[i], counters: $counters)
                    if i != counters.count - 1 {
                        Rectangle()
                            .foregroundColor(.black)
                            .frame(width: 2)
                    }
                }
            }
            ZStack {
                Color.black
                if showCountersList {
                    ScrollView(.vertical) {
                        VStack {
                            ForEach(0..<existingCounters.count, id: \.self) { i in
                                newCounterButton(counterName: existingCounters[i], counters: $counters, showCountersList: $showCountersList)
                            }
                        }
                    }
                } else {
                    Button(action: {
                        showCountersList = true
                    }, label: {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.white)
                    })
                }
            }.frame(width: 80)
                .onChange(of: counters.count) { _ in
                lifePointsViewModel.saveAlternativeCounters(playerId)
            }
        }.background(VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial)))
    }
    
    struct newCounterButton: View {
        var counterName: String
        @Binding var counters: [AlternativeCounter]
        @Binding var showCountersList: Bool
        @State var isAvailable: Bool = false
        
        var body: some View {
            ZStack {
                if isAvailable {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            counters.append(AlternativeCounter(imageName: counterName, value: 0))
                            showCountersList = false
                        }
                    }, label: {
                        Image(counterName)
                            .font(.title)
                            .foregroundColor(.white)
                    })
                }
            }
            .onAppear() {
                isAvailable = isCounterAvailable(counterName)
            }
        }
        
        func isCounterAvailable(_ counterName: String) -> Bool {
            for counter in counters {
                if counter.imageName == counterName {
                    return false
                }
            }
            return true
        }
    }
    
    struct CounterView: View {
        @Binding var counter: AlternativeCounter
        @Binding var counters: [AlternativeCounter]
        var body: some View {
            ZStack(alignment: .top) {
                VStack {
                    Spacer()
                    Text("\(counter.value)")
                        .title()
                    Image(counter.imageName)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                    Spacer()
                }
                VStack(spacing: 0) {
                    Rectangle()
                        .opacity(0.0001)
                        .onTapGesture {
                            counter.value += 1
                        }
                    Rectangle()
                        .opacity(0.0001)
                        .onTapGesture {
                            counter.value -= 1
                        }
                }
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        counters.removeAll(where: { $0.imageName == counter.imageName })
                    }
                }, label: {
                    ZStack {
                        Color.black.opacity(0.00002)
                        Image(systemName: "minus")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }).frame(height: 40)
            }
        }
    }
}

struct AlternativeCounter {
    var imageName: String
    var value: Int
    var enabled: Bool = true
}
