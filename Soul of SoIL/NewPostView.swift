//
//  NewPostView.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 11/26/24.
//
import SwiftUI
struct NewPostView: View {
    @ObservedObject var viewModel: CommunityBoardViewModel
    @Binding var username: String // Accept username as a binding
    @State private var postTitle = ""
    @State private var postContent = ""

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
                    viewModel.addPost(title: postTitle, content: postContent, author: username)
                    postTitle = ""
                    postContent = ""
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
        }
    }
}
