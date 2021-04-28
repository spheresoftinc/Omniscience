//
//  Temperatures.swift
//  Converter
//
//  Created by Philip Brittan on 4/7/21.
//

import Foundation
import SwiftBicycle
import SwiftUI

class TemperatureFactory {
    @ObservedObject var model = ConverterModel()
    var fahrenheit = Field<Double>()
    var celsius = Field<Double>()
    var kelvin = Field<Double>()
    var rankine = Field<Double>()
    
    init() {
        model.pageTitle = "Temperature"
        model.pageHelp = "Help!"
        model.nf.minimumFractionDigits = 1
        model.nf.maximumFractionDigits = 1
        model.nf.numberStyle = .decimal
        
        model.fl.items = [
            FieldDesc(label: "Fahrenheit", field: fahrenheit),
            FieldDesc(label: "Celsius", field: celsius),
            FieldDesc(label: "Kelvin", field: kelvin),
            FieldDesc(label: "Rankine", field: rankine)
        ]
        
        for fd in model.fl.items {
            fd.field.formatter = model.nf
            model.network.adoptField(field: fd.field)
            fd.field.isEqual = { fabs($0 - $1) < 0.00001 }
        }
       
        Calculator1OpFactory.registerFactory(target: celsius, operand0: fahrenheit) { ( $0 - 32.0) * 5.0 / 9.0 }
        Calculator1OpFactory.registerFactory(target: celsius, operand0: kelvin) { $0 - 273.15 }
        Calculator1OpFactory.registerFactory(target: kelvin, operand0: celsius) { $0 + 273.15 }
        Calculator1OpFactory.registerFactory(target: fahrenheit, operand0: celsius) { ($0 * 9.0 / 5.0) + 32.0 }
        Calculator1OpFactory.registerFactory(target: fahrenheit, operand0: rankine) { $0 - 459.67 }
        Calculator1OpFactory.registerFactory(target: rankine, operand0: fahrenheit) { $0 + 459.67 }

        model.network.delegate = model
        model.network.connectCalculators()
    }
}

struct TemperatureView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView(model: TemperatureFactory().model)
    }
}
