//
//  Poste.swift
//  FestivalDuJeu
//
//  Created by etud on 22/03/2024.
//

import Foundation

struct Poste: Codable, Identifiable {
    let id = UUID()
    var intitule: String
    var capacite: String
    var desc : String
    var referent : String
}
