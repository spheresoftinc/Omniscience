//
//  IdealGas.swift
//  Converter
//
//  Created by Philip Brittan on 4/11/21.
//


import Foundation
import SwiftBicycle
import SwiftUI


class IdealGasFactory {
    @ObservedObject var model = ConverterModel()
    // create fields
    var pressure = Field<Double>()
    var volume = Field<Double>()
    var moles = Field<Double>()
    var kelvin = Field<Double>()
    var celsius = Field<Double>()
    
    let R: Double = 8.3144598 // gas constant
    
    init() {
        // set up metadata and fields in the underlying ConverterModel
        model.pageTitle = "Ideal Gas"
        model.pageHelp = "Help!"
        model.nf.minimumFractionDigits = 0
        model.nf.maximumFractionDigits = 4
        model.nf.numberStyle = .decimal
        model.fl.items = [
            FieldDesc(label: "Pressure (Atm)", field: pressure),
            FieldDesc(label: "Volume (L)", field: volume),
            FieldDesc(label: "Moles", field: moles),
            FieldDesc(label: "º Kelvin", field: kelvin),
            FieldDesc(label: "º Celsius", field: celsius)
        ]
        for fd in model.fl.items {
            fd.field.formatter = model.nf
            model.network.adoptField(field: fd.field)
            fd.field.isEqual = { fabs($0 - $1) < 0.00001 }
        }
       
        // specify calculations (setters)
        Calculator1OpFactory.registerFactory(target: celsius, operand0: kelvin) { $0 - 273.15 }
        Calculator1OpFactory.registerFactory(target: kelvin, operand0: celsius) { $0 + 273.15 }
       
        Calculator3OpFactory.registerFactory(target: pressure, operand0: moles, operand1: kelvin, operand2: volume) {
                ($0 * self.R * $1) / $2 }
        
        Calculator3OpFactory.registerFactory(target: volume, operand0: moles, operand1: kelvin, operand2: pressure) {
                ($0 * self.R * $1) / $2 }
        
        Calculator3OpFactory.registerFactory(target: moles, operand0: pressure, operand1: kelvin, operand2: volume) {
            ($0 * $2) / (self.R * $1) }
        
        Calculator3OpFactory.registerFactory(target: kelvin, operand0: moles, operand1: pressure, operand2: volume) {
            ($1 * $2) / (self.R * $0) }

        model.network.delegate = model
        model.network.connectCalculators()
    }
}

// just used for immediate previews/debugging
struct IdealGasView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView(model: IdealGasFactory().model)
    }
}

