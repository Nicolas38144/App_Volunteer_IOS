//
//  Message.swift
//  FestivalDuJeu
//
//  Created by etud on 19/03/2024.
//

import Foundation

struct Message: Identifiable, Codable {
    let id: String
    let prenom: String
    let nom: String
    let text: String
    let timestamp: Date
    let userId: String
}
