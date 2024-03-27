//
//  ChatView.swift
//  FestivalDuJeu
//
//  Created by etud on 11/03/2024.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject private var chatViewModel: ChatViewModel
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var newMsg = ""
    @State private var scrollToBottom = false
    
    var body: some View {
        VStack {
            Text("Chat général")
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .padding(.leading)
                .font(.title)
                .fontWeight(.bold)
            NavigationView {
                VStack {
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(chatViewModel.listdMessages.indices, id: \.self) { index in
                                let message = chatViewModel.listdMessages[index]
                                // Determine la couleur de fond de la bulle de message en fonction de l'utilisateur
                                let bubbleColor = message.userId == authViewModel.getUid() ? Color.blue : Color.gray.opacity(0.5)
                                HStack {
                                    if message.userId != authViewModel.getUid() {
                                        Text(message.prenom.prefix(1) + message.nom.prefix(1))
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .frame(width: 40, height: 40)
                                            .background(Color.blue)
                                            .clipShape(Circle())
                                    }
                                    else {
                                        Spacer()
                                    }
                                    Text(message.text)
                                        .padding()
                                        .foregroundColor(message.userId == authViewModel.getUid() ? .white : .primary)
                                        .background(bubbleColor)
                                        .clipShape(ChatBubble(isFromCurrentUser: message.userId == authViewModel.getUid()))
                                        .padding(10)
                                    if message.userId == authViewModel.getUid() {
                                        Text(message.prenom.prefix(1) + message.nom.prefix(1))
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .frame(width: 40, height: 40)
                                            .background(Color.blue)
                                            .clipShape(Circle())
                                    }
                                    else {
                                        Spacer()
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    HStack {
                        TextField("Message", text: $newMsg)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: {
                            chatViewModel.sendMessageToDatebase(
                                text: self.newMsg,
                                nom: authViewModel.currentuser?.nom ?? "",
                                prenom: authViewModel.currentuser?.prenom ?? "",
                                timestamp: Date.now,
                                userId: authViewModel.getUid()
                            )
                            self.newMsg = ""
                        }) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.accentColor)
                        }
                    }
                    .padding()
                }
            }
            .onAppear {
                chatViewModel.listenToChangesInDatabase()
            }
        }
    }
}


struct ChatBubble: Shape {
    let isFromCurrentUser: Bool
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 12)
        return Path(path.cgPath)
    }
}
