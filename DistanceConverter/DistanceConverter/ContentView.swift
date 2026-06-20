//
//  ContentView.swift
//  DistanceConverter
//
//  Created by Brandon Hill on 6/20/26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var inputUnit = "meters"
    @State private var outputUnit = "kilometers"
    @State private var distance = 0.0
    @FocusState private var amountIsFocused: Bool
    
    let units = ["miles", "kilometers", "meters", "feet", "yards"]
    
    var calculatedDistance: Double {
        let meters: Double
        switch inputUnit {
        case "miles":       meters = distance * 1609.344
        case "kilometers":  meters = distance * 1000
        case "feet":        meters = distance * 0.3048
        case "yards":       meters = distance * 0.9144
        default:            meters = distance
        }
        
        switch outputUnit {
        case "miles":       return meters / 1609.344
        case "kilometers":  return meters / 1000
        case "feet":        return meters / 0.3048
        case "yards":       return meters / 0.9144
        default:            return meters
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Distance") {
                    TextField("Distance", value: $distance, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                }
                Section("Convert from") {
                    Picker("Input unit", selection: $inputUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                }
                Section("Convert to") {
                    Picker("Output unit", selection: $outputUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                }
                Section("Converted amount") {
                    Text(calculatedDistance, format: .number)
                }
            }
            .navigationTitle("Distance Converter")
            .toolbar {
                if amountIsFocused {
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
