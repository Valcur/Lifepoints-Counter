//
//  AlternativeCountersView.swift
//  LifeCounter
//
//  Created by Loic D on 30/10/2023.
//

import SwiftUI

struct AlternativeCountersView: View {
    @Binding var counters: [AlternativeCounter]
    
    var body: some View {
        HStack {
            ForEach(0..<counters.count, id: \.self) { i in
                CounterView(counter: $counters[i])
                if i != counters.count - 1 {
                    Rectangle()
                        .foregroundColor(.black)
                        .frame(width: 2)
                }
            }
        }.background(VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial)))
    }
    
    struct CounterView: View {
        @Binding var counter: AlternativeCounter
        var body: some View {
            ZStack {
                VStack {
                    Text("\(counter.value)")
                        .title()
                    Image(counter.ImageName)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
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
            }
        }
    }
}

struct AlternativeCounter {
    var ImageName: String
    var value: Int
}
