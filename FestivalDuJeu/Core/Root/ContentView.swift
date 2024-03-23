//
//  ContentView.swift
//  FestivalDuJeu
//
//  Created by etud on 11/03/2024.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
        
    var body: some View {
        
        Group {
            if authViewModel.userSession != nil {
                NavbarView(selection: .home)
            }
            else {
                LogInView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
