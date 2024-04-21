//
//  PlayerListView.swift
//  UpNorthMolkky
//
//  Created by Anthony LiFonti on 4/4/24.
//

import SwiftUI

struct PlayerListView: View {
    @EnvironmentObject var store: MolkkyStore
    @Binding var round: MolkkyRound
    
    @State private var newPlayerNameText = ""
    @State private var viewAddPlayerField: Bool = false
    @FocusState private var newPlayerIsFocused: Bool
    @State private var searchText = ""
    @FocusState private var searchIsFocused: Bool
    
    @State private var newPlayers: [Person] = []
    @State private var selectedPlayers = Set<UUID>()
    
//    var players: [Person] {
//        store.players + newPlayers
//    }
    
    var body: some View {
        ScrollView(showsIndicators: false, content: {
            VStack(spacing: 10, content: {
                Spacer()
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: $searchText, onEditingChanged: { isEditing in
                        // usernameFieldIsFocused = isEditing
                    }, onCommit: {
                        searchIsFocused = false
                    })
                    .foregroundColor(.primary)
                    .autocorrectionDisabled(true)
                    .focused($searchIsFocused)
                    
                    Button(action: {
                        self.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .opacity(searchText == "" ? 0 : 1)
                    }
                }
                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                .foregroundColor(.secondary)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10.0)
                //
                HStack {
                    Spacer()
                    HStack {
                        Image(systemName: "plus")
                        Text("Add new player")
                    }
                    .padding()
                    Spacer()
                }
                .background(Color(UIColor.tintColor))
                .cornerRadius(5)
                .onTapGesture {
                    viewAddPlayerField = true
                    // newPlayerIsFocused = true
                }
                //
                Divider()
                HStack {
                    Text("\(selectedPlayers.count)")
                    Image(systemName: "person.fill")
                }
                if (viewAddPlayerField) {
                    HStack {
                        TextField("Add new player", text: $newPlayerNameText)
                            .onSubmit {
                                if (newPlayerNameText != "") {
                                    // BAD
                                    let newPlayer = Person(playerName: newPlayerNameText)
                                    newPlayers.append(newPlayer)
                                    selectedPlayers.insert(newPlayer.id)
                                    round.players = newPlayers.filter{selectedPlayers.contains($0.id)}
                                        .enumerated().map{Player(id: $1.id, playerName: $1.playerName, orderKey: $0)}
                                    newPlayerNameText = ""
                                }
                                viewAddPlayerField = false
                            }
                            .submitLabel(.done)
                            .padding()
                            .focused($newPlayerIsFocused)
                            .autocorrectionDisabled()
                        Spacer()
                    }
                    .background(Color(UIColor.secondarySystemFill))
                    .cornerRadius(5)
                    .onAppear {
                        newPlayerIsFocused = true
                    }
                    .onDisappear {
                        newPlayerIsFocused = false
                    }
                }
                ForEach(newPlayers
                    .sorted(by: {selectedPlayers.contains($0.id) && !selectedPlayers.contains($1.id)})
                    .filter{$0.playerName.hasPrefix(searchText) || selectedPlayers.contains($0.id) || searchText == ""
                }, id: \.self) { person in
                    PlayerItemView(person: person, selected: selectedPlayers.contains(person.id))
                        .onTapGesture {
                            if(selectedPlayers.contains(person.id)) {
                                selectedPlayers.remove(person.id)
                            } else {
                                selectedPlayers.insert(person.id)
                            }
                            round.players = newPlayers.filter{selectedPlayers.contains($0.id)}
                                .enumerated().map{Player(id: $1.id, playerName: $1.playerName, orderKey: $0)}
                        }
                }
                //
                Spacer()
            })
            .padding(.horizontal, 20)
        })
    }
}


struct PlayerListView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerListView(round: .constant(MolkkyRound.sampleData))
            .environmentObject(MolkkyStore())
    }
}
