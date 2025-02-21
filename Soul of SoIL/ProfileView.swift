//
//  ProfileView.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 2/20/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

let db = Firestore.firestore()

struct ProfileView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var bio: String = ""
    @State private var isInDirectory: Bool = false
    @State private var phoneNumber: String = ""
    @State private var website: String = ""
    @State private var avatarURL: String = ""
    @State private var location: String = ""
    @State private var category: String = "" // Category can be free text or dropdown
    @State private var offerings: [Offer] = []
    
    @State private var isEditing = false
    @State private var isLoading: Bool = true
    
    // Predefined categories (Optional)
    let categoryOptions = ["Health Practices", "Farming", "Art", "Healing", "ecology", "Social work", "Sustainable Business", "other"]

    var body: some View {
        NavigationView {
            Form {
                // Personal Info
                Section(header: Text("Personal Info")) {
                    if isEditing {
                        TextField("First Name", text: $firstName)
                        TextField("Last Name", text: $lastName)
                    } else {
                        Text("\(firstName) \(lastName)").font(.headline)
                    }
                }
                
                // Profile Picture
                Section(header: Text("Profile Picture")) {
                    if isEditing {
                        TextField("Avatar URL", text: $avatarURL)
                    } else if !avatarURL.isEmpty {
                        AsyncImage(url: URL(string: avatarURL)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    }
                }
                
                // Contact Information
                Section(header: Text("Contact Information")) {
                    if isEditing {
                        TextField("Phone Number", text: $phoneNumber)
                            .keyboardType(.phonePad)
                        TextField("Website", text: $website)
                            .keyboardType(.URL)
                    } else {
                        if !phoneNumber.isEmpty {
                            Text("📞 \(phoneNumber)")
                        }
                        if !website.isEmpty {
                            Link("🌍 \(website)", destination: URL(string: website)!)
                        }
                    }
                }
                
                // Location
                Section(header: Text("Location")) {
                    if isEditing {
                        TextField("City, State", text: $location)
                    } else if !location.isEmpty {
                        Text(location)
                    }
                }
                
                // Category (Dropdown or Free Text)
                Section(header: Text("Category")) {
                    if isEditing {
                        Picker("Category", selection: $category) {
                            ForEach(categoryOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    } else {
                        Text(category.isEmpty ? "No category selected" : category)
                    }
                }
                
                // Introduction/Bio
                Section(header: Text("Introduction")) {
                    if isEditing {
                        TextEditor(text: $bio)
                            .frame(height: 80)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
                    } else if !bio.isEmpty {
                        Text(bio)
                    }
                }
                
                // Show in Directory
                Section {
                    Toggle("Show in Directory", isOn: $isInDirectory)
                }
                
                // Offerings (Only if they want to be in the directory)
                if isInDirectory {
                    Section(header: Text("Your Offerings")) {
                        ForEach(offerings.indices, id: \.self) { index in
                            VStack(alignment: .leading) {
                                if isEditing {
                                    TextField("Title", text: $offerings[index].title)
                                    TextField("Type (Service/Product)", text: $offerings[index].type)
                                    TextField("Description", text: $offerings[index].description)
                                    TextField("Contact Info", text: Binding(
                                        get: { offerings[index].contact ?? "" },
                                        set: { offerings[index].contact = $0 }
                                    ))
                                } else {
                                    Text("📌 \(offerings[index].title) - \(offerings[index].type)")
                                        .font(.headline)
                                    Text(offerings[index].description)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    if let contact = offerings[index].contact {
                                        Text("📞 Contact: \(contact)")
                                    }
                                }
                            }
                        }
                        
                        if isEditing {
                            Button(action: addOffer) {
                                Label("Add New Offer", systemImage: "plus")
                            }
                        }
                    }
                }
                
                // Save Changes Button
                if isEditing {
                    Section {
                        Button(action: saveChanges) {
                            Text("Save Changes")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                // Edit Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Save" : "Edit") {
                        if isEditing {
                            saveChanges()
                        }
                        isEditing.toggle()
                    }
                }
                
                // Logout Button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Logout") {
                        try? Auth.auth().signOut()
                    }
                }
            }
            .onAppear(perform: fetchUserProfile)
        }
    }
    
    // MARK: - Firebase Functions
    
    private func fetchUserProfile() {
        guard let user = Auth.auth().currentUser else { return }
        
        db.collection("users").document(user.uid).getDocument { snapshot, error in
            if let data = snapshot?.data() {
                self.firstName = data["firstName"] as? String ?? ""
                self.lastName = data["lastName"] as? String ?? ""
                self.email = data["email"] as? String ?? ""
                self.bio = data["bio"] as? String ?? ""
                self.phoneNumber = data["phoneNumber"] as? String ?? ""
                self.website = data["website"] as? String ?? ""
                self.avatarURL = data["avatar"] as? String ?? ""
                self.location = data["location"] as? String ?? ""
                self.category = data["category"] as? String ?? ""
                self.isInDirectory = data["isInDirectory"] as? Bool ?? false
                if let offersData = data["offerings"] as? [[String: Any]] {
                    self.offerings = offersData.compactMap { dict in
                        return Offer(
                            id: dict["id"] as? String ?? UUID().uuidString,
                            title: dict["title"] as? String ?? "New Offer",
                            type: dict["type"] as? String ?? "Service",
                            description: dict["description"] as? String ?? "",
                            contact: dict["contact"] as? String ?? ""
                        )
                    }
                }
            }
        }
    }
    
    private func saveChanges() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let updatedData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "bio": bio,
            "phoneNumber": phoneNumber,
            "website": website,
            "avatar": avatarURL,
            "location": location,
            "category": category,
            "isInDirectory": isInDirectory,
            "offerings": offerings.map { [
                "id": $0.id,
                "title": $0.title,
                "type": $0.type,
                "description": $0.description,
                "contact": $0.contact
            ]}
        ]
        
        db.collection("users").document(uid).updateData(updatedData) { error in
            if let error = error {
                print("Error updating profile: \(error.localizedDescription)")
            } else {
                print("Profile updated successfully!")
                isEditing = false
            }
        }
    }
    
    private func addOffer() {
        let newOffer = Offer(id: UUID().uuidString, title: "New Offer", type: "Service", description: "", contact: phoneNumber)
        offerings.append(newOffer)
    }
}
