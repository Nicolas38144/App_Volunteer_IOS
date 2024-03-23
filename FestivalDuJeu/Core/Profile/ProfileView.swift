//
//  ChatView.swift
//  FestivalDuJeu
//
//  Created by etud on 11/03/2024.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    private var user: User? {
        authViewModel.currentuser
    }
    
    var body: some View {
        if let user = user {
            NavigationStack {
                List {
                    Section {
                        HStack {
                            Text(user.initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 72, height: 72)
                                .background(Color(.systemGray3))
                                .clipShape(Circle())
                                
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.prenom +  " " + user.nom)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .accentColor(.gray)
                                
                                Text(user.email)
                                    .font(.footnote)
                                    .accentColor(.gray)
                            }
                        }
                    }
                
                    Section("Général") {
                        VStack {
                            HStack {
                                Text("Nombre de participation")
                                    .foregroundColor(.black)
                                Spacer()
                                Text(String(user.nbParticipation))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Divider()
                            HStack {
                                Text("Hebergement")
                                    .foregroundColor(.black)
                                Spacer()
                                Text(user.hebergement)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                        
                    Section("Compte") {
                        NavigationLink {
                            UpdateProfileView()
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            SettingsRowView(
                                imageName: "gear",
                                title: "Modifier",
                                tintColor: Color(.black)
                            )
                        }
                        
                        Button {
                            authViewModel.signOut()
                        } label: {
                            SettingsRowView(
                                imageName: "arrow.left.circle.fill",
                                title: "Se déconnecter",
                                tintColor: .red
                            )
                        }
                    }
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthViewModel())
    }
}
