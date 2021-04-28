//
//  Electricity.swift
//  Converter
//
//  Created by Philip Brittan on 4/11/21.
//

import Foundation
import SwiftBicycle
import SwiftUI


class ElectricityFactory {
    @ObservedObject var model = ConverterModel()
    // create fields
    var voltage = Field<Double>()
    var current = Field<Double>()
    var resistance = Field<Double>()
    var power = Field<Double>()
    
    init() {
        // set up metadata and fields in the underlying ConverterModel
        model.pageTitle = "Electricity"
        model.pageHelp = "Help!"
        model.nf.minimumFractionDigits = 0
        model.nf.maximumFractionDigits = 4
        model.nf.numberStyle = .decimal
        model.fl.items = [
            FieldDesc(label: "Volatage", field: voltage),
            FieldDesc(label: "Power (Watts)", field: power),
            FieldDesc(label: "Resistance (Ohms)", field: resistance),
            FieldDesc(label: "Current (Amps)", field: current)
        ]
        for fd in model.fl.items {
            fd.field.formatter = model.nf
            model.network.adoptField(field: fd.field)
            fd.field.isEqual = { fabs($0 - $1) < 0.00001 }
        }
       
        // specify calculations (setters)
        Calculator2OpFactory.registerFactory(target: voltage, operand0: resistance, operand1: current) { $0 * $1 }
        Calculator2OpFactory.registerFactory(target: voltage, operand0: power, operand1: current) { $0 / $1 }
        Calculator2OpFactory.registerFactory(target: voltage, operand0: power, operand1: resistance) { sqrt( $0 * $1 ) }
        
        Calculator2OpFactory.registerFactory(target: current, operand0: voltage, operand1: resistance) { $0 / $1 }
        Calculator2OpFactory.registerFactory(target: current, operand0: power, operand1: voltage) { $0 / $1 }
        Calculator2OpFactory.registerFactory(target: current, operand0: power, operand1: resistance) { sqrt( $0 / $1 ) }
        
        Calculator2OpFactory.registerFactory(target: resistance, operand0: voltage, operand1: current) { $0 / $1 }
        Calculator2OpFactory.registerFactory(target: resistance, operand0: voltage, operand1: power) { pow($0, 2.0) / $1 }
        Calculator2OpFactory.registerFactory(target: resistance, operand0: power, operand1: current) { $0 / pow($1, 2.0) }
        
        Calculator2OpFactory.registerFactory(target: power, operand0: voltage, operand1: current) { $0 * $1 }
        Calculator2OpFactory.registerFactory(target: power, operand0: resistance, operand1: current) { $0 * pow($1, 2.0) }
        Calculator2OpFactory.registerFactory(target: power, operand0: voltage, operand1: resistance) { pow($0, 2.0) / $1 }

        model.network.delegate = model
        model.network.connectCalculators()
    }
}

// just used for immediate previews/debugging
struct ElectricityView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView(model: ElectricityFactory().model)
    }
}
