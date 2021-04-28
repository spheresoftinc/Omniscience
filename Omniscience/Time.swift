//
//  Time.swift
//  Omniscience
//
//  Created by Philip Brittan on 4/18/21.
//


import Foundation
import SwiftBicycle
import SwiftUI

// time value of money calculator
class TimeFactory {
    @ObservedObject var model = ConverterModel()
    var nanos = Field<Double>()
    var millis = Field<Double>()
    var seconds = Field<Double>()
    var minutes = Field<Double>()
    var hours = Field<Double>()
    var days = Field<Double>()
    var weeks = Field<Double>()
    var months = Field<Double>()
    var fortnights = Field<Double>()
    var years = Field<Double>()
    
    
    init() {
        model.pageTitle = "Time"
        model.pageHelp = "Help!"
        model.nf.minimumFractionDigits = 2
        model.nf.maximumFractionDigits = 2
        model.nf.numberStyle = .decimal
        
        model.fl.items = [
            FieldDesc(label: "Nanoseconds", field: nanos),
            FieldDesc(label: "Milliseconds", field: millis),
            FieldDesc(label: "Seconds", field: seconds),
            FieldDesc(label: "Minutes", field: minutes),
            FieldDesc(label: "Hours", field: hours),
            FieldDesc(label: "Days", field: days),
            FieldDesc(label: "Weeks", field: weeks),
            FieldDesc(label: "Fortnights", field: fortnights),
            FieldDesc(label: "Months", field: months),
            FieldDesc(label: "Years", field: years)
        ]
        
        for fd in model.fl.items {
            fd.field.formatter = model.nf
            model.network.adoptField(field: fd.field)
            fd.field.isEqual = { fabs($0 - $1) < 0.00001 }
        }
       
        Calculator1OpFactory.registerFactory(target: nanos, operand0: seconds) {
                $0 * 1000000000.0
        }
        Calculator1OpFactory.registerFactory(target: seconds, operand0: nanos) {
                $0 / 1000000000.0
        }
        Calculator1OpFactory.registerFactory(target: millis, operand0: seconds) {
                $0 * 1000.0
        }
        Calculator1OpFactory.registerFactory(target: seconds, operand0: millis) {
                $0 / 1000.0
        }
        Calculator1OpFactory.registerFactory(target: minutes, operand0: seconds) {
                $0 / 60.0
        }
        Calculator1OpFactory.registerFactory(target: seconds, operand0: minutes) {
                $0 * 60.0
        }
        Calculator1OpFactory.registerFactory(target: minutes, operand0: hours) {
                $0 * 60.0
        }
        Calculator1OpFactory.registerFactory(target: hours, operand0: minutes) {
                $0 / 60.0
        }
        Calculator1OpFactory.registerFactory(target: days, operand0: hours) {
                $0 / 24.0
        }
        Calculator1OpFactory.registerFactory(target: hours, operand0: days) {
                $0 * 24.0
        }
        Calculator1OpFactory.registerFactory(target: days, operand0: weeks) {
                $0 * 7.0
        }
        Calculator1OpFactory.registerFactory(target: weeks, operand0: days) {
                $0 / 7.0
        }
        Calculator1OpFactory.registerFactory(target: days, operand0: fortnights) {
                $0 * 14.0
        }
        Calculator1OpFactory.registerFactory(target: fortnights, operand0: days) {
                $0 / 14.0
        }
        Calculator1OpFactory.registerFactory(target: days, operand0: months) {
                $0 * 30.4375
        }
        
        Calculator1OpFactory.registerFactory(target: months, operand0: days) {
                $0 / 30.4375
        }
        Calculator1OpFactory.registerFactory(target: months, operand0: years) {
                $0 * 12.0
        }
        Calculator1OpFactory.registerFactory(target: years, operand0: months) {
                $0 / 12.0
        }
        
        model.network.delegate = model
        model.network.connectCalculators()
    }
}

struct TimeView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView(model: TimeFactory().model)
    }
}

