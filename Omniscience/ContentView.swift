//
//  ContentView.swift
//  Omniscience
//
//  Created by Philip Brittan on 4/7/21.
//

import SwiftUI
import SwiftBicycle


struct ContentView: View {
    @State var isHelpPresented = false // is the Help page showing now
    // use factories to build model for each converter
    // store the models in lists, grouped thematically
    @State var basics = [
        TippingFactory().model,
        LiquidFactory().model,
        TemperatureFactory().model,
        LengthFactory().model,
        AreaFactory().model,
        WeightFactory().model,
        TimeFactory().model
    ]
    @State var geometry = [
        TriangleFactory().model,
        CircleFactory().model,
        CylinderFactory().model,
        SphereFactory().model
    ]
    @State var physics = [
        SpeedFactory().model,
        ElectricityFactory().model,
        IdealGasFactory().model
    ]
    @State var financials = [
        TVMFactory().model,
        LoanFactory().model]
    
    let mainHelpPage = "mainhelp" // name of PDF with main help page

    var body: some View {
        
        NavigationView {
            
            List {
                Section(header: Text("Basics")) {
                    ForEach(basics) { c in
                        NavigationLink(destination: ConverterView(model: c)) {
                            Text(c.pageTitle)
                        }
                    }
                }
                Section(header: Text("Geometry")) {
                    ForEach(geometry) { c in
                        NavigationLink(destination: ConverterView(model: c)) {
                            Text(c.pageTitle)
                        }
                    }
                }
                Section(header: Text("Pysics")) {
                    ForEach(physics) { c in
                        NavigationLink(destination: ConverterView(model: c)) {
                            Text(c.pageTitle)
                        }
                    }
                }
                Section(header: Text("Financial")) {
                    ForEach(financials) { f in
                        NavigationLink(destination: ConverterView(model: f)) {
                            Text(f.pageTitle)
                        }
                    }
                }
            }
            .navigationBarTitle("OMNISCIENCE")
            .navigationBarTitleDisplayMode(.automatic)
            .navigationBarItems(trailing: Button(action: { self.isHelpPresented = true }, label: {
                Image(systemName: "questionmark.circle") // Help button
                    .foregroundColor(.gray)
                    .font(.title)
                }))
            .sheet(isPresented: $isHelpPresented) { // show the Help page
                    ConverterHelpView(showHelp: $isHelpPresented, helpPage: mainHelpPage)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
