//
//  HomeViewModel.swift
//  FestivalDuJeu
//
//  Created by etud on 19/03/2024.
//

import Foundation
import Firebase

class HomeViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var users: [User] = []
    
    private var db = Firestore.firestore()
    
    // Récupérer le nombre total de jeux
    var nbGames: Int {
        games.count
    }
    
    // Récupérer le nombre de jeux recus
    var jeuxRecus: Int {
        games.filter { $0.Recu == "oui" }.count
    }
    
    // Récupérer le nombre de jeux non recus
    var jeuxNonRecus: Int {
        games.filter { $0.Recu != "oui" }.count
    }
    
    // Récupérer le nombre d'éditeurs différents
    var nbEditors: Int {
        Set(games.map { $0.Editeur }).count
    }
    
    var nbUsers: Int {
        users.count
    }
    
    func fetchGames() async {
        do {
            let querySnapshot = try await db.collection("games").getDocuments()
            let games = querySnapshot.documents.compactMap { document in
                do {
                    let game = try document.data(as: Game.self)
                    return game
                } catch {
                    print("Erreur lors de la conversion du jeu: \(error.localizedDescription)")
                    return nil
                }
            }
            DispatchQueue.main.async {
                self.games = games
            }
        } catch {
            print("Erreur lors de la récupération des jeux: \(error.localizedDescription)")
        }
    }

    
    func fetchUsers() async {
        do {
            let querySnapshot = try await db.collection("users").getDocuments()
            let users = querySnapshot.documents.compactMap { document in
                do {
                    let user = try document.data(as: User.self)
                    return user
                } catch {
                    print("Erreur lors de la conversion du jeu: \(error.localizedDescription)")
                    return nil
                }
            }
            DispatchQueue.main.async {
                self.users = users
            }
        } catch {
            print("Erreur lors de la récupération des jeux: \(error.localizedDescription)")
        }
    }
}
