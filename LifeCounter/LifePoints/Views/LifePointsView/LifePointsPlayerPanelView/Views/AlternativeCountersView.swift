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
    @Binding var showAlternativeCounters: Bool
    @State var showCountersList: Bool = false
    let existingCounters = AlternativeCounter.existingCounters
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
            HStack {
                ForEach(0..<counters.count, id: \.self) { i in
                    CounterView(counter: $counters[i], counters: $counters)
                        .allowsHitTesting(counters[i].enabled)
                    if i != counters.count - 1 {
                        Rectangle()
                            .foregroundColor(.black)
                            .frame(width: 2)
                    }
                }
                if counters.count < 5 {
                    ZStack {
                        Color.black
                        if showCountersList {
                            ScrollView(.vertical) {
                                VStack {
                                    ForEach(0..<existingCounters.count, id: \.self) { i in
                                        NewCounterButton(counterName: existingCounters[i], counters: $counters, showCountersList: $showCountersList)
                                    }
                                }.padding(5)
                            }.padding(.top, 50)
                        } else {
                            Button(action: {
                                showCountersList = true
                            }, label: {
                                Image(systemName: "plus")
                                    .font(.title)
                                    .foregroundColor(.white)
                            })
                        }
                    }.frame(maxWidth: counters.count == 0 ? .infinity : 80)
                }
            }
            .onChange(of: counters.count) { _ in
                lifePointsViewModel.saveAlternativeCounters(playerId)
            }
            Button(action: {
                showAlternativeCounters = false
            }, label: {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .genericButtonLabel()
            }).frame(width: 50)
        }
    }
    
    struct NewCounterButton: View {
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
                        VStack {
                            Image(counterName)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                            Text(counterName)
                                .headline()
                        }
                    }).frame(maxWidth: .infinity).background(VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))).cornerRadius(5)
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
        @State var prevValue: CGFloat = 0
        
        var body: some View {
            ZStack(alignment: .bottomLeading) {
                VStack(alignment: .center) {
                    Spacer()
                    Text("\(counter.value)")
                        .title()
                    Image(counter.imageName)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                    Spacer()
                }.frame(maxWidth: .infinity)
                VStack(spacing: 0) {
                    Rectangle()
                        .opacity(0.0001)
                        .onTapGesture {
                            counter.value += 1
                        }
                    Rectangle()
                        .opacity(0.0001)
                        .onTapGesture {
                            if counter.value > 0 {
                                counter.value -= 1
                            }
                        }
                }
                .gesture(DragGesture()
                    .onChanged { value in
                        let newValue = value.translation.height
                        if newValue > prevValue + 12 {
                            prevValue = newValue
                            if counter.value > 0 {
                                counter.value -= 1
                            }
                        }
                        else if newValue < prevValue - 12 {
                            prevValue = newValue
                            counter.value += 1
                        }
                    }
                )
                Button(action: {
                    counter.enabled = false
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
    static let existingCounters = ["Poison", "Exp", "Treasure", "CommanderTax", "Energy"]
    var imageName: String
    var value: Int
    var enabled: Bool = true
}
