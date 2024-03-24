//
//  ChatView.swift
//  FestivalDuJeu
//
//  Created by etud on 11/03/2024.
//

import SwiftUI

struct ConsultPlanningView: View {
    @EnvironmentObject private var planningViewModel: PlanningViewModel
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var selectedJour: Int = 0
    
    var body: some View {
        VStack {
            Text("Planning")
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
            
            ConsultDayView(jour: $planningViewModel.jours[selectedJour])
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

struct ConsultPlanningView_Previews: PreviewProvider {
    static var previews: some View {
        ConsultPlanningView()
    }
}
