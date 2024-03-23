//
//  RegistrationDayView.swift
//  FestivalDuJeu
//
//  Created by etud on 23/03/2024.
//

import SwiftUI

struct RegistrationDayView: View {
    @Binding var jour: String
    @EnvironmentObject private var planningViewModel: PlanningViewModel
    
    let horaires = ["9h-11h", "11h-14h", "14h-17h", "17h-20h", "20h-22h"]
    
    var body: some View {
        ScrollView {
            ForEach(0..<planningViewModel.postes.count, id: \.self) { indexP in
                VStack {
                    Text(planningViewModel.postes[indexP].intitule)
                        .fontWeight(.bold)
                        .font(.title3)
                    Text(planningViewModel.postes[indexP].desc)
                        .foregroundStyle(Color(.systemGray))
                        ForEach(0..<horaires.count, id: \.self) { indexH in
                            HStack {
                                Text(self.horaires[indexH])
                                Spacer()
                                Text("+")
                            }
                        
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 3)
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
        }
        .navigationTitle(jour)
    }
}

struct RegistrationDayView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationDayView(jour: .constant("Jour 1"))
    }
}
