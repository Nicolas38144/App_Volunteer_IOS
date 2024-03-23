//
//  updateProfileView.swift
//  FestivalDuJeu
//
//  Created by etud on 19/03/2024.
//

import SwiftUI

struct UpdateProfileView: View {
    enum Hebergement: String, CaseIterable, Identifiable {
        case Rien, Propose, Recherche
        var id: Self { self }
    }
    
    @State private var prenom = ""
    @State private var nom = ""
    @State private var email = ""
    @State private var nbParticipation = 0
    @State private var selectedHebergement: Hebergement = .Rien
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    func incrementStep() { nbParticipation += 1 }
    func decrementStep() {
        nbParticipation -= 1
        if nbParticipation < 0 { nbParticipation = 0 }
    }
    
    var body: some View {
        if let user = authViewModel.currentuser {
            NavigationStack {
                List {
                    ScrollView {
                        VStack {
                            VStack(spacing: 24) {
                                Text("Modifier son profil")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding(.top, 20)
                                    .padding(.bottom, 20)
                                
                                InputView(
                                    text: $prenom,
                                    title: "Prénom",
                                    placeholder: "Entrez vorte prénom"
                                ).onAppear {
                                    prenom = user.prenom
                                }
                                
                                InputView(
                                    text: $nom,
                                    title: "Nom",
                                    placeholder: "Entrez vorte nom"
                                ).onAppear {
                                    nom = user.nom
                                }
                                
                                InputView(
                                    text: $email,
                                    title: "Mail",
                                    placeholder: "Entrez vorte adresse mail"
                                ).autocapitalization(.none).onAppear {
                                    email = user.email
                                }
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Nombre de participation")
                                        .foregroundColor(Color(.darkGray))
                                        .fontWeight(.semibold)
                                        .font(.footnote)
                                    Stepper {
                                        Text("\(nbParticipation)")
                                    } onIncrement: {
                                        incrementStep()
                                    } onDecrement: {
                                        decrementStep()
                                    }
                                    .padding(5)
                                    .padding([.horizontal], 70)
                                    .onAppear {
                                        nbParticipation = user.nbParticipation
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Hebergement")
                                        .foregroundColor(Color(.darkGray))
                                        .fontWeight(.semibold)
                                        .font(.footnote)
                                    
                                    Picker("Hebergement", selection: $selectedHebergement) {
                                        Text("Rien").tag(Hebergement.Rien)
                                        Text("Propose").tag(Hebergement.Propose)
                                        Text("Recherche").tag(Hebergement.Recherche)
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                    .frame(height: 55)
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                                    .onAppear {
                                        if user.hebergement == "Rien" {
                                            selectedHebergement = .Rien
                                        }
                                        else if user.hebergement == "Propose" {
                                            selectedHebergement = .Propose
                                        }
                                        else {
                                            selectedHebergement = .Recherche
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 12)
                        }
                        
                        //Pour les boutons
                        HStack {
                            //Back button
                            NavigationLink {
                                ProfileView()
                                    .navigationBarBackButtonHidden(true)
                            } label: {
                                HStack {
                                    Image(systemName: "arrow.left")
                                    Text("Retour")
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                .frame(width: 160, height: 48)
                            }
                            .background(Color(.systemBlue))
                            .cornerRadius(10)
                            .padding(.top, 40)
                            
                            //Save button
                            Button {
                                Task {
                                    try await authViewModel.updateUser(
                                        prenom: prenom,
                                        nom: nom,
                                        email: email,
                                        nbParticipation: nbParticipation,
                                        hebergement: selectedHebergement.rawValue
                                    )
                                }
                            } label: {
                                HStack {
                                    Text("Sauvegarder")
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                .frame(width: 160, height: 48)
                            }
                            .background(Color(.systemBlue))
                            .disabled(!formIsValid)
                            .opacity(formIsValid ? 1.0 : 0.5 )
                            .cornerRadius(10)
                            .padding(.top, 40)
                        }
                    }
                }
            }
        }
    }
}

extension UpdateProfileView: AuthFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !prenom.isEmpty
        && !nom.isEmpty
        && (authViewModel.currentuser?.prenom != prenom
        || authViewModel.currentuser?.nom != nom
        || authViewModel.currentuser?.email != email
        || authViewModel.currentuser?.nbParticipation != nbParticipation
        || authViewModel.currentuser?.hebergement != selectedHebergement.rawValue)
    }
}




struct UpdateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateProfileView()
    }
}
