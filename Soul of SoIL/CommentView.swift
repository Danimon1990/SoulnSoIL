import SwiftUI
import FirebaseFirestore
import FirebaseAuth
struct CommentView: View {
    @State private var newComment = ""
    let post: Post

    // ✅ Now referencing the correct PostViewModel
    @ObservedObject var viewModel: PostViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Reply to \(post.title)")
                .font(.title2)
                .fontWeight(.bold)

            TextField("Enter your comment...", text: $newComment)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                guard let user = Auth.auth().currentUser else { return }

                let comment = Comment(
                    id: UUID().uuidString,
                    postID: post.id ?? "",
                    content: newComment,
                    timestamp: Date(),
                    authorID: user.uid,
                    authorName: user.displayName ?? "Anonymous"
                )

                // ✅ This function is in PostViewModel, not CommunityBoardViewModel
                viewModel.addComment(comment, to: post)
                newComment = ""
            }) {
                Text("Submit")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(8)
            }
            Spacer()
        }
        .padding()
    }
}
