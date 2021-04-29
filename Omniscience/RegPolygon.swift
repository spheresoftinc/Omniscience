//
//  RegPolygon.swift
//  Omniscience
//
//  Created by Philip Brittan on 4/29/21.
//


import Foundation
import SwiftBicycle
import SwiftUI

class RegPolygonFactory {
    @ObservedObject var model = ConverterModel()
    // create fields
    var numSides = Field<Double>()
    var sideLength = Field<Double>()
    var perimeter = Field<Double>()
    var area = Field<Double>()
    var inradius = Field<Double>()
    var circumradius = Field<Double>()
    
    init() {
        // set up metadata and fields in the underlying ConverterModel
        model.pageTitle = "Regular Polygon"
        model.pageImage = ""
        model.pageHelp = "regpolygonhelp"
        model.nf.minimumFractionDigits = 0
        model.nf.maximumFractionDigits = 4
        model.nf.numberStyle = .decimal
        model.fl.items = [
            FieldDesc(label: "Sides", field: numSides),
            FieldDesc(label: "Lengths", field: sideLength),
            FieldDesc(label: "Perimeter", field: perimeter),
            FieldDesc(label: "Area", field: area),
            FieldDesc(label: "Inradius", field: inradius),
            FieldDesc(label: "Circumradius", field: circumradius)
        ]
        for fd in model.fl.items {
            fd.field.formatter = model.nf
            model.network.adoptField(field: fd.field)
            fd.field.isEqual = { fabs($0 - $1) < 0.00001 }
        }
       
        // specify calculations (setters)
        Calculator2OpFactory.registerFactory(target: perimeter, operand0: numSides, operand1: sideLength) {  $0 * $1 }
        Calculator2OpFactory.registerFactory(target: sideLength, operand0: numSides, operand1: perimeter) {  $1 / $0 }
        
        Calculator2OpFactory.registerFactory(target: area, operand0: numSides, operand1: sideLength) {
                $0 * pow($1, 2.0) * cot(Double.pi / $0) / 4.0
        }
        Calculator2OpFactory.registerFactory(target: sideLength, operand0: numSides, operand1: area) {
                sqrt($1 / ($0 * cot(Double.pi / $0) / 4.0))
        }
        Calculator2OpFactory.registerFactory(target: inradius, operand0: numSides, operand1: sideLength) {
                $1 / (2.0 * tan(Double.pi / $0))
        }
        Calculator2OpFactory.registerFactory(target: sideLength, operand0: numSides, operand1: inradius) {
                $1 * (2.0 * tan(Double.pi / $0))
        }
        Calculator2OpFactory.registerFactory(target: circumradius, operand0: numSides, operand1: inradius) {
                $1 / cos(Double.pi / $0)
        }
        Calculator2OpFactory.registerFactory(target: inradius, operand0: numSides, operand1: circumradius) {
                $1 * cos(Double.pi / $0)
        }

        model.network.delegate = model
        model.network.connectCalculators()
    }
}

// just used for immediate previews/debugging
struct RegPolygonView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView(model: RegPolygonFactory().model)
    }
}
