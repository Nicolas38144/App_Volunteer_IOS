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
                        LazyVStack(spacing: 0) {
                            ForEach(chatViewModel.listMessages.indices, id: \.self) { index in
                                let message = chatViewModel.listMessages[index]
                                let bubbleColor = message.userId == authViewModel.getUid() ? Color.blue : Color.gray.opacity(0.5)
                                VStack(alignment: .leading) {
                                    if message.userId != authViewModel.getUid() {
                                        Text("\(message.prenom) \(message.nom)")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .padding(.horizontal)
                                            .padding([.top], 12)
                                        HStack {
                                            Text(message.text)
                                                .padding()
                                                .foregroundColor(message.userId == authViewModel.getUid() ? .white : .primary)
                                                .background(bubbleColor)
                                                .clipShape(ChatBubble(isFromCurrentUser: message.userId == authViewModel.getUid()))
                                                .padding([.bottom], 12)
                                            Spacer()
                                            
                                        }
                                    }
                                    else {
                                        HStack {
                                            Spacer()
                                            Text(message.text)
                                                .padding()
                                                .foregroundColor(message.userId == authViewModel.getUid() ? .white : .primary)
                                                .background(bubbleColor)
                                                .clipShape(ChatBubble(isFromCurrentUser: message.userId == authViewModel.getUid()))
                                                .padding([.bottom], 12)
                                        }
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
