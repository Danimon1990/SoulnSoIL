//
//  AddPersonView.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 2/20/25.
//

import SwiftUI
import FirebaseFirestore

struct AddPersonView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var category = ""
    @State private var phoneNumber = ""
    @State private var website = ""
    @State private var bio = ""
    @State private var avatar = ""
    @State private var location = ""
    @State private var offers: [Offer] = []

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Category", text: $category)
                }
                Section(header: Text("Contact")) {
                    TextField("Phone Number", text: $phoneNumber)
                    TextField("Website", text: $website)
                }
                Section(header: Text("Additional Info")) {
                    TextField("Location", text: $location)
                    TextField("Bio", text: $bio)
                }
                Button("Save") {
                    savePerson()
                }
            }
            .navigationTitle("Add New Person")
        }
    }

    private func savePerson() {
        let db = Firestore.firestore()
        let newPerson: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "category": category,
            "phoneNumber": phoneNumber,
            "website": website,
            "bio": bio,
            "avatar": avatar,
            "location": location,
            "offers": offers.map { [
                "id": $0.id,
                "title": $0.title,
                "type": $0.type,
                "description": $0.description,
                "contact": $0.contact
            ]},
            "isInDirectory": true
        ]

        db.collection("users").addDocument(data: newPerson) { error in
            if let error = error {
                print("Error adding person: \(error.localizedDescription)")
            } else {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
