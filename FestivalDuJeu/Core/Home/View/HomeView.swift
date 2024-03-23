//
//  ChatView.swift
//  FestivalDuJeu
//
//  Created by etud on 11/03/2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State private var menu: Int = 0
    
    var body: some View {
        Group {
            if homeViewModel.games.isEmpty && homeViewModel.users.isEmpty {
                ProgressView("Chargement en cours...")
            }
            else {
                VStack {
                    List {
                        Section {
                            VStack {
                                Picker("Menu", selection: $menu) {
                                    Text("Général").tag(0)
                                    Text("Jeux").tag(1)
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                        }
                        
                        if menu == 1 {
                            GamesInfoView()
                                .environmentObject(homeViewModel)
                        }
                        else {
                            GeneralInfoView()
                                .environmentObject(homeViewModel)
                        }
                    }
                    .listStyle(.automatic)
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
