//
//  Game.swift
//  FestivalDuJeu
//
//  Created by etud on 19/03/2024.
//

import Foundation

struct Game: Codable, Identifiable {
    let id = UUID()
    var Nom_jeu: String
    var Recu: String
    var Editeur: String
    var Zone_plan: String
    var Zone_benevole: String
    var Duree: String
    var A_animer: String
    var Age_min: String
    var Nb_joueurs : String
}
