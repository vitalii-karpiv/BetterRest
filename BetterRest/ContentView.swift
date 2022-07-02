//
//  ContentView.swift
//  BetterRest
//
//  Created by newbie on 02.07.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = Date.now
    @State private var sleepAmout = 8.00
    @State private var coffeAmount = 1
    
    var body: some View {
        NavigationView {
            VStack {
                Text("When do you want you wake up?")
                    .font(.headline)
                DatePicker("Please, enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                Text("Desired amount of sleep")
                    .font(.headline)
                Stepper("\(sleepAmout.formatted()) hours", value: $sleepAmout, in: 4...12, step: 0.25)
                
                Text("Daily coffe intake")
                    .font(.headline)
                Stepper(coffeAmount == 1 ? "1 cup" : "\(coffeAmount) cups", value: $coffeAmount, in: 1...20)
            }
            .padding()
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate") {
                    calculateBedTime()
                }
            }
        }
    }
    
    private func calculateBedTime() {
        print("Calculating...")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
