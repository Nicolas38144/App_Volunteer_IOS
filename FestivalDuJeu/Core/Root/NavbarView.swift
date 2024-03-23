//
//  NavbarView.swift
//  guise-tival-ios-app
//
//  Created by etud on 12/03/2024.
//

import SwiftUI

struct NavbarView: View {
    @State private var selection: Nav = .home

    enum Nav {
        case home
        case profil
        case register
        case chat
        case planning
    }
    
    init(selection: Nav) {
        self.selection = selection
    }
    
    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Accueil")
                }
                .tag(Nav.home)
            
            ConsultPlanningView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Planning")
                }
                .tag(Nav.planning)
                
            RegistrationPlanningView()
                .tabItem {
                    Image(systemName: "list.bullet.circle.fill")
                    Text("S'inscrire")
                }
                .tag(Nav.register)
            
            ChatView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Messagerie")
                }
                .tag(Nav.chat)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profil")
                }
                .tag(Nav.profil)
        }
    }
}
