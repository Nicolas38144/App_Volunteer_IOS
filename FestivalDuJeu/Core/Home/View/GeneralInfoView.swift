//
//  GeneralInfoView.swift
//  FestivalDuJeu
//
//  Created by etud on 19/03/2024.
//

import SwiftUI

struct GeneralInfoView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @EnvironmentObject private var authviewModel: AuthViewModel
    
    var body: some View {
        Section {
            VStack {
                HStack {
                    Text("Nombre de bénévoles :")
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .padding(.leading)
                    Spacer()
                    Text("\(authviewModel.nbUsers)")
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing)
                }
                .padding(.vertical, 20)
                
                HStack {
                    Text("Nombre de jeux prévus :")
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .padding(.leading)
                    Spacer()
                    Text("\(viewModel.nbGames)")
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing)
                }
                .padding(.vertical, 20)
                
                HStack {
                    Text("Nombre de jeux reçus :")
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .padding(.leading)
                    Spacer()
                    Text("\(viewModel.jeuxRecus)")
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing)
                }
                .padding(.vertical, 20)
                
                HStack {
                    Text("Nombre de jeux non reçus :")
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .padding(.leading)
                    Spacer()
                    Text("\(viewModel.jeuxNonRecus)")
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing)
                }
                .padding(.vertical, 20)
                
                HStack {
                    Text("Nombre d'éditeurs de jeux :")
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .padding(.leading)
                    Spacer()
                    Text("\(viewModel.nbEditors)")
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing)
                }
                .padding(.vertical, 20)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
        .padding(.horizontal)
        .padding(.bottom, 10)
                
        Section {
            VStack {
                Text("Pour plus d'informations :")
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                        
                Button(action: {
                    if let url = URL(string: "https://www.festivaldujeu-montpellier.org/") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("https://www.festivaldujeu-montpellier.org/")
                        .foregroundColor(.blue)
                        .underline()
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}

struct GeneralInfoView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralInfoView()
            .environmentObject(HomeViewModel())
    }
}
