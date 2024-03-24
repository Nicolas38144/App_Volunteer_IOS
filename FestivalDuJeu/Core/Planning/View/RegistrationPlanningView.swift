//
//  RegistrationPlanningView.swift
//  FestivalDuJeu
//
//  Created by etud on 15/03/2024.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct RegistrationPlanningView: View {
    @EnvironmentObject private var planningViewModel: PlanningViewModel
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var selectedJour: Int = 0
    
    var body: some View {
        VStack {
            Text("Inscription")
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .padding(.leading)
                .font(.title)
                .fontWeight(.bold)
            
            Picker("Jour", selection: $selectedJour) {
                ForEach(0..<planningViewModel.jours.count, id: \.self) { index in
                    Text(planningViewModel.jours[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selectedJour, perform: updateSelectedJour)
            
            RegistrationDayView(jour: $planningViewModel.jours[selectedJour])
        }
        .padding()
        .onAppear {
            Task {
                updateSelectedJour(_: selectedJour)
            }
        }
    }
    
    func updateSelectedJour(_ index: Int) {
        let uid = authViewModel.getUid()
        planningViewModel.setAffectationsPersoParJour(jour: planningViewModel.jours[selectedJour], id_user: uid)
    }
}

struct RegistrationPlanningView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationPlanningView()
    }
}
