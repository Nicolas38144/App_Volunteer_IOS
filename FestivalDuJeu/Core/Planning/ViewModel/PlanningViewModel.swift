//
//  RegisterPlanningViewModel.swift
//  FestivalDuJeu
//
//  Created by etud on 22/03/2024.
//

import Foundation
import Firebase

class PlanningViewModel: ObservableObject {
    @Published var postes: [Poste] = []
    @Published var plages: [Plage_horaire] = []
    @Published var affectations: [Affecter_poste] = []
    @Published var jours: [String] = []
    
    @Published var affectationsPersoParJour: [Affecter_poste] = []
    @Published var affectationsParHeureParPoste: [Affecter_poste] = []
    
    private var week = ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche"]
    
    private var db = Firestore.firestore()
    
    
    func fetchJours() {
        let plages = self.plages
        var joursSet = Set<String>()
        for p in plages {
            joursSet.insert(p.jour)
        }
        let sortedJours = week.filter { joursSet.contains($0) }
        self.jours = sortedJours
    }
    
    
    func fetchPlages() async {
        do {
            let querySnapshot = try await db.collection("plage_horaire").getDocuments()
            let plages = querySnapshot.documents.compactMap { document in
                
                do {
                    let plage = try document.data(as: Plage_horaire.self)
                    return plage
                } catch {
                    print("Erreur lors de la conversion de la plage horaire: \(error.localizedDescription)")
                    return nil
                }
            }
            DispatchQueue.main.async {
                self.plages = plages
            }
        } catch {
            print("Erreur lors de la récupération des plages horaire: \(error.localizedDescription)")
        }
    }
    
    
    func fetchAffectations() async {
        do {
            let querySnapshot = try await db.collection("affecter_poste").getDocuments()
            let affectations = querySnapshot.documents.compactMap { document in
                do {
                    let affectation = try document.data(as: Affecter_poste.self)
                    return affectation
                } catch {
                    print("Erreur lors de la conversion de l'affectation poste: \(error.localizedDescription)")
                    return nil
                }
            }
            DispatchQueue.main.async {
                self.affectations = affectations
            }
        } catch {
            print("Erreur lors de la récupération des affectations poste: \(error.localizedDescription)")
        }
    }
    
    
    func fetchPostes() async {
        do {
            let querySnapshot = try await db.collection("postes").getDocuments()
            let postes = querySnapshot.documents.compactMap { document in
                do {
                    let poste = try document.data(as: Poste.self)
                    return poste
                } catch {
                    print("Erreur lors de la conversion du poste: \(error.localizedDescription)")
                    return nil
                }
            }
            DispatchQueue.main.async {
                self.postes = postes
            }
        } catch {
            print("Erreur lors de la récupération des postes: \(error.localizedDescription)")
        }
    }
    
    
    func setAffectationsPersoParJour(jour: String, id_user: String) {
        let affectations = self.affectations
        let plages = self.plages
        var tabaffects: [Affecter_poste] = []
        for a in affectations {
            for p in plages {
                if ((p.jour == jour) && (a.id_plage == p.id) && (a.id_user == id_user)) {
                    tabaffects.append(a)
                }
            }
        }
        self.affectationsPersoParJour = tabaffects
    }
    
    /*
    func setAffectationsParHeureParPoste(creneau: String, poste: String) {
        let affectations = self.affectations
        let plages = self.plages
        var tabaffects: [Affecter_poste] = []
        for a in affectations {
            for p in plages {
                if (p.horaire == creneau && a.id_plage==p.id && a.poste==poste) {
                    tabaffects.append(a)
                }
            }
        }
        self.affectationsParHeureParPoste = tabaffects
    }
     */
    
    
    func getAffectationsPersoParHeure(creneau: String) -> String {
        let affectations = self.affectationsPersoParJour
        let plages = self.plages
        var poste = ""
        for a in affectations {
            for p in plages {
                if ((p.horaire == creneau) && (a.id_plage == p.id)) {
                    if poste == "" {
                        poste = a.poste
                    }
                    else {
                        poste += (" | " + a.poste)
                    }
                    
                }
            }
        }
        return poste
    }
}

