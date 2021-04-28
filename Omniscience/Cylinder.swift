//
//  Cylinder.swift
//  Omniscience
//
//  Created by Philip Brittan on 4/19/21.
//


import Foundation
import SwiftBicycle
import SwiftUI

class CylinderFactory {
    @ObservedObject var model = ConverterModel()
    // create fields
    var radius = Field<Double>()
    var diameter = Field<Double>()
    var circumference = Field<Double>()
    var length = Field<Double>()
    var totalarea = Field<Double>()
    var tubearea = Field<Double>()
    var crosssection = Field<Double>()
    var volume = Field<Double>()

    
    init() {
        // set up metadata and fields in the underlying ConverterModel
        model.pageTitle = "Cylinder"
        model.pageImage = "cylinder"
        model.pageHelp = "Help!"
        model.nf.minimumFractionDigits = 1
        model.nf.maximumFractionDigits = 1
        model.nf.numberStyle = .decimal
        model.fl.items = [
            FieldDesc(label: "Radius", field: radius),
            FieldDesc(label: "Diameter", field: diameter),
            FieldDesc(label: "Circumference", field: circumference),
            FieldDesc(label: "Length", field: length),
            FieldDesc(label: "Cross-section", field: crosssection),
            FieldDesc(label: "Tube Surface", field: tubearea),
            FieldDesc(label: "Surface Area", field: totalarea),
            FieldDesc(label: "Volume", field: volume)
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
        Calculator1OpFactory.registerFactory(target: crosssection, operand0: radius) { Double.pi * pow($0, 2.0) }
        Calculator1OpFactory.registerFactory(target: radius, operand0: crosssection) { sqrt($0 / Double.pi) }
        
        Calculator2OpFactory.registerFactory(target: tubearea, operand0: circumference, operand1: length) { $0 * $1 }
        Calculator2OpFactory.registerFactory(target: circumference, operand0: tubearea, operand1: length) { $0 / $1 }
        Calculator2OpFactory.registerFactory(target: length, operand0: tubearea, operand1: circumference) { $0 / $1 }
        
        Calculator2OpFactory.registerFactory(target: totalarea, operand0: tubearea, operand1: crosssection)
                { $0 + ($1 * 2.0) }
        Calculator2OpFactory.registerFactory(target: volume, operand0: crosssection, operand1: length) { $0 * $1 }
        
        
        Calculator2OpFactory.registerFactory(target: crosssection, operand0: volume, operand1: length) { $0 / $1 }
        Calculator2OpFactory.registerFactory(target: length, operand0: volume, operand1: crosssection) { $0 / $1 }
        Calculator2OpFactory.registerFactory(target: crosssection, operand0: totalarea, operand1: tubearea)
                { ($0 - $1) / 2.0 }
        Calculator2OpFactory.registerFactory(target: tubearea, operand0: totalarea, operand1: crosssection)
                { $0 - (2.0 *  $1) }

        
        
        model.network.delegate = model
        model.network.connectCalculators()
    }
}

// just used for immediate previews/debugging
struct CylinderView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView(model: CylinderFactory().model)
    }
}
