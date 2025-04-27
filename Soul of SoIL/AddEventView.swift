//
//  AddEventView.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 2/9/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AddEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String = ""
    @State private var date: Date = Date()
    @State private var location: String = ""
    @State private var town: String = ""
    @State private var description: String = ""
    @State private var isSaving = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Title", text: $title)
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    TextField("Location", text: $location)
                    TextField("Town", text: $town)
                    TextField("Description", text: $description)
                }

                Section {
                    Button(action: {
                        guard let user = Auth.auth().currentUser else {
                            print("Error: No user logged in")
                            return
                        }
                        
                        isSaving = true
                        saveEvent(title: title, location: location, town: town, description: description, date: date, createdBy: user.email ?? "Unknown Email") { success in
                            isSaving = false
                            if success {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }) {
                        HStack {
                            if isSaving {
                                ProgressView()
                            }
                            Text("Save Event")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(title.isEmpty || location.isEmpty || town.isEmpty || description.isEmpty)
                }
            }
            .navigationTitle("Add New Event")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    func saveEvent(title: String, location: String, town: String, description: String, date: Date, createdBy: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()

        guard let user = Auth.auth().currentUser else {
            print("Error: No user logged in")
            return
        }

        let newEvent: [String: Any] = [
            "title": title,
            "location": location,
            "town": town,
            "description": description,
            "date": Timestamp(date: date),
            "createdBy": user.email ?? "Unknown Email",
            "ownerId": user.uid
        ]

        db.collection("events").addDocument(data: newEvent) { error in
            if let error = error {
                print("Error adding event: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Event added successfully!")
                completion(true)
            }
        }
    }
}
