//
//  ProfileView.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 2/20/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var age: String = ""
    @State private var introduction: String = ""
    @State private var isLoading: Bool = true

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Info")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                }

                Section(header: Text("Introduction")) {
                    TextEditor(text: $introduction)
                        .frame(height: 80)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
                }

                Section {
                    Button(action: updateProfile) {
                        Text("Save Changes")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Logout") {
                        try? Auth.auth().signOut()
                    }
                }
            }
            .onAppear(perform: fetchUserProfile)
        }
    }

    private func fetchUserProfile() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()

        db.collection("users").document(user.uid).getDocument { snapshot, error in
            if let data = snapshot?.data() {
                self.firstName = data["firstName"] as? String ?? ""
                self.lastName = data["lastName"] as? String ?? ""
                self.email = data["email"] as? String ?? ""
                self.age = String(data["age"] as? Int ?? 0)
                self.introduction = data["introduction"] as? String ?? ""
            }
            self.isLoading = false
        }
    }

    private func updateProfile() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()

        let updatedData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "age": Int(age) ?? 0,
            "introduction": introduction
        ]

        db.collection("users").document(user.uid).updateData(updatedData) { error in
            if let error = error {
                print("Error updating profile: \(error.localizedDescription)")
            } else {
                print("Profile updated successfully!")
            }
        }
    }
}
