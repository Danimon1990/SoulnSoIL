import SwiftUI

struct PostView: View {
    var post: Post
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = PostViewModel()
    @State private var newComment = ""
    @Binding var username: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(post.title)
                .font(.largeTitle)
                .bold()
            
            Text("By \(formattedAuthorName(post.authorName)) • \(formattedDate(post.timestamp))")
                .font(.footnote)
                .foregroundColor(.gray)
            
            Text(post.content)
                .font(.body)

            Divider()
            
            // Comment Section
            Text("Comments")
                .font(.headline)
            
            List(viewModel.comments) { comment in
                VStack(alignment: .leading) {
                    Text(comment.content)
                    Text("- \(comment.authorName)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            
            // Add New Comment
            HStack {
                TextField("Write a comment...", text: $newComment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    if !newComment.isEmpty {
                        let comment = Comment(
                            postID: post.id ?? "",
                            content: newComment,
                            timestamp: Date(),
                            authorID: "userID", // Get from Auth
                            authorName: username
                        )
                        viewModel.addComment(comment, to: post)
                        newComment = ""

                        // ✅ Dismiss the view after posting a comment
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                }
            }
            .padding()
        }
        .padding()
        .onAppear {
            viewModel.fetchComments(for: post.id ?? "")
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    private func formattedAuthorName(_ author: String) -> String {
        // If email is stored instead of a name, format it better
        if author.contains("@") {
            let namePart = author.components(separatedBy: "@").first ?? "Unknown"
            return namePart.capitalized // Display only the name part of the email
        }
        return author // Otherwise, display the name as is
    }
}
