//
//  Triangle.swift
//  Converter
//
//  Created by Philip Brittan on 4/9/21.
//

import Foundation
import SwiftBicycle
import SwiftUI

func angleFromSides(a: Double, b: Double, c: Double) -> Double {
    print("calc angleFromSides")
    return acos((pow(b,2.0) + pow(c,2.0) - pow(a,2.0)) / (2.0 * b * c))
}

// factory class to build the guts of the Triangle converter
class TriangleFactory {
    @ObservedObject var model = ConverterModel()
    
    // Create fields
    var angleA = Field<Double>()
    var radA = Field<Double>()
    var angleB = Field<Double>()
    var radB = Field<Double>()
    var angleC = Field<Double>()
    var radC = Field<Double>()
    var sideA = Field<Double>()
    var sideB = Field<Double>()
    var sideC = Field<Double>()
    var circumference = Field<Double>()
    var area = Field<Double>()
    var height = Field<Double>()
    var median = Field<Double>()
    var inradius = Field<Double>()
    var circumradius = Field<Double>()
    
    init() {
        model.pageTitle = "Triangle"
        model.pageImage = "triangle"
        model.pageHelp = "trianglehelp"
        model.nf.minimumFractionDigits = 0
        model.nf.maximumFractionDigits = 4
        model.nf.numberStyle = .decimal
        
        model.fl.items = [
            FieldDesc(label: "A (degrees)", field: angleA),
            FieldDesc(label: "A (radians)", field: radA),
            FieldDesc(label: "side c", field: sideC),
            FieldDesc(label: "B (degrees)", field: angleB),
            FieldDesc(label: "B (radians)", field: radB),
            FieldDesc(label: "side a", field: sideA),
            FieldDesc(label: "C (degrees)", field: angleC),
            FieldDesc(label: "C (radians)", field: radC),
            FieldDesc(label: "side b", field: sideB),
            FieldDesc(label: "Circumference", field: circumference),
            FieldDesc(label: "Area", field: area),
            FieldDesc(label: "Height", field: height),
            FieldDesc(label: "Median", field: median),
            FieldDesc(label: "Inradius", field: inradius),
            FieldDesc(label: "Circumradius", field: circumradius)
        ]
        
        for fd in model.fl.items {
            fd.field.formatter = model.nf
            model.network.adoptField(field: fd.field)
            fd.field.isEqual = { fabs($0 - $1) < 0.00001 }
        }
       
        // set up calculators (setters)
        
        // these convert between Degrees and Radians
        Calculator1OpFactory.registerFactory(target: radA, operand0: angleA) { $0 * (Double.pi / 180.0) }
        Calculator1OpFactory.registerFactory(target: radB, operand0: angleB) { $0 * (Double.pi / 180.0) }
        Calculator1OpFactory.registerFactory(target: radC, operand0: angleC) { $0 * (Double.pi / 180.0) }
        Calculator1OpFactory.registerFactory(target: angleA, operand0: radA) { $0 / (Double.pi / 180.0) }
        Calculator1OpFactory.registerFactory(target: angleB, operand0: radB) { $0 / (Double.pi / 180.0) }
        Calculator1OpFactory.registerFactory(target: angleC, operand0: radC) { $0 / (Double.pi / 180.0) }
        
        // these ensure that the sum of the angles equals 180 degrees
        Calculator2OpFactory.registerFactory(target: angleA, operand0: angleB, operand1: angleC) { 180.0 - ($0 + $1) } readyFn: { ($0 + $1) < 180.0 }
        Calculator2OpFactory.registerFactory(target: angleB, operand0: angleA, operand1: angleC) { 180.0 - ($0 + $1) } readyFn: { ($0 + $1) < 180.0 }
        Calculator2OpFactory.registerFactory(target: angleC, operand0: angleA, operand1: angleB) { 180.0 - ($0 + $1) } readyFn: { ($0 + $1) < 180.0 }
        
        
        Calculator3OpFactory.registerFactory(target: sideA, operand0: radA, operand1: radB, operand2: sideB) { $2 * sin($0) / sin($1) }
        Calculator3OpFactory.registerFactory(target: sideA, operand0: radA, operand1: radC, operand2: sideC) { $2 * sin($0) / sin($1) }
        
        Calculator3OpFactory.registerFactory(target: sideB, operand0: radB, operand1: radA, operand2: sideA) { $2 * sin($0) / sin($1) }
       Calculator3OpFactory.registerFactory(target: sideB, operand0: radB, operand1: radC, operand2: sideC) { $2 * sin($0) / sin($1) }
        
        Calculator3OpFactory.registerFactory(target: sideC, operand0: radC, operand1: radB, operand2: sideB) { $2 * sin($0) / sin($1) }
        Calculator3OpFactory.registerFactory(target: sideC, operand0: radC, operand1: radA, operand2: sideA) { $2 * sin($0) / sin($1) }
        
        // these calculate the Angles given the Sides
        Calculator3OpFactory.registerFactory(target: radA, operand0: sideA, operand1: sideB, operand2: sideC) { (a: Double, b: Double, c: Double) -> Double in
                angleFromSides(a: a, b: b, c: c)  }
        
        Calculator3OpFactory.registerFactory(target: radB, operand0: sideA, operand1: sideB, operand2: sideC) { (a: Double, b: Double, c: Double) -> Double in
                angleFromSides(a: b, b: a, c: c) }
        
        Calculator3OpFactory.registerFactory(target: radC, operand0: sideA, operand1: sideB, operand2: sideC) { (a: Double, b: Double, c: Double) -> Double in
                angleFromSides(a: c, b: a, c: b) }
        
        // translate between Circumference and the Sides
        Calculator3OpFactory.registerFactory(target: circumference, operand0: sideA, operand1: sideB, operand2: sideC) { (a: Double, b: Double, c: Double) -> Double in
                a + b + c }
        
        Calculator3OpFactory.registerFactory(target: sideA, operand0: circumference, operand1: sideB, operand2: sideC) { (a: Double, b: Double, c: Double) -> Double in
                a - (b + c) }
        
        Calculator3OpFactory.registerFactory(target: sideB, operand0: circumference, operand1: sideA, operand2: sideC) { (a: Double, b: Double, c: Double) -> Double in
                a - (b + c) }
        
        Calculator3OpFactory.registerFactory(target: sideC, operand0: circumference, operand1: sideA, operand2: sideB) { (a: Double, b: Double, c: Double) -> Double in
                a - (b + c) }
        
        Calculator3OpFactory.registerFactory(target: area, operand0: sideA, operand1: sideB, operand2: radC) { (a: Double, b: Double, C: Double) -> Double in
                    0.5 * a * b * sin(C) }
        
        Calculator2OpFactory.registerFactory(target: height, operand0: area, operand1: sideA) { (area: Double, a: Double) -> Double in
                2.0 * area / a }
        
        Calculator2OpFactory.registerFactory(target: area, operand0: height, operand1: sideA) { (h: Double, a: Double) -> Double in
                a * h / 2.0 }
        
        Calculator3OpFactory.registerFactory(target: median, operand0: sideA, operand1: sideB, operand2: sideC) { (a: Double, b: Double, C: Double) -> Double in
            sqrt((2.0 * pow(b, 2.0) + 2.0 * pow(C, 2.0) - pow(a, 2.0)) / 4.0) }
        
        Calculator4OpFactory.registerFactory(target: inradius, operand0: area, operand1: sideA, operand2: sideB, operand3: radC) { (area: Double, a: Double, b: Double, c: Double) -> Double in
                area *  2.0 / (a + b + c) }
        
        Calculator2OpFactory.registerFactory(target: circumradius, operand0: sideA, operand1: radA) { (a: Double, A: Double) -> Double in
                a / (2.0 * sin(A)) }
        
        model.network.delegate = model
        model.network.connectCalculators()
    }
}

struct TriangleView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView(model: TriangleFactory().model)
    }
}

