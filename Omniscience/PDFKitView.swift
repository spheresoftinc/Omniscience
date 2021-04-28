//
//  PDFKitView.swift
//  Omniscience
//
//  Created by Philip Brittan on 4/21/21.
//

import Foundation
import SwiftUI
import PDFKit


struct PDFKitView: View {
    var url: URL
    var body: some View {
        PDFKitRepresentedView(url)
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL
    init(_ url: URL) {
        self.url = url
    }

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        //pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.displaysPageBreaks = false
        pdfView.displayBox = .bleedBox
        pdfView.backgroundColor = .white
        pdfView.pageShadowsEnabled = false
        //pdfView.topAnchor().isActive = true
           // .topAnchor.constraint(equalTo: ).isActive = true
        pdfView.layoutDocumentView()
        return pdfView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Update the view.
    }
}
