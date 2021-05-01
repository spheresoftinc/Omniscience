//
//  ellipse.swift
//  Omniscience
//
//  Created by Philip Brittan on 4/30/21.
//


import Foundation
import SwiftBicycle
import SwiftUI

func Perimeter(a: Double, b: Double) -> Double {
    let h = pow(a - b, 2.0) / pow(a + b, 2.0)
    return Double.pi * (a + b) * ( 1.0 + (3.0 * h / (10.0 + sqrt(4.0 - 3.0 * h))))
}

class EllipseFactory {
    @ObservedObject var model = ConverterModel()
    // create fields
    var majorRadius = Field<Double>()
    var minorRadius = Field<Double>()
    var foci = Field<Double>()
    var eccentricity = Field<Double>()
    var area = Field<Double>()
    var perimeter = Field<Double>()
    
    init() {
        // set up metadata and fields in the underlying ConverterModel
        model.pageTitle = "Ellipse"
        model.pageImage = "ellipse"
        model.pageHelp = "ellipsehelp"
        model.nf.minimumFractionDigits = 0
        model.nf.maximumFractionDigits = 4
        model.nf.numberStyle = .decimal
        model.fl.items = [
            FieldDesc(label: "Maj Radius (a)", field: majorRadius),
            FieldDesc(label: "Min Radius (b)", field: minorRadius),
            FieldDesc(label: "Focal Len (f)", field: foci),
            FieldDesc(label: "Eccentricity", field: eccentricity),
            FieldDesc(label: "Area", field: area),
            FieldDesc(label: "Perimeter", field: perimeter)
        ]
        for fd in model.fl.items {
            fd.field.formatter = model.nf
            model.network.adoptField(field: fd.field)
            fd.field.isEqual = { fabs($0 - $1) < 0.00001 }
        }
       
        // specify calculations (setters)
        Calculator2OpFactory.registerFactory(target: eccentricity, operand0: majorRadius, operand1: minorRadius) {
                sqrt(1.0 - (pow($1, 2.0) / pow($0, 2.0)))
        }
        Calculator2OpFactory.registerFactory(target: foci, operand0: majorRadius, operand1: minorRadius) {
                sqrt(pow($0, 2.0) - pow($1, 2.0))
        }
        Calculator2OpFactory.registerFactory(target: area, operand0: majorRadius, operand1: minorRadius) {
                Double.pi * $0 * $1
        }
        Calculator2OpFactory.registerFactory(target: perimeter, operand0: majorRadius, operand1: minorRadius) {
                Perimeter(a: $0, b: $1)
        }
        

        model.network.delegate = model
        model.network.connectCalculators()
    }
}

// just used for immediate previews/debugging
struct EllipseView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView(model: EllipseFactory().model)
    }
}
