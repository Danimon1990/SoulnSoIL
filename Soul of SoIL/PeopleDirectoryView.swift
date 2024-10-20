//
//  PeopleDirectoryView.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 10/15/24.
//
import SwiftUI

struct PeopleDirectoryView: View {
    // Load people data using DataLoader
    let people = DataLoader().loadPeopleData()

    var body: some View {
        NavigationView {
            List(people) { person in
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
        }
    }
}
