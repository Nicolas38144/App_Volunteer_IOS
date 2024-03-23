//
//  NumericalInputView.swift
//  FestivalDuJeu
//
//  Created by etud on 15/03/2024.
//

import SwiftUI

struct NumericalInputView: View {
    @State var value = 0
    let title: String
    
    func incrementStep() {
        value += 1
    }
    func decrementStep() {
        value -= 1
        if value < 0 {
            value = 0
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            
            Stepper {
                Text("Nombre de particapation: \(value)")
            } onIncrement: {
                incrementStep()
            } onDecrement: {
                decrementStep()
            }
            .padding(5)
            
            Divider()
        }
    }
}

/*
struct NumericalInputView_Previews: PreviewProvider {
    static var previews: some View {
        NumericalInputView()
    }
}
*/
