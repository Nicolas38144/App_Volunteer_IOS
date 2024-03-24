//
//  AuthViewModel.swift
//  FestivalDuJeu
//
//  Created by etud on 13/03/2024.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


protocol AuthFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentuser: User?
    @Published var users: [User] = []
    
    private var db = Firestore.firestore()
    
    var nbUsers: Int {
        users.count
    }
    
    init() {
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        }
        catch {
            print("DEBUG: failed to log in user with error \(error.localizedDescription)")
        }
    }
    
    
    func createUser(withEmail email: String, password: String, prenom: String, nom: String, nbParticipation: Int, hebergement: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, prenom: prenom, nom: nom, email: email, nbParticipation: nbParticipation, hebergement: hebergement)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await db.collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
            print("User created")
        }
        catch {
            print("DEBUG: failed to create user with error \(error.localizedDescription)")
        }
    }
    
    
    func updateUser(prenom: String, nom: String, email: String, nbParticipation: Int, hebergement: String) async throws {
        guard let uid = userSession?.uid else {
            print("DEBUG: User session not available")
            return
        }
        
        do {
            // Créez un dictionnaire avec les nouvelles informations de l'utilisateur
            let updatedUserData: [String: Any] = [
                "prenom": prenom,
                "nom": nom,
                "email": email,
                "nbParticipation": nbParticipation,
                "hebergement": hebergement
            ]
            
            // Mettez à jour les données de l'utilisateur dans Firestore
            try await db.collection("users").document(uid).setData(updatedUserData, merge: true)
            await fetchUser()
            print("User updated successfully")
        } catch {
            print("DEBUG: Failed to update user with error : \(error.localizedDescription)")
        }
    }

    
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentuser = nil
        }
        catch {
            print("DEBUG: failed to sign out user with error \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await db.collection("users").document(uid).getDocument() else { return }
        self.currentuser = try? snapshot.data(as: User.self)
        //print("DEBUG: current user is \(self.currentuser)")
    }
    
    
    func fetchUsers() async {
        do {
            let querySnapshot = try await db.collection("users").getDocuments()
            let users = querySnapshot.documents.compactMap { document in
                do {
                    let user = try document.data(as: User.self)
                    return user
                } catch {
                    print("Erreur lors de la conversion du l'utilisateur : \(error.localizedDescription)")
                    return nil
                }
            }
            DispatchQueue.main.async {
                self.users = users
            }
        } catch {
            print("Erreur lors de la récupération des utilisateurs: \(error.localizedDescription)")
        }
    }
    
    
    func getUid() -> String {
        guard let uid = Auth.auth().currentUser?.uid else { return "" }
        return uid
    }
    
    func getUserByID(id: String) -> User? {
        var user: User? = nil
        let users = self.users
        for u in users {
            if (u.id==id){ user = u }
        }
        return user
    }
}
