//
//  Speed.swift
//  Converter
//
//  Created by Philip Brittan on 4/11/21.
//

import Foundation
import SwiftBicycle
import SwiftUI
import Combine

class SpeedFactory {
    @ObservedObject var model = ConverterModel()
    // create fields
    var acceleration = Field<Double>()
    var startVelocity = Field<Double>()
    var endVelocity = Field<Double>()
    var aveVelocity = Field<Double>()
    var distance = Field<Double>()
    var time = Field<Double>()
    
    init() {
        // set up metadata and fields in the underlying ConverterModel
        model.pageTitle = "Speed / Acceleration"
        model.pageHelp = "Help!"
        model.nf.minimumFractionDigits = 0
        model.nf.maximumFractionDigits = 4
        model.nf.numberStyle = .decimal
        model.fl.items = [
            FieldDesc(label: "Acceleration", field: acceleration),
            FieldDesc(label: "Start Speed", field: startVelocity),
            FieldDesc(label: "End Speed", field: endVelocity),
            FieldDesc(label: "Average Speed", field: aveVelocity),
            FieldDesc(label: "Distance", field: distance),
            FieldDesc(label: "Time", field: time)
        ]
        for fd in model.fl.items {
            fd.field.formatter = model.nf
            model.network.adoptField(field: fd.field)
            fd.field.isEqual = { fabs($0 - $1) < 0.00001 }
        }
       
        // specify calculations (setters)
        Calculator2OpFactory.registerFactory(target: distance, operand0: aveVelocity, operand1: time) { $0 * $1 }
        
        Calculator2OpFactory.registerFactory(target: time, operand0: aveVelocity, operand1: distance) { $1 / $0 }
        
        Calculator2OpFactory.registerFactory(target: aveVelocity, operand0: distance, operand1: time) { $0 / $1 }
        
        Calculator2OpFactory.registerFactory(target: aveVelocity, operand0: startVelocity, operand1: endVelocity) {
                ($0 + $1) / 2.0 }
        
        Calculator3OpFactory.registerFactory(target: acceleration, operand0: startVelocity, operand1: endVelocity, operand2: time) { ($1 - $0) / $2 }
        
        Calculator3OpFactory.registerFactory(target: endVelocity, operand0: startVelocity, operand1: acceleration, operand2: time) { ($1 * $2) + $0 }
        
        Calculator3OpFactory.registerFactory(target: startVelocity, operand0: endVelocity, operand1: acceleration, operand2: time) { $0 - ($1 * $2) }
        
        Calculator3OpFactory.registerFactory(target: startVelocity, operand0: aveVelocity, operand1: acceleration, operand2: time) { $0 - (($1 * $2) / 2.0) }

        model.network.delegate = model
        model.network.connectCalculators()
    }
}


// just used for immediate previews/debugging
struct SpeedView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView(model: SpeedFactory().model)
    }
}

