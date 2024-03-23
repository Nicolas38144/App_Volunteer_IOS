//
//  LogInView.swift
//  FestivalDuJeu
//
//  Created by etud on 13/03/2024.
//

import SwiftUI

struct LogInView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject private var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
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
                        text: $email,
                        title: "Mail",
                        placeholder: "Entrez vorte adresse mail"
                    )
                    .autocapitalization(.none)
                    
                    InputView(
                        text: $password,
                        title: "Mot de passe",
                        placeholder: "Entrez vorte mot de passe",
                        isSecureField: true
                    )
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                
                //SignIn button
                Button {
                    Task {
                        try await viewModel.signIn(
                            withEmail: email,
                            password: password
                        )
                    }
                    
                } label: {
                    HStack {
                        Text("SE CONNECTER")
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
                
                
                //SignUp button
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("Vous n'avez pas de compte?")
                        Text("S'inscrire")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            }
        }
    }
}

extension LogInView: AuthFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
