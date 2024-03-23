//
//  User.swift
//  FestivalDuJeu
//
//  Created by etud on 13/03/2024.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let prenom: String
    let nom: String
    let email: String
    let nbParticipation: Int
    let hebergement: String
    
    var initials: String {
        return prenom.prefix(1).capitalized + " " + nom.prefix(1).capitalized
    }
}

extension User {
    static var MOCK_USER = User(
        id: NSUUID().uuidString,
        prenom: "Nicolas",
        nom: "Germani",
        email: "test@exemple.com",
        nbParticipation: 0,
        hebergement: "Rien"
    )
}
