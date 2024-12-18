//
//  PostView.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 12/12/24.
//
import SwiftUI
struct PostView: View {
    let post: Post
    @ObservedObject var viewModel: CommunityBoardViewModel
    @State private var commentContent = ""
    @Binding var username: String // Binding<String> for username

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Main Post Details
            Text(post.title)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(post.content)
                .font(.body)

            Text("By \(post.author) • \(formattedDate(post.timestamp))")
                .font(.footnote)
                .foregroundColor(.gray)

            Divider()

            // Comments Section
            Text("Replies")
                .font(.headline)
                .padding(.top)

            ForEach(post.comments) { comment in
                VStack(alignment: .leading) {
                    Text("\(comment.author):")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Text(comment.content)
                }
                .padding(.vertical, 5)
            }

            // Add Reply Section
            HStack {
                TextField("Write a reply...", text: $commentContent)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    guard !commentContent.isEmpty else { return }
                    viewModel.addComment(toPostId: post.id, author: username, content: commentContent)
                    commentContent = ""
                }) {
                    Text("Reply")
                        .padding(8)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle(post.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
