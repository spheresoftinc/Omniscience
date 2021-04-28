//
//  length.swift
//  Converter
//
//  Created by Philip Brittan on 4/8/21.
//

import Foundation
import SwiftBicycle
import SwiftUI


class LengthFactory {
    @ObservedObject var model = ConverterModel()
    // create fields
    var inches = Field<Double>()
    var feet = Field<Double>()
    var yards = Field<Double>()
    var miles = Field<Double>()
    var leagues = Field<Double>()
    var mm = Field<Double>()
    var cm = Field<Double>()
    var meters = Field<Double>()
    var kilometers = Field<Double>()
    var football = Field<Double>()
    var cubits = Field<Double>()
    var naut = Field<Double>() // nautical miles
    var furlongs = Field<Double>()
    var lightyears = Field<Double>()
    
    init() {
        // set up metadata and fields in the underlying ConverterModel
        model.pageTitle = "Length / Distance"
        model.pageHelp = "Help!"
        model.nf.minimumFractionDigits = 0
        model.nf.maximumFractionDigits = 4
        model.nf.numberStyle = .decimal
        model.fl.items = [
            FieldDesc(label: "Inches", field: inches),
            FieldDesc(label: "Feet", field: feet),
            FieldDesc(label: "Yards", field: yards),
            FieldDesc(label: "Miles", field: miles),
            FieldDesc(label: "Nautical Miles", field: naut),
            FieldDesc(label: "Millimeters", field: mm),
            FieldDesc(label: "Centimeters", field: cm),
            FieldDesc(label: "Meters", field: meters),
            FieldDesc(label: "Kilometers", field: kilometers),
            FieldDesc(label: "Football Fields", field: football),
            FieldDesc(label: "Cubits", field: cubits),
            FieldDesc(label: "Furlongs", field: furlongs),
            FieldDesc(label: "Leagues", field: leagues),
            FieldDesc(label: "Light-years", field: lightyears)
        ]
        for fd in model.fl.items {
            fd.field.formatter = model.nf
            model.network.adoptField(field: fd.field)
            fd.field.isEqual = { fabs($0 - $1) < 0.00001 }
        }
       
        // specify calculations (setters)
        Calculator1OpFactory.registerFactory(target: feet, operand0: inches) {  $0 / 12.0 }
        Calculator1OpFactory.registerFactory(target: inches, operand0: feet) { $0 * 12.0 }
        Calculator1OpFactory.registerFactory(target: yards, operand0: feet) { $0 / 3.0 }
        Calculator1OpFactory.registerFactory(target: feet, operand0: yards) { $0 * 3.0 }
        Calculator1OpFactory.registerFactory(target: miles, operand0: feet) { $0 / 5280.0 }
        Calculator1OpFactory.registerFactory(target: feet, operand0: miles) { $0 * 5280.0 }
        Calculator1OpFactory.registerFactory(target: naut, operand0: miles) { $0 / 1.15078 }
        Calculator1OpFactory.registerFactory(target: miles, operand0: naut) { $0 * 1.15078 }
        Calculator1OpFactory.registerFactory(target: miles, operand0: leagues) { $0 * 3.0 }
        Calculator1OpFactory.registerFactory(target: leagues, operand0: miles) { $0 / 3.0 }
        Calculator1OpFactory.registerFactory(target: football, operand0: yards) { $0 / 100.0 }
        Calculator1OpFactory.registerFactory(target: yards, operand0: football) { $0 * 100.0 }
        Calculator1OpFactory.registerFactory(target: cm, operand0: inches) { $0 * 2.54 }
        Calculator1OpFactory.registerFactory(target: inches, operand0: cm) { $0 / 2.54 }
        Calculator1OpFactory.registerFactory(target: cm, operand0: mm) { $0 / 10.0 }
        Calculator1OpFactory.registerFactory(target: mm, operand0: cm) { $0 * 10.0 }
        Calculator1OpFactory.registerFactory(target: meters, operand0: cm) { $0 / 100.0 }
        Calculator1OpFactory.registerFactory(target: cm, operand0: meters) { $0 * 100.0}
        Calculator1OpFactory.registerFactory(target: kilometers, operand0: meters) { $0 / 1000.0 }
        Calculator1OpFactory.registerFactory(target: meters, operand0: kilometers) { $0 * 1000.0 }
        Calculator1OpFactory.registerFactory(target: cubits, operand0: inches) { $0 / 18.0 }
        Calculator1OpFactory.registerFactory(target: inches, operand0: cubits) { $0 * 18.0 }
        Calculator1OpFactory.registerFactory(target: furlongs, operand0: miles) { $0 * 8.0 }
        Calculator1OpFactory.registerFactory(target: miles, operand0: furlongs) { $0 / 8.0 }
        Calculator1OpFactory.registerFactory(target: miles, operand0: lightyears) { $0 * 5878600000000.0 }
        Calculator1OpFactory.registerFactory(target: lightyears, operand0: miles) { $0 / 5878600000000.0 }

        model.network.delegate = model
        model.network.connectCalculators()
    }
}



class LengthsNetwork: ObservableObject, BicycleNetworkDelegate {
    let objectWillChange = ObjectWillChangePublisher()

    let network = BicycleNetwork()

    // Fields
    var inches = Field<Double>()
    var feet = Field<Double>()
    var yards = Field<Double>()
    var miles = Field<Double>()
    var leagues = Field<Double>()
    var mm = Field<Double>()
    var cm = Field<Double>()
    var meters = Field<Double>()
    var kilometers = Field<Double>()
    var football = Field<Double>()
    var cubits = Field<Double>()
    var naut = Field<Double>() // nautical miles
    var furlongs = Field<Double>()
    var lightyears = Field<Double>()
    
    var nf = NumberFormatter()
    
    init() {
        
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 4
        nf.numberStyle = .decimal
        inches.formatter = nf
        feet.formatter = nf
        yards.formatter = nf
        miles.formatter = nf
        leagues.formatter = nf
        mm.formatter = nf
        cm.formatter = nf
        meters.formatter = nf
        kilometers.formatter = nf
        football.formatter = nf
        cubits.formatter = nf
        naut.formatter = nf
        furlongs.formatter = nf
        lightyears.formatter = nf
        
        network.adoptField(field: inches)
        network.adoptField(field: feet)
        network.adoptField(field: yards)
        network.adoptField(field: miles)
        network.adoptField(field: leagues)
        network.adoptField(field: mm)
        network.adoptField(field: cm)
        network.adoptField(field: meters)
        network.adoptField(field: kilometers)
        network.adoptField(field: football)
        network.adoptField(field: cubits)
        network.adoptField(field: naut)
        network.adoptField(field: furlongs)
        network.adoptField(field: lightyears)

       
        Calculator1OpFactory.registerFactory(target: feet, operand0: inches) {  $0 / 12.0 }
        Calculator1OpFactory.registerFactory(target: inches, operand0: feet) { $0 * 12.0 }
        Calculator1OpFactory.registerFactory(target: yards, operand0: feet) { $0 / 3.0 }
        Calculator1OpFactory.registerFactory(target: feet, operand0: yards) { $0 * 3.0 }
        Calculator1OpFactory.registerFactory(target: miles, operand0: feet) { $0 / 5280.0 }
        Calculator1OpFactory.registerFactory(target: feet, operand0: miles) { $0 * 5280.0 }
        Calculator1OpFactory.registerFactory(target: naut, operand0: miles) { $0 / 1.15078 }
        Calculator1OpFactory.registerFactory(target: miles, operand0: naut) { $0 * 1.15078 }
        Calculator1OpFactory.registerFactory(target: miles, operand0: leagues) { $0 * 3.0 }
        Calculator1OpFactory.registerFactory(target: leagues, operand0: miles) { $0 / 3.0 }
        Calculator1OpFactory.registerFactory(target: football, operand0: yards) { $0 / 100.0 }
        Calculator1OpFactory.registerFactory(target: yards, operand0: football) { $0 * 100.0 }
        Calculator1OpFactory.registerFactory(target: cm, operand0: inches) { $0 * 2.54 }
        Calculator1OpFactory.registerFactory(target: inches, operand0: cm) { $0 / 2.54 }
        Calculator1OpFactory.registerFactory(target: cm, operand0: mm) { $0 / 10.0 }
        Calculator1OpFactory.registerFactory(target: mm, operand0: cm) { $0 * 10.0 }
        Calculator1OpFactory.registerFactory(target: meters, operand0: cm) { $0 / 100.0 }
        Calculator1OpFactory.registerFactory(target: cm, operand0: meters) { $0 * 100.0}
        Calculator1OpFactory.registerFactory(target: kilometers, operand0: meters) { $0 / 1000.0 }
        Calculator1OpFactory.registerFactory(target: meters, operand0: kilometers) { $0 * 1000.0 }
        Calculator1OpFactory.registerFactory(target: cubits, operand0: inches) { $0 / 18.0 }
        Calculator1OpFactory.registerFactory(target: inches, operand0: cubits) { $0 * 18.0 }
        Calculator1OpFactory.registerFactory(target: furlongs, operand0: miles) { $0 * 8.0 }
        Calculator1OpFactory.registerFactory(target: miles, operand0: furlongs) { $0 / 8.0 }
        Calculator1OpFactory.registerFactory(target: miles, operand0: lightyears) { $0 * 5878600000000.0 }
        Calculator1OpFactory.registerFactory(target: lightyears, operand0: miles) { $0 / 5878600000000.0 }


        
        network.delegate = self
        network.connectCalculators()
    }

    func networkWillCalculate(_ network: BicycleNetwork) {
        objectWillChange.send()
    }
}


// just used for immediate previews/debugging
struct LengthView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView(model: LengthFactory().model)
    }
}
