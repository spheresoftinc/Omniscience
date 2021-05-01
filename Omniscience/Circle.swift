//
//  Circle.swift
//  Converter
//
//  Created by Philip Brittan on 4/10/21.
//


import Foundation
import SwiftBicycle
import SwiftUI

class CircleFactory {
    @ObservedObject var model = ConverterModel()
    // create fields
    var radius = Field<Double>()
    var diameter = Field<Double>()
    var circumference = Field<Double>()
    var area = Field<Double>()
    
    init() {
        // set up metadata and fields in the underlying ConverterModel
        model.pageTitle = "Circle"
        model.pageImage = "circle"
        model.pageHelp = "circlehelp"
        model.nf.minimumFractionDigits = 0
        model.nf.maximumFractionDigits = 4
        model.nf.numberStyle = .decimal
        model.fl.items = [
            FieldDesc(label: "Radius", field: radius),
            FieldDesc(label: "Diameter", field: diameter),
            FieldDesc(label: "Circumference", field: circumference),
            FieldDesc(label: "Area", field: area)
        ]
        for fd in model.fl.items {
            fd.field.formatter = model.nf
            model.network.adoptField(field: fd.field)
            fd.field.isEqual = { fabs($0 - $1) < 0.00001 }
        }
       
        // specify calculations (setters)
        Calculator1OpFactory.registerFactory(target: diameter, operand0: radius) {  $0 * 2.0 }
        Calculator1OpFactory.registerFactory(target: radius, operand0: diameter) { $0 / 2.0 }
        Calculator1OpFactory.registerFactory(target: circumference, operand0: diameter) { $0 * Double.pi }
        Calculator1OpFactory.registerFactory(target: diameter, operand0: circumference) { $0 / Double.pi }
        Calculator1OpFactory.registerFactory(target: area, operand0: radius) { Double.pi * pow($0, 2.0) }
        Calculator1OpFactory.registerFactory(target: radius, operand0: area) { sqrt($0 / Double.pi) }

        model.network.delegate = model
        model.network.connectCalculators()
    }
}

// just used for immediate previews/debugging
struct CircleView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView(model: CircleFactory().model)
    }
}
