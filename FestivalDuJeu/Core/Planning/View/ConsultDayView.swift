import SwiftUI

struct ConsultDayView: View {
    @Binding var jour: String
    @EnvironmentObject private var planningViewModel: PlanningViewModel
    
    let horaires = ["9h-11h", "11h-14h", "14h-17h", "17h-20h", "20h-22h"]
    
    var body: some View {
        ScrollView {
            Spacer()
            VStack {
                ForEach(0..<horaires.count, id: \.self) { index in
                    HStack {
                        Text(self.horaires[index])
                        Spacer()
                        Text(planningViewModel.getAffectationsPersoParHeure(creneau: self.horaires[index]))
                    }
                    Divider()
                }
            }
            .navigationTitle(jour)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 3)
            .padding(.horizontal)
            .padding(.bottom, 10)
            
            VStack {
                ForEach(0..<planningViewModel.postes.count, id: \.self) { indexP in
                    VStack {
                        Text(planningViewModel.postes[indexP].intitule)
                            .fontWeight(.bold)
                            .font(.title3)
                        Text(planningViewModel.postes[indexP].desc)
                            .foregroundStyle(Color(.systemGray))
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
        }
    }
}

struct ConsultDayView_Previews: PreviewProvider {
    static var previews: some View {
        ConsultDayView(jour: .constant("Jour 1"))
    }
}
