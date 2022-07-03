//
//  ContentView.swift
//  BetterRest
//
//  Created by newbie on 02.07.2022.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeUpTime
    @State private var sleepAmout = 8.00
    @State private var coffeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeUpTime: Date {
        var dateComponent = DateComponents()
        dateComponent.hour = 7
        dateComponent.minute = 0
        return Calendar.current.date(from: dateComponent) ?? Date.now
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        DatePicker("Please, enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .onChange(of: wakeUp) { newValue in
                                calculateBedTime()
                            }
                    } header: {
                        Text("When do you want you wake up?")
                            .font(.headline)
                    }
                    
                    Section {
                        Stepper("\(sleepAmout.formatted()) hours", value: $sleepAmout, in: 4...12, step: 0.25)
                            .onChange(of: sleepAmout) { newValue in
                                calculateBedTime()
                            }
                    } header: {
                        Text("Desired amount of sleep")
                            .font(.headline)
                    }
                    
                    Section {
                        Picker(coffeAmount == 1 ? "1 cup" : "\(coffeAmount) cups", selection: $coffeAmount) {
                            ForEach(1...20, id: \.self) {Text($0 == 1 ? "1 cup" : "\($0) cups")}
                        }
                    } header: {
                        Text("Daily coffe intake")
                            .font(.headline)
                    }
                }
                Text(alertTitle)
                    .font(.largeTitle)
                Text(alertMessage)
                    .font(.largeTitle)
                Spacer()
                Spacer()
            }
            .navigationTitle("BetterRest")
            .onAppear(perform: calculateBedTime)
        }
    }
    
    private func calculateBedTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmout, coffee: Double(coffeAmount))

            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "You ideal bedtime is ..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "Something went wrong during calculation"
        }
        
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
