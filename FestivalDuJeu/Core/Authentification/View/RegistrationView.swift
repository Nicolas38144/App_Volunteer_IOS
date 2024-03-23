//
//  RegistrationView.swift
//  FestivalDuJeu
//
//  Created by etud on 13/03/2024.
//

import SwiftUI

struct RegistrationView: View {
    enum Hebergement: String, CaseIterable, Identifiable {
        case Rien, Propose, Recherche
        var id: Self { self }
    }
    
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var prenom = ""
    @State private var nom = ""
    @State private var email = ""
    @State private var nbParticipation = 0
    @State private var selectedHebergement: Hebergement = .Rien
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismss
    
    
    func incrementStep() {
        nbParticipation += 1
    }
    func decrementStep() {
        nbParticipation -= 1
        if nbParticipation < 0 {
            nbParticipation = 0
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                //logo
                Image("logo2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 180)
                    .padding(.vertical, 32)
                
                //form fields
                VStack(spacing: 24) {
                    InputView(
                        text: $prenom,
                        title: "Prénom",
                        placeholder: "Entrez vorte prénom"
                    )
                    
                    InputView(
                        text: $nom,
                        title: "Nom",
                        placeholder: "Entrez vorte nom"
                    )
                    
                    InputView(
                        text: $email,
                        title: "Mail",
                        placeholder: "Entrez vorte adresse mail"
                    ).autocapitalization(.none)
                    
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
                    }
                    
                    
                    InputView(
                        text: $password,
                        title: "Mot de passe",
                        placeholder: "Entrez vorte mot de passe",
                        isSecureField: true
                    )
                    ZStack(alignment: .trailing) {
                        InputView(
                            text: $confirmPassword,
                            title: "Confirmer le mot de passe",
                            placeholder: "Entrez vorte mot de passe",
                            isSecureField: true
                        )
                        if !password.isEmpty && !confirmPassword.isEmpty {
                            if password == confirmPassword {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemGreen))
                            }
                            else {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemRed))
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                Button {
                    Task{
                        try await authViewModel.createUser(
                            withEmail: email,
                            password: password,
                            prenom: prenom,
                            nom: nom,
                            nbParticipation: nbParticipation,
                            hebergement: selectedHebergement.rawValue
                        )
                    }
                } label: {
                    HStack {
                        Text("S'INSCRIRE")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemBlue))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5 )
                .cornerRadius(10)
                .padding(.top, 24)
                
                Spacer()
                
                Button {
                    dismss()
                } label: {
                    HStack(spacing: 3) {
                        Text("Vous avez déjà un compte?")
                        Text("Connectez-vous")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            }
        }
    }
}

extension RegistrationView: AuthFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
        && !prenom.isEmpty
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
