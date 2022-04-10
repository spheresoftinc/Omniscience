//
//  ConverterUtilities.swift
//  Converter
//
//  Created by Philip Brittan on 4/8/21.
//

import Foundation
import SwiftUI
import SwiftBicycle

// display the text font in blue/black/red depending on the field status code
extension TextField where Label == Text {
    func foregroundColor(code: AnyField.Code) -> some View {
        let color: Color
        switch code {
        case .error:
            color = .red
        case .set:
            color = .blue
        default:
            color = .black
        }
        return foregroundColor(color)
    }
}

// displays one row of label and TextField for a converter based on the FieldDesc passed in
struct ConverterRow: View {
    @Binding var fd: FieldDesc
    
    var body: some View {
        HStack {
            
            Text(fd.label + " ")
                .frame(width: 120, alignment: .trailing)
            
            TextField(fd.label, field: $fd.field)
                .foregroundColor(code: fd.field.code)
                .keyboardType(fd.keyboard)
        }
    }
}

// label:field pair for storage in the field list
struct FieldDesc: Hashable, Identifiable  {
    static func == (lhs: FieldDesc, rhs: FieldDesc) -> Bool {   // fields are equal if IDs match
        lhs.id == rhs.id
    }
    let id = UUID() // needed to make this Identifiable
    var label: String
    var field: Field<Double>
    var keyboard = UIKeyboardType.numbersAndPunctuation // default keyboard
}

// needed extensions to support iterable field lists in Views properly
struct IndexedCollection<Base: RandomAccessCollection>: RandomAccessCollection
{
     typealias Index = Base.Index
     typealias Element = (index: Index, element: Base.Element)

     let base: Base
     var startIndex: Index { base.startIndex }
     var endIndex: Index { base.endIndex }

     func index(after i: Index) -> Index {   base.index(after: i)    }

     func index(before i: Index) -> Index {  base.index(before: i)   }

     func index(_ i: Index, offsetBy distance: Int) -> Index {  base.index(i, offsetBy: distance)    }

     subscript(position: Index) -> Element {  (index: position, element: base[position])     }
}

extension RandomAccessCollection
{
    func indexed() -> IndexedCollection<Self>
    {
        IndexedCollection(base: self)
    }
}

// list of label:field pairs for storage and presentation in converter views
class FieldList: ObservableObject {
    @Published var items = [FieldDesc]()
}

// truly insane that I have to supply my own cotangent function...  Come on, Swift!
func cot(_ x:Double) -> Double {
    cos(x) / sin(x)
}
