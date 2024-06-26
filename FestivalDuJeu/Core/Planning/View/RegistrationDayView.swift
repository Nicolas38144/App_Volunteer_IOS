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
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    let horaires = ["9h-11h", "11h-14h", "14h-17h", "17h-20h", "20h-22h"]
    
    var body: some View {
        ScrollView {
            Spacer()
            ForEach(0..<self.horaires.count, id: \.self) { indexH in
                VStack {
                    Text(horaires[indexH])
                        .fontWeight(.bold)
                        .font(.title3)
                    
                    ForEach(0..<planningViewModel.postes.count, id: \.self) { indexP in
                        HStack {
                            Text(planningViewModel.postes[indexP].intitule)
                            Text(
                                "("
                                + String(planningViewModel.getNbAffectationsParHeureParPoste(
                                    id_creneau: planningViewModel.getIDPlage(creneau: horaires[indexH], jour: jour),
                                    poste: planningViewModel.postes[indexP].intitule)
                                )
                                + "/\(planningViewModel.postes[indexP].capacite))"
                            )
                            
                            Spacer()
                            
                            if (planningViewModel.checkIfRegistered(
                                id_creneau: planningViewModel.getIDPlage(creneau: horaires[indexH], jour: jour),
                                poste: planningViewModel.postes[indexP].intitule)
                            ) == true {
                                Button(action: {
                                    Task {
                                        do {
                                            let p = planningViewModel.postes[indexP].intitule
                                            let c = self.horaires[indexH]
                                            let i = authViewModel.getUid()
                                            
                                            let plageID = try await planningViewModel.desinscrisPoste(
                                                creneau: c,
                                                poste: p,
                                                jour: jour,
                                                id_user: i
                                            )
                                            
                                            // Suppression de l'entrée dans le tableau local
                                            planningViewModel.affectations = planningViewModel.affectations.filter { affectation in
                                                affectation.id_plage != plageID || affectation.poste != p || affectation.id_user != i
                                            }
                                            planningViewModel.affectationsPersoParJour = planningViewModel.affectationsPersoParJour.filter { affectation in
                                                affectation.id_plage != plageID || affectation.poste != p || affectation.id_user != i
                                            }
                                        }
                                        catch {
                                            print("Error: \(error)")
                                        }
                                    }
                                }) {
                                    Text("-")
                                        .foregroundColor(Color(.systemGray3))
                                        .background(.white)
                                        .font(.system(size:27))
                                        .padding([.horizontal], 25)
                                        .padding([.vertical], 4)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color(.systemGray3), lineWidth: 1)
                                        )
                                        
                                }
                            }
                            else {
                                if (String(planningViewModel.getNbAffectationsParHeureParPoste(
                                    id_creneau: planningViewModel.getIDPlage(creneau: horaires[indexH], jour: jour),
                                    poste: planningViewModel.postes[indexP].intitule)
                                ) != planningViewModel.postes[indexP].capacite) {
                                    Button(action: {
                                        Task {
                                            do {
                                                let p = planningViewModel.postes[indexP].intitule
                                                let c = self.horaires[indexH]
                                                let i = authViewModel.getUid()
                                                
                                                let idplage = try await planningViewModel.inscrisPoste(
                                                    creneau: c,
                                                    poste: p,
                                                    jour: jour,
                                                    id_user: i
                                                )
                                                
                                                // ajout le tableau local
                                                let affectation = Affecter_poste(id_plage: idplage, id_user: i, poste: p)
                                                planningViewModel.affectations.append(affectation)
                                                planningViewModel.affectationsPersoParJour.append(affectation)
                                            }
                                            catch {
                                                // Handle any errors here
                                                print("Error: \(error)")
                                            }
                                        }
                                    }) {
                                        Text("+")
                                            .foregroundColor(.white)
                                            .font(.system(size:27))
                                            .padding([.horizontal], 25)
                                            .padding([.vertical], 3)
                                            .background(Color(.systemGray3))
                                            .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        .padding()
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
