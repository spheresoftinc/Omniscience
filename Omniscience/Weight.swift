//
//  weights.swift
//  Converter
//
//  Created by Philip Brittan on 4/8/21.
//

import Foundation
import SwiftBicycle
import SwiftUI


class WeightFactory {
    @ObservedObject var model = ConverterModel()
    // create fields
    var ounces = Field<Double>()
    var pounds = Field<Double>()
    var tons = Field<Double>()
    var grams = Field<Double>()
    var kilograms = Field<Double>()
    var stone = Field<Double>()
    var metricTons = Field<Double>()
    
    init() {
        // set up metadata and fields in the underlying ConverterModel
        model.pageTitle = "Weight"
        model.pageHelp = "Help!"
        model.nf.minimumFractionDigits = 0
        model.nf.maximumFractionDigits = 4
        model.nf.numberStyle = .decimal
        model.fl.items = [
            FieldDesc(label: "Ounces", field: ounces),
            FieldDesc(label: "Pounds", field: pounds),
            FieldDesc(label: "Tons", field: tons),
            FieldDesc(label: "Grams", field: grams),
            FieldDesc(label: "Kilograms", field: kilograms),
            FieldDesc(label: "Metric Tons", field: metricTons),
            FieldDesc(label: "Stone", field: stone)
        ]
        for fd in model.fl.items {
            fd.field.formatter = model.nf
            model.network.adoptField(field: fd.field)
            fd.field.isEqual = { fabs($0 - $1) < 0.00001 }
        }
       
        // specify calculations (setters)
        Calculator1OpFactory.registerFactory(target: ounces, operand0: pounds) { $0 * 16.0 }
        Calculator1OpFactory.registerFactory(target: pounds, operand0: ounces) { $0 / 16.0 }
        Calculator1OpFactory.registerFactory(target: pounds, operand0: tons) { $0 * 2000.0 }
        Calculator1OpFactory.registerFactory(target: tons, operand0: pounds) { $0 / 2000.0 }
        Calculator1OpFactory.registerFactory(target: grams, operand0: ounces) { $0 * 28.3495 }
        Calculator1OpFactory.registerFactory(target: ounces, operand0: grams) { $0 / 28.3495 }
        Calculator1OpFactory.registerFactory(target: kilograms, operand0: grams) { $0 / 1000.0 }
        Calculator1OpFactory.registerFactory(target: grams, operand0: kilograms) { $0 * 1000.0 }
        Calculator1OpFactory.registerFactory(target: kilograms, operand0: metricTons) { $0 * 1000.0 }
        Calculator1OpFactory.registerFactory(target: metricTons, operand0: kilograms) { $0 / 1000.0 }
        Calculator1OpFactory.registerFactory(target: stone, operand0: pounds) { $0 / 14.0 }
        Calculator1OpFactory.registerFactory(target: pounds, operand0: stone) { $0 * 14.0 }

        model.network.delegate = model
        model.network.connectCalculators()
    }
}


// just used for immediate previews/debugging
struct WeightView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView(model: WeightFactory().model)
    }
}
