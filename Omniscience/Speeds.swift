//
//  Speeds.swift
//  Omniscience
//
//  Created by Philip Brittan on 6/13/21.
//


import Foundation
import SwiftBicycle
import SwiftUI

class SpeedsFactory {
    @ObservedObject var model = ConverterModel()
    var MPH = Field<Double>()
    var KPH = Field<Double>()
    var FPH = Field<Double>()
    var MtPH = Field<Double>()
    var FPM = Field<Double>()
    var MtPM = Field<Double>()
    var FPS = Field<Double>()
    var MtPS = Field<Double>()
    var MPM = Field<Double>()
    var MPS = Field<Double>()
    var KPM = Field<Double>()
    var KPS = Field<Double>()
    var Mach = Field<Double>()  // speed of sound
    var C = Field<Double>()     // speed of light
    
    init() {
        model.pageTitle = "Speeds"
        model.pageHelp = "Help!"
        model.nf.minimumFractionDigits = 0
        model.nf.maximumFractionDigits = 2
        model.nf.numberStyle = .decimal
        
        model.fl.items = [
            FieldDesc(label: "Miles / Hour", field: MPH),
            FieldDesc(label: "KM / Hour", field: KPH),
            FieldDesc(label: "Miles / Min", field: MPM),
            FieldDesc(label: "KM / Min", field: KPM),
            FieldDesc(label: "Miles / Sec", field: MPS),
            FieldDesc(label: "KM / Sec", field: KPS),
            FieldDesc(label: "Feet / Hour", field: FPH),
            FieldDesc(label: "Meters / Hour", field: MtPH),
            FieldDesc(label: "Feet / Min", field: FPM),
            FieldDesc(label: "Meters / Min", field: MtPM),
            FieldDesc(label: "Feet / Sec", field: FPS),
            FieldDesc(label: "Meters / Sec", field: MtPS),
            FieldDesc(label: "Mach", field: Mach),
            FieldDesc(label: "Speed of Light", field: C)
        ]
        
        for fd in model.fl.items {
            fd.field.formatter = model.nf
            model.network.adoptField(field: fd.field)
            fd.field.isEqual = { fabs($0 - $1) < 0.00001 }
        }
       
        Calculator1OpFactory.registerFactory(target: KPH, operand0: MPH) { $0 * 1.60934 }
        Calculator1OpFactory.registerFactory(target: MPH, operand0: KPH) { $0 / 1.60934 }
        
        Calculator1OpFactory.registerFactory(target: MPH, operand0: MPM) { $0 * 60.0 }
        Calculator1OpFactory.registerFactory(target: MPM, operand0: MPH) { $0 / 60.0 }
        Calculator1OpFactory.registerFactory(target: MPS, operand0: MPM) { $0 / 60.0 }
        Calculator1OpFactory.registerFactory(target: MPM, operand0: MPS) { $0 * 60.0 }
        
        Calculator1OpFactory.registerFactory(target: KPH, operand0: KPM) { $0 * 60.0 }
        Calculator1OpFactory.registerFactory(target: KPM, operand0: KPH) { $0 / 60.0 }
        Calculator1OpFactory.registerFactory(target: KPS, operand0: KPM) { $0 / 60.0 }
        Calculator1OpFactory.registerFactory(target: KPM, operand0: KPS) { $0 * 60.0 }
        
        Calculator1OpFactory.registerFactory(target: FPH, operand0: MPH) { $0 * 5280.00 }
        Calculator1OpFactory.registerFactory(target: MPH, operand0: FPH) { $0 / 5280.0 }
        
        Calculator1OpFactory.registerFactory(target: FPH, operand0: FPM) { $0 * 60.0 }
        Calculator1OpFactory.registerFactory(target: FPM, operand0: FPH) { $0 / 60.0 }
        Calculator1OpFactory.registerFactory(target: FPS, operand0: FPM) { $0 / 60.0 }
        Calculator1OpFactory.registerFactory(target: FPM, operand0: FPS) { $0 * 60.0 }
        
        Calculator1OpFactory.registerFactory(target: MtPH, operand0: KPH) { $0 * 1000.0 }
        Calculator1OpFactory.registerFactory(target: KPH, operand0: MtPH) { $0 / 1000.0 }
        
        Calculator1OpFactory.registerFactory(target: MtPH, operand0: MtPM) { $0 * 60.0 }
        Calculator1OpFactory.registerFactory(target: MtPM, operand0: MtPH) { $0 / 60.0 }
        Calculator1OpFactory.registerFactory(target: MtPS, operand0: MtPM) { $0 / 60.0 }
        Calculator1OpFactory.registerFactory(target: MtPM, operand0: MtPS) { $0 * 60.0 }
        
        Calculator1OpFactory.registerFactory(target: Mach, operand0: MPH) { $0 / 767.269 }
        Calculator1OpFactory.registerFactory(target: MPH, operand0: Mach) { $0 * 767.269 }
        
        Calculator1OpFactory.registerFactory(target: C, operand0: MPS) { $0 / 186282.0 }
        Calculator1OpFactory.registerFactory(target: MPS, operand0: C) { $0 * 186282.0 }

        model.network.delegate = model
        model.network.connectCalculators()
    }
}

struct SpeedsView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView(model: SpeedsFactory().model)
    }
}
