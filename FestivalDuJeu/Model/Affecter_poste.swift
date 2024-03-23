//
//  Affecter_poste.swift
//  FestivalDuJeu
//
//  Created by etud on 22/03/2024.
//

import Foundation

struct Affecter_poste: Codable, Identifiable {
    let id = UUID()
    var id_plage: String
    var id_user: String
    var poste : String
}
