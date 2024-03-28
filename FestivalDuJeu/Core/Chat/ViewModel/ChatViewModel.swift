//
//  ChatViewModel.swift
//  FestivalDuJeu
//
//  Created by etud on 19/03/2024.
//

import Foundation
import Firebase

class ChatViewModel: ObservableObject {
    
    private var db = Firestore.firestore()
    @Published var listMessages = [Message]()
    
    init() {
        listenToChangesInDatabase()
    }
    
    func fetchAllMessages() async {
        do {
            let snapshot = try await db.collection("messages").order(by: "timestamp", descending: true).limit(to: 25).getDocuments()
            let docs = snapshot.documents
            
            var messages = [Message]()
            for doc in docs {
                let data = doc.data()
                let text = data["text"] as? String ?? "error with text"
                let nom = data["nom"] as? String ?? "error with name"
                let prenom = data["prenom"] as? String ?? "error with name"
                let timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
                let userId = data["userId"] as? String ?? "error with userId"
                let msg = Message(prenom: prenom, nom: nom, text: text, timestamp: timestamp.dateValue(), userId: userId)
                messages.append(msg)
            }
            listenToChangesInDatabase()
            self.listMessages = messages.reversed()
        }
        catch {
            print("Erreur lors de la récupération des messages: \(error.localizedDescription)")
        }
    }

   

    func sendMessageToDatebase(text: String, nom: String, prenom: String, timestamp: Date, userId: String) {
        let msgData = [
            "text": text,
            "nom": nom,
            "prenom": prenom,
            "timestamp": Timestamp(date: timestamp),
            "userId": userId
        ] as [String : Any]
        db.collection("messages").addDocument(data: msgData)
    }

    
    func listenToChangesInDatabase() {
        db.collection("messages").order(by: "timestamp", descending: true).limit(to: 25).addSnapshotListener { [weak self] querySnapshot, error in
            guard let documents = querySnapshot?.documents, error == nil, let strongSelf = self else {
                return
            }
            var messages = [Message]()
            for doc in documents {
                let data = doc.data()
                let text = data["text"] as? String ?? "error with text"
                let nom = data["nom"] as? String ?? "error with name"
                let prenom = data["prenom"] as? String ?? "error with name"
                let timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
                let userId = data["userId"] as? String ?? "error with userId"
                let msg = Message(prenom: prenom, nom: nom, text: text, timestamp: timestamp.dateValue(), userId: userId)
                messages.append(msg)
            }
            strongSelf.listMessages = messages.reversed()
        }
    }
}
