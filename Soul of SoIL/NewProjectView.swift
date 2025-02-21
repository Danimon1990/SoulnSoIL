//
//  NewProjectView.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 2/20/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct NewProjectView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var email = ""
    @State private var description = ""
    @State private var phoneNumber = ""
    @State private var website = ""
    @State private var avatarURL = ""
    @State private var location = ""
    @State private var category = ""
    @State private var offerings: [Offer] = []
    @State private var peopleRelated: [String] = []
    
    @State private var isLoading = false
    
    let db = Firestore.firestore()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Project Details")) {
                    TextField("Project Name", text: $name)
                    TextField("Email", text: $email)
                    TextEditor(text: $description).frame(height: 80)
                    TextField("Phone Number", text: $phoneNumber)
                    TextField("Website", text: $website)
                    TextField("Avatar URL", text: $avatarURL)
                    TextField("Location", text: $location)
                    TextField("Category", text: $category)
                }
                
                // Offerings Section
                Section(header: Text("Offerings")) {
                    ForEach(offerings.indices, id: \.self) { index in
                        VStack(alignment: .leading) {
                            TextField("Title", text: $offerings[index].title)
                            TextField("Type", text: $offerings[index].type)
                            TextEditor(text: $offerings[index].description)
                                .frame(height: 40)
                        }
                    }
                    
                    Button(action: addOffer) {
                        Label("Add New Offer", systemImage: "plus")
                    }
                }
                
                // Save Button
                Section {
                    Button(action: saveProject) {
                        HStack {
                            Spacer()
                            Text("Save Project")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                            Spacer()
                        }
                    }
                    .disabled(name.isEmpty || email.isEmpty)
                }
            }
            .navigationTitle("New Project")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func addOffer() {
        let newOffer = Offer(id: UUID().uuidString, title: "", type: "Service", description: "", contact: "")
        offerings.append(newOffer)
    }
    
    private func saveProject() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let newProject: [String: Any] = [
            "name": name,
            "email": email,
            "description": description,
            "phoneNumber": phoneNumber,
            "website": website,
            "avatarURL": avatarURL,
            "location": location,
            "category": category,
            "offerings": offerings.map { [
                "id": $0.id,
                "title": $0.title,
                "type": $0.type,
                "description": $0.description,
                "contact": $0.contact ?? ""
            ]},
            "peopleRelated": peopleRelated,
            "createdBy": uid
        ]
        
        db.collection("projects").addDocument(data: newProject) { error in
            if let error = error {
                print("Error saving project: \(error.localizedDescription)")
            } else {
                print("Project successfully saved!")
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
