//
//  PeopleDirectoryView.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 10/15/24.
//
import SwiftUI

struct PeopleDirectoryView: View {
    @State private var people: [CommunityMember] = []
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List(filteredPeople) { person in
                NavigationLink(destination: MemberDetailView(member: person)) {
                    VStack(alignment: .leading) {
                        Text(person.name)
                            .font(.headline)
                        Text(person.category)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("People Directory")
            .onAppear {
                loadPeople()
            }
            .searchable(text: $searchText, prompt: "Search People")
        }
    }
    
    private var filteredPeople: [CommunityMember] {
        if searchText.isEmpty {
            return people
        } else {
            return people.filter { $0.name.contains(searchText) || $0.category.contains(searchText) }
        }
    }
    
    private func loadPeople() {
        let dataLoader = DataLoader()
        dataLoader.loadPeopleData { loadedPeople in
            if let loadedPeople = loadedPeople {
                self.people = loadedPeople
            }
        }
    }
}
