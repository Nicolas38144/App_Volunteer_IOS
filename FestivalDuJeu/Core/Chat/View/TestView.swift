//
//  TestView.swift
//  FestivalDuJeu
//
//  Created by etud on 24/03/2024.
//

import SwiftUI

struct TestView: View {
    @StateObject var viewModel = ChatViewModel()
    @State private var newMessageText = ""
    @State private var scrollToBottom = false // Ajouter un état pour le défilement automatique
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.messages) { message in
                        MessageView(message: message)
                    }
                }
                .onChange(of: viewModel.messages) { _ in
                    scrollToBottom = true // Faire défiler vers le bas lorsque de nouveaux messages sont ajoutés
                }
            }
            .padding(.horizontal)
            .onAppear {
                scrollToBottom = true // Faire défiler vers le bas au chargement initial de la vue
            }
            
            HStack {
                TextField("Votre message", text: $newMessageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Envoyer") {
                    sendMessage()
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .onChange(of: scrollToBottom) { _ in
            if scrollToBottom {
                // Faire défiler vers le bas
                ScrollViewReader { proxy in
                    withAnimation {
                        proxy.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchAllMessages() // Charger les messages lorsque la vue apparaît
        }
    }
    
    // Autres fonctions de la vue...
}
#Preview {
    TestView()
}
