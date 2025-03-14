//
//  ScoreboardOptionsSheet.swift
//  UpNorthMolkky
//
//  Created by Anthony LiFonti on 9/18/23.
//

import SwiftUI

struct ScoreboardOptionsSheet: View {
    @Binding var round: MolkkyRound
    @Binding var isPresentingOptionsView: Bool
    
    var body: some View {
        NavigationStack {
            ScoreboardOptionsView(round: $round, isPresentingOptionsView: $isPresentingOptionsView)
                .navigationTitle("Options")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            isPresentingOptionsView = false
                        }
                    }
                }
        }
    }
}

struct ScoreboardOptionsView: View {
    @EnvironmentObject var navigationState: NavigationState
    @Binding var round: MolkkyRound
    @Binding var isPresentingOptionsView: Bool
    
    var body: some View {
        VStack {
            VStack {
                Divider()
                Button(action: {
                    isPresentingOptionsView = false
                    navigationState.isNavigationActive = false
                }) {
                    Label("Return to menu", systemImage: "house")
                }
                .padding()
                Divider()
                Button(action: {
                    isPresentingOptionsView = false
                    round.endedEarly.toggle()
                }) {
                    Label("End round early", systemImage: "flag.checkered")
                        .padding()
                }
                Divider()
                NavigationLink(destination: RulesView()) {
                    Label("Rules Review", systemImage: "book")
                        .padding()
                }
                Divider()
                NavigationLink(destination: CurrentGameRulesView(round: round)) {
                    Label("View Customized Rules", systemImage: "gearshape")
                        .padding()
                }
                Divider()
            }
            Spacer()
        }
    }
}


//struct ScoreboardOptionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScoreboardOptionsView(isPresentingOptionsView: .constant(true), round: .constant(MolkkyRound.sampleData), )
//    }
//}
