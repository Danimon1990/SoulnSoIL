//
//  CommentView.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 12/17/24.
//
import SwiftUI

struct CommentView: View {
    @State private var newComment = ""
    let post: Post
    @ObservedObject var viewModel: CommunityBoardViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Reply to \(post.title)")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            TextField("Enter your comment...", text: $newComment)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Submit") {
                let comment = Comment(
                    id: UUID().uuidString,
                    author: "Current User", // Replace with real user data
                    content: newComment,
                    timestamp: Date()
                )
                viewModel.addComment(toPostId: post.id,
                                     author: comment.author,
                                     content: comment.content)
                newComment = ""
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .cornerRadius(8)

            Spacer()
        }
        .padding()
    }
}
