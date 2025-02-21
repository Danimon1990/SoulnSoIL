//
//  NewPostView.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 11/26/24.
//
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct NewPostView: View {
    @ObservedObject var viewModel: CommunityBoardViewModel
    @Binding var username: String // Accept username as a binding
    @Environment(\.presentationMode) var presentationMode
    @State private var postTitle = ""
    @State private var postContent = ""
    @State private var fullName: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Post Title", text: $postTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextEditor(text: $postContent)
                    .border(Color.gray, width: 1)
                    .padding()
                
                Button(action: {
                    guard !postTitle.isEmpty && !postContent.isEmpty else { return }
                    guard let user = Auth.auth().currentUser else { return }
                    
                    let newPost = Post(
                        id: UUID().uuidString,
                        title: postTitle,
                        content: postContent,
                        timestamp: Date(),
                        authorID: user.uid,
                        authorName: fullName,
                        categories: [],
                        status: "published"
                    )
                    
                    viewModel.addPost(newPost) // ✅ Pass a Post object
                    postTitle = ""
                    postContent = ""
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Submit")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(postTitle.isEmpty || postContent.isEmpty)
                
                Spacer()
            }
            .padding()
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                fetchUserFullName()
            }
        }
    }
    func fetchUserFullName() {
        guard let user = Auth.auth().currentUser else { return }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)
        
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                let firstName = document.data()?["firstName"] as? String ?? ""
                let lastName = document.data()?["lastName"] as? String ?? ""
                
                self.fullName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
                
                print("🆔 Full Name Retrieved: \(self.fullName)")
            } else {
                print("❌ Error fetching user name: \(error?.localizedDescription ?? "Unknown error")")
                self.fullName = "Anonymous"
            }
        }
    }
}
