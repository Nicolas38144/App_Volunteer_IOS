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
    @Published var updatedMessages = [Message]()
    
    init() {
        listenToChangesInDatabase()
    }
    
    func fetchAllMessages() async throws -> [Message] {
        let snapshot = try await db.collection("messages").order(by: "timestamp", descending: true).limit(to: 25).getDocuments()
        let docs = snapshot.documents
        
        var messages = [Message]()
        for doc in docs {
            let data = doc.data()
            let text = data["text"] as? String ?? "error with text"
            let nom = data["nom"] as? String ?? "error with name"
            let prenom = data["prenom"] as? String ?? "error with name"
            let timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
            let id = data["id"] as? String ?? "error with id"
            let userId = data["userId"] as? String ?? "error with userId"
            let msg = Message(id: id, prenom: prenom, nom: nom, text: text, timestamp: timestamp.dateValue(), userId: userId)
            messages.append(msg)
        }
        listenToChangesInDatabase()
        return messages.reversed()
    }

   

    func sendMessageToDatebase(message: Message) {
        let msgData = [
            "text": message.text,
            "nom": message.nom,
            "prenom": message.prenom,
            "timestamp": Timestamp(date: message.timestamp),
            "userId": message.userId
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
                let id = data["id"] as? String ?? "error with id"
                let text = data["text"] as? String ?? "error with text"
                let nom = data["nom"] as? String ?? "error with name"
                let prenom = data["prenom"] as? String ?? "error with name"
                let timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
                let userId = data["userId"] as? String ?? "error with userId"
                
                let msg = Message(id: id, prenom: prenom, nom: nom, text: text, timestamp: timestamp.dateValue(), userId: userId)
                messages.append(msg)
            }
            
            print(strongSelf)
            //strongSelf.updatedMessagesPublisher.send(messages.reversed())
        }
        
    }
}
