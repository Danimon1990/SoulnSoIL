import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct PeopleDirectoryView: View {
    @State private var people: [User] = []
    @State private var searchText = ""
    @State private var isAdmin: Bool = false  // Check if current user is admin

    private var filteredPeople: [User] {
        if searchText.isEmpty {
            return people
        } else {
            return people.filter {
                ($0.firstName + " " + $0.lastName).localizedCaseInsensitiveContains(searchText) ||
                ($0.category ?? "").localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                if isAdmin {
                    Button(action: {
                        // Navigate to AddPersonView (to be implemented)
                    }) {
                        Text("Add New Person")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                }
                
                List(filteredPeople, id: \.id) { person in
                    NavigationLink(destination: MemberDetailView(member: person)) {
                        VStack(alignment: .leading) {
                            Text("\(person.firstName) \(person.lastName)")
                                .font(.headline)
                            
                            if let category = person.category {
                                Text(category)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }

                            // ✅ Display Offers (New)
                            if !person.offers.isEmpty {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Offers:")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)

                                    ForEach(person.offers) { offer in
                                        VStack(alignment: .leading) {
                                            Text("• \(offer.title) (\(offer.type))")
                                                .font(.footnote)
                                                .foregroundColor(.primary)
                                            Text(offer.description)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                .padding(.top, 5)
                            } else {
                                Text("No offers available")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                .navigationTitle("People Directory")
                .onAppear {
                    checkAdminStatus()
                    loadPeople()
                }
                .searchable(text: $searchText, prompt: "Search People")
            }
        }
    }
    
    // 🚀 Fetch users from Firestore who are in the directory
    private func loadPeople() {
        let db = Firestore.firestore()
        db.collection("users").whereField("isInDirectory", isEqualTo: true).getDocuments { snapshot, error in
            if let error = error {
                print("Error loading people: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No users found in directory.")
                return
            }
            
            self.people = documents.compactMap { document in
                let data = document.data()
                let id = document.documentID
                let firstName = data["firstName"] as? String ?? "Unknown"
                let lastName = data["lastName"] as? String ?? ""
                let email = data["email"] as? String ?? "No Email"
                let category = data["category"] as? String
                let phoneNumber = data["phoneNumber"] as? String
                let website = data["website"] as? String
                let bio = data["bio"] as? String
                let avatar = data["avatar"] as? String
                let location = data["location"] as? String
                let role = data["role"] as? String ?? "user"
                
                // ✅ Extract offers correctly
                let offers = (data["offerings"] as? [[String: Any]])?.compactMap { offerData -> Offer? in
                    guard let offerID = offerData["id"] as? String,
                          let title = offerData["title"] as? String,
                          let type = offerData["type"] as? String,
                          let description = offerData["description"] as? String else { return nil }
                    let contact = offerData["contact"] as? String
                    return Offer(id: offerID, title: title, type: type, description: description, contact: contact)
                } ?? []

                return User(
                    id: id,
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    isInDirectory: true,
                    role: role,
                    category: category,
                    phoneNumber: phoneNumber,
                    website: website,
                    bio: bio,
                    avatar: avatar,
                    location: location,
                    offers: offers,
                    createdDate: nil
                )
            }
        }
    }

    // 🔍 Check if the logged-in user is an admin
    private func checkAdminStatus() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { document, error in
            if let error = error {
                print("Error fetching user role: \(error.localizedDescription)")
                return
            }
            
            if let data = document?.data(), let role = data["role"] as? String {
                DispatchQueue.main.async {
                    self.isAdmin = (role == "admin")
                }
            }
        }
    }
}
