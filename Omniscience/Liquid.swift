//
//  Liquids.swift
//  Converter
//
//  Created by Philip Brittan on 4/10/21.
//

import Foundation
import SwiftBicycle
import SwiftUI


class LiquidFactory {
    @ObservedObject var model = ConverterModel()
    // create fields
    var ounces = Field<Double>()
    var teaspoons = Field<Double>()
    var tablespoons = Field<Double>()
    var cups = Field<Double>()
    var pints = Field<Double>()
    var quarts = Field<Double>()
    var gallons = Field<Double>()
    var ml = Field<Double>()
    var liters = Field<Double>()
    var jiggers = Field<Double>()
    
    init() {
        // set up metadata and fields in the underlying ConverterModel
        model.pageTitle = "Liquid"
        model.pageHelp = "Help!"
        model.nf.minimumFractionDigits = 1
        model.nf.maximumFractionDigits = 1
        model.nf.numberStyle = .decimal
        model.fl.items = [
            FieldDesc(label: "Ounces", field: ounces),
            FieldDesc(label: "Teaspoons", field: teaspoons),
            FieldDesc(label: "Tablespoons", field: tablespoons),
            FieldDesc(label: "Cups", field: cups),
            FieldDesc(label: "Pints", field: pints),
            FieldDesc(label: "Quarts", field: quarts),
            FieldDesc(label: "Gallons", field: gallons),
            FieldDesc(label: "Milliliters", field: ml),
            FieldDesc(label: "Liters", field: liters),
            FieldDesc(label: "Jiggers", field: jiggers)
        ]
        for fd in model.fl.items {
            fd.field.formatter = model.nf
            model.network.adoptField(field: fd.field)
            fd.field.isEqual = { fabs($0 - $1) < 0.00001 }
        }
       
        // specify calculations (setters)
        Calculator1OpFactory.registerFactory(target: teaspoons, operand0: tablespoons) {  $0 * 3.0 }
        Calculator1OpFactory.registerFactory(target: tablespoons, operand0: teaspoons) { $0 / 3.0 }
        Calculator1OpFactory.registerFactory(target: teaspoons, operand0: ounces) { $0 * 6.0 }
        Calculator1OpFactory.registerFactory(target: ounces, operand0: teaspoons) { $0 / 6.0 }
        Calculator1OpFactory.registerFactory(target: cups, operand0: ounces) { $0 / 8.0 }
        Calculator1OpFactory.registerFactory(target: ounces, operand0: cups) { $0 * 8.0 }
        Calculator1OpFactory.registerFactory(target: pints, operand0: cups) { $0 / 2.0 }
        Calculator1OpFactory.registerFactory(target: cups, operand0: pints) { $0 * 2.0 }
        Calculator1OpFactory.registerFactory(target: quarts, operand0: cups) { $0 / 4.0 }
        Calculator1OpFactory.registerFactory(target: cups, operand0: quarts) { $0 * 4.0 }
        Calculator1OpFactory.registerFactory(target: cups, operand0: gallons) { $0 * 16.0 }
        Calculator1OpFactory.registerFactory(target: gallons, operand0: cups) { $0 / 16.0 }
        Calculator1OpFactory.registerFactory(target: jiggers, operand0: ounces) { $0 / 1.5 }
        Calculator1OpFactory.registerFactory(target: ounces, operand0: jiggers) { $0 * 1.5 }
        Calculator1OpFactory.registerFactory(target: ounces, operand0: ml) { $0 / 29.5735 }
        Calculator1OpFactory.registerFactory(target: ml, operand0: ounces) { $0 * 29.5735 }
        Calculator1OpFactory.registerFactory(target: liters, operand0: ml) { $0 / 1000.0 }
        Calculator1OpFactory.registerFactory(target: ml, operand0: liters) { $0 * 1000.0 }

        model.network.delegate = model
        model.network.connectCalculators()
    }
}

// just used for immediate previews/debugging
struct LiquidView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView(model: LiquidFactory().model)
    }
}

