//
//  Tipping.swift
//  Omniscience
//
//  Created by Philip Brittan on 4/18/21.
//


import Foundation
import SwiftBicycle
import SwiftUI

// time value of money calculator
class TippingFactory {
    @ObservedObject var model = ConverterModel()
    var bill = Field<Double>()
    var percent = Field<Double>()
    var tip = Field<Double>()
    var total = Field<Double>()

    
    init() {
        model.pageTitle = "Tipping"
        model.pageHelp = "Help!"
        model.nf.minimumFractionDigits = 2
        model.nf.maximumFractionDigits = 2
        model.nf.numberStyle = .decimal
        
        model.fl.items = [
            FieldDesc(label: "Bill Amount", field: bill),
            FieldDesc(label: "Tip %", field: percent),
            FieldDesc(label: "Tip Amount", field: tip),
            FieldDesc(label: "Total", field: total)
        ]
        
        for fd in model.fl.items {
            fd.field.formatter = model.nf
            model.network.adoptField(field: fd.field)
            fd.field.isEqual = { fabs($0 - $1) < 0.00001 }
        }
        /*
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        total.formatter = nf
        */
        
        percent.setDefault(value: 18.0)
    
        Calculator2OpFactory.registerFactory(target: tip, operand0: bill, operand1: percent) { (b: Double, p: Double) -> Double in
                b * (p / 100.0)
        }
        
        Calculator2OpFactory.registerFactory(target: percent, operand0: bill, operand1: tip) { (b: Double, t: Double) -> Double in
                (t / b) * 100.0
        }
        
        Calculator2OpFactory.registerFactory(target: total, operand0: bill, operand1: tip) { (b: Double, t: Double) -> Double in
                b + t
        }
        
        Calculator2OpFactory.registerFactory(target: tip, operand0: bill, operand1: total) { (b: Double, t: Double) -> Double in
                t - b
        }

        model.network.delegate = model
        model.network.connectCalculators()
    }
}

struct TippingView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView(model: TippingFactory().model)
    }
}
