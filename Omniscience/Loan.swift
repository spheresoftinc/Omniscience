//
//  Loan.swift
//  Omniscience
//
//  Created by Philip Brittan on 4/18/21.
//


import Foundation
import SwiftBicycle
import SwiftUI

// time value of money calculator
class LoanFactory {
    @ObservedObject var model = ConverterModel()
    var PV = Field<Double>()
    var payment = Field<Double>()
    var rate = Field<Double>()
    var years = Field<Double>()
    var periods = Field<Double>()
    let perF = NumberFormatter()
    
    init() {
        model.pageTitle = "Loan"
        model.pageHelp = "Help!"
        model.nf.minimumFractionDigits = 2
        model.nf.maximumFractionDigits = 2
        model.nf.numberStyle = .decimal
        
        model.fl.items = [
            FieldDesc(label: "Present Value", field: PV),
            FieldDesc(label: "Payment", field: payment),
            FieldDesc(label: "Interest (%)", field: rate),
            FieldDesc(label: "Years", field: years),
            FieldDesc(label: "Payments / Year", field: periods)
        ]
        
        for fd in model.fl.items {
            fd.field.formatter = model.nf
            model.network.adoptField(field: fd.field)
            fd.field.isEqual = { fabs($0 - $1) < 0.00001 }
        }
        // override formattingh for rate
       // perF.numberStyle = .percent
       // rate.formatter = perF
       
        Calculator4OpFactory.registerFactory(target: payment, operand0: PV, operand1: rate, operand2: years, operand3: periods) { (pv: Double, r: Double, y: Double, p: Double) -> Double in
            pv * (r / 100.0 / p) / (1.0 - pow(1.0 + (r / 100.0 / p), -(p * y)))
        }
        
        Calculator4OpFactory.registerFactory(target: PV, operand0: payment, operand1: rate, operand2: years, operand3: periods) { (pay: Double, r: Double, y: Double, p: Double) -> Double in
                (pay * (1.0 - pow(1.0 + (r / 100.0 / p), -(p * y)))) / (r / 100.0 / p)
        }

        model.network.delegate = model
        model.network.connectCalculators()
    }
}

struct LoanView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView(model: LoanFactory().model)
    }
}
