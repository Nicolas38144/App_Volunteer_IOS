//
//  GamesInfoView.swift
//  FestivalDuJeu
//
//  Created by etud on 19/03/2024.
//

import SwiftUI

struct GamesInfoView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State private var searchText = ""

        var filteredGames: [Game] {
            if searchText.isEmpty {
                return homeViewModel.games
            } else {
                return homeViewModel.games.filter { $0.Nom_jeu.localizedCaseInsensitiveContains(searchText) }
            }
        }
    
    var body: some View {
        VStack {
            
            SearchBarView(text: $searchText)
            
            ScrollView {
                ForEach(filteredGames, id: \.id) { game in
                    VStack(alignment: .leading) {
                        Text(game.Nom_jeu)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Editeur: \(game.Editeur.isEmpty ? "Non renseigné" : game.Editeur)")
                         .font(.subheadline)
                         .frame(maxWidth: .infinity, alignment: .leading)
                         Text("Nombre de joueurs: \(game.Nb_joueurs.isEmpty ? "Non renseigné" : game.Nb_joueurs)")
                         .font(.subheadline)
                         .frame(maxWidth: .infinity, alignment: .leading)
                         Text("Durée: \(game.Duree.isEmpty ? "Non renseignée" : game.Duree)")
                         .font(.subheadline)
                         .frame(maxWidth: .infinity, alignment: .leading)
                         Text("À animer: \(game.A_animer.isEmpty ? "Non renseigné" : game.A_animer)")
                         .font(.subheadline)
                         .frame(maxWidth: .infinity, alignment: .leading)
                         Text("Age minimum: \(game.Age_min.isEmpty ? "Non renseigné" : game.Age_min)")
                         .font(.subheadline)
                         .frame(maxWidth: .infinity, alignment: .leading)
                         Text("Zone plan: \(game.Zone_plan.isEmpty ? "Non renseigné" : game.Zone_plan)")
                         .font(.subheadline)
                         .frame(maxWidth: .infinity, alignment: .leading)
                         Text("Zone bénévole: \(game.Zone_benevole.isEmpty ? "Non renseigné" : game.Zone_benevole)")
                         .font(.subheadline)
                         .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 3)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    .padding(.top, 10)
                    
                }
                .navigationTitle("Jeux")
            }
            .padding()
        }
    }
}


//#Preview {
//    GamesInfoView()
//}
