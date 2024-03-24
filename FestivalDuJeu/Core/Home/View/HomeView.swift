//
//  ChatView.swift
//  FestivalDuJeu
//
//  Created by etud on 11/03/2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var menu: Int = 0
    
    var body: some View {
        Group {
            if homeViewModel.games.isEmpty && authViewModel.users.isEmpty {
                ProgressView("Chargement en cours...")
            }
            else {
                VStack {
                    Text("Accueil")
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .padding(.leading)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    
                    Picker("Menu", selection: $menu) {
                        Text("Général").tag(0)
                        Text("Jeux").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                
                    VStack {
                        if menu == 1 {
                            GamesInfoView()
                                .environmentObject(homeViewModel)
                        }
                        else {
                            GeneralInfoView()
                                .environmentObject(homeViewModel)
                                .environmentObject(authViewModel)
                        }
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
