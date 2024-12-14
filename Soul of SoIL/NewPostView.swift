//
//  NewPostView.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 11/26/24.
//
import SwiftUI

struct NewPostView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: CommunityBoardViewModel

    @State private var title = ""
    @State private var content = ""
    @State private var author = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter the title", text: $title)
                }

                Section(header: Text("Content")) {
                    TextEditor(text: $content)
                        .frame(height: 150)
                }

                Section(header: Text("Author")) {
                    TextField("Your name", text: $author)
                }
            }
            .navigationTitle("New Post")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Post") {
                        if !title.isEmpty && !content.isEmpty && !author.isEmpty {
                            viewModel.addPost(title: title, content: content, author: author)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .disabled(title.isEmpty || content.isEmpty || author.isEmpty)
                }
            }
        }
    }
}
