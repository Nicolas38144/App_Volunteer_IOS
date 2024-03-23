//
//  FestivalDuJeuApp.swift
//  FestivalDuJeu
//
//  Created by etud on 11/03/2024.
//

import SwiftUI
import Firebase
import UIKit

@main
struct FestivalDuJeuApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var planningViewModel = PlanningViewModel()
    @StateObject var homeViewModel = HomeViewModel()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(planningViewModel)
                .environmentObject(homeViewModel)
                .onAppear {
                    Task {
                        //await homeViewModel.fetchGames()
                        await homeViewModel.fetchUsers()
                        
                        await planningViewModel.fetchPlages()
                        await planningViewModel.fetchPostes()
                        await planningViewModel.fetchAffectations()
                        planningViewModel.fetchJours()
                    }
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("Logged to Firebase")
        return true
    }
}
