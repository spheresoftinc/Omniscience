//
//  Area.swift
//  Omniscience
//
//  Created by Philip Brittan on 4/19/21.
//


import Foundation
import SwiftBicycle
import SwiftUI

class AreaFactory {
    @ObservedObject var model = ConverterModel()
    var feet2 = Field<Double>()
    var inches2 = Field<Double>()
    var miles2 = Field<Double>()
    var acres = Field<Double>()
    var meters2 = Field<Double>()
    var km2 = Field<Double>()
    var hectares = Field<Double>()
    var football = Field<Double>()
    
    init() {
        model.pageTitle = "Area"
        model.pageHelp = "Help!"
        model.nf.minimumFractionDigits = 1
        model.nf.maximumFractionDigits = 1
        model.nf.numberStyle = .decimal
        
        model.fl.items = [
            FieldDesc(label: "Square Inches", field: inches2),
            FieldDesc(label: "Square Feet", field: feet2),
            FieldDesc(label: "Square Miles", field: miles2),
            FieldDesc(label: "Acres", field: acres),
            FieldDesc(label: "Square Meters", field: meters2),
            FieldDesc(label: "Square Kilometers", field: km2),
            FieldDesc(label: "Hectares", field: hectares),
            FieldDesc(label: "Football Fields", field: football)
        ]
        
        for fd in model.fl.items {
            fd.field.formatter = model.nf
            model.network.adoptField(field: fd.field)
            fd.field.isEqual = { fabs($0 - $1) < 0.00001 }
        }
       
        Calculator1OpFactory.registerFactory(target: feet2, operand0: inches2) { $0 / 144.0 }
        Calculator1OpFactory.registerFactory(target: inches2, operand0: feet2) { $0 * 144.0 }
        Calculator1OpFactory.registerFactory(target: feet2, operand0: miles2) { $0 * 2.788e+7 }
        Calculator1OpFactory.registerFactory(target: miles2, operand0: feet2) { $0 / 2.788e+7 }
        Calculator1OpFactory.registerFactory(target: feet2, operand0: meters2) { $0 * 10.7639 }
        Calculator1OpFactory.registerFactory(target: meters2, operand0: feet2) { $0 / 10.7639 }
        Calculator1OpFactory.registerFactory(target: km2, operand0: meters2) { $0 / 1e+6 }
        Calculator1OpFactory.registerFactory(target: meters2, operand0: km2) { $0 * 1e+6 }
        Calculator1OpFactory.registerFactory(target: hectares, operand0: meters2) { $0 / 10000.0 }
        Calculator1OpFactory.registerFactory(target: meters2, operand0: hectares) { $0 * 10000.0 }
        Calculator1OpFactory.registerFactory(target: football, operand0: feet2) { $0 / 48000.0 }
        Calculator1OpFactory.registerFactory(target: feet2, operand0: football) { $0 * 48000.0 }
        Calculator1OpFactory.registerFactory(target: feet2, operand0: acres) { $0 * 43560.0 }
        Calculator1OpFactory.registerFactory(target: acres, operand0: feet2) { $0 / 43560.0 }
        

        model.network.delegate = model
        model.network.connectCalculators()
    }
}

struct AreaView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView(model: AreaFactory().model)
    }
}
