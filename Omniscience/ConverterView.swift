//
//  ConverterView.swift
//  Converter
//
//  Created by Philip Brittan on 4/16/21.
//

import Foundation
import SwiftBicycle
import SwiftUI

// store the upderlying BicycleNetwork that wires up the fields and calcs (model) of a converter plus some general descriptive info
// the model for eaxch calculator screen gets decorated by a corresponding Factory class
class ConverterModel: ObservableObject, BicycleNetworkDelegate, Identifiable {
    let objectWillChange = ObjectWillChangePublisher()
    let ID = UUID()

    let network = BicycleNetwork()

    var nf = NumberFormatter()  // default formatter for display of fields
    
    var pageTitle = ""
    var pageHelp = ""
    var pageImage: String = ""
    
    @ObservedObject var fl: FieldList = FieldList()
    
    init() {
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 4
        nf.numberStyle = .decimal
    }
    
    func networkWillCalculate(_ network: BicycleNetwork) {
        objectWillChange.send()
    }
}

// display one converter in a standard way based on a passed-in ConverterModel
struct ConverterView: View {
    @ObservedObject var model: ConverterModel
    @State var isHelpPresented = false
    
    var body: some View {
        
        List {
            
            // if there is an image for the converter, show it. May support multiple images at some point.
            if (model.pageImage.isEmpty == false) {
                HStack {
                    Spacer()
                    Image(model.pageImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150)
                    Spacer()
                }
            }
            
            // iterate through the model's FieldList and lay out in View
            ForEach(model.fl.items.indexed(), id: \.1.id) { index, fd in
                ConverterRow(text: fd.label, field: self.model.$fl.items[index].field)
            }
          
        }
        .navigationTitle(model.pageTitle)
        .navigationBarTitleDisplayMode(.automatic)
        .navigationBarItems(trailing:
                HStack {
                    // All Clear button
                    Button(action: { model.network.dropUserProvidedSetters() }, label: {
                        Image(systemName: "c.circle.fill")
                            .foregroundColor(.gray)
                            .font(.title)
                    })
                    
                    // Help button
                    let fileUrl = Bundle.main.url(forResource: model.pageHelp, withExtension: "pdf")
                    if (fileUrl != nil) { // only show the Help button if there is a valid Help page specified
                        Button(action: { self.isHelpPresented = true }, label: {
                            Image(systemName: "questionmark.circle")
                                .foregroundColor(.gray)
                                .font(.title)
                        })
                    }
                })
        .sheet(isPresented: $isHelpPresented) { // this displays the pop-up Help page
            ConverterHelpView(showHelp: $isHelpPresented, helpPage: model.pageHelp)
        }
    }
}

// show a pop-over Help page for a converter
struct ConverterHelpView: View {
    @Binding var showHelp: Bool
    var helpPage: String
    
    var body: some View {
        let fileUrl = Bundle.main.url(forResource: helpPage, withExtension: "pdf")
        VStack {
            HStack {
                Spacer()    // push Close button to right side
                Button(action: { self.showHelp = false }, label: {
                    Image(systemName: "xmark.circle.fill")  // Close button
                })
                .foregroundColor(.gray)
                .font(.title)
                .padding()
            }
            if (fileUrl != nil) {   // show Help page if there is a valid one
                PDFKitView(url: fileUrl!)
            }
            Spacer() // push text to top
        }
    }
}
