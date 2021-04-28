//
//  Spheres.swift
//  Converter
//
//  Created by Philip Brittan on 4/10/21.
//


import Foundation
import SwiftBicycle
import SwiftUI

class SphereFactory {
    @ObservedObject var model = ConverterModel()
    
    // Create fields
    var radius = Field<Double>()
    var diameter = Field<Double>()
    var circumference = Field<Double>()
    var surface = Field<Double>()
    var volume = Field<Double>()
    
    init() {
        model.pageTitle = "Sphere"
        model.pageImage = "sphere002"
        model.pageHelp = "Spheres are balls"
        model.nf.minimumFractionDigits = 0
        model.nf.maximumFractionDigits = 4
        model.nf.numberStyle = .decimal
        
        model.fl.items = [
            FieldDesc(label: "Radius", field: radius),
            FieldDesc(label: "Diameter", field: diameter),
            FieldDesc(label: "Circumference", field: circumference),
            FieldDesc(label: "Surface", field: surface),
            FieldDesc(label: "Volume", field: volume)
        ]
        
        for fd in model.fl.items {
            fd.field.formatter = model.nf
            model.network.adoptField(field: fd.field)
            fd.field.isEqual = { fabs($0 - $1) < 0.00001 }
        }
       
        Calculator1OpFactory.registerFactory(target: diameter, operand0: radius) {  $0 * 2.0 }
        Calculator1OpFactory.registerFactory(target: radius, operand0: diameter) { $0 / 2.0 }
        Calculator1OpFactory.registerFactory(target: circumference, operand0: diameter) { $0 * Double.pi }
        Calculator1OpFactory.registerFactory(target: diameter, operand0: circumference) { $0 / Double.pi }
        Calculator1OpFactory.registerFactory(target: surface, operand0: radius) { 4.0 * Double.pi * pow($0, 2.0) }
        Calculator1OpFactory.registerFactory(target: radius, operand0: surface) { sqrt($0 / (4.0 * Double.pi)) }
        Calculator1OpFactory.registerFactory(target: volume, operand0: radius) { (4.0 / 3.0) * Double.pi * pow($0, 3.0) }
        Calculator1OpFactory.registerFactory(target: radius, operand0: volume) { pow($0 / (4.0 / 3.0 * Double.pi), 1.0 / 3.0) }
        
        model.network.delegate = model
        model.network.connectCalculators()
    }
}

struct SpheresView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView(model: SphereFactory().model)
    }
}


