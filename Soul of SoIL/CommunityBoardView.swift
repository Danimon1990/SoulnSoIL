import SwiftUI

struct CommunityBoardView: View {
    @StateObject private var viewModel = CommunityBoardViewModel()
    @State private var isPresentingNewPostView = false
    @State private var searchText = ""
    @State private var selectedPost: Post? // To track the selected post
    @State private var isPresentingCommentView = false // Show CommentView
    @Binding var username: String // Use Binding<String> here

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Search posts...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if filteredPosts.isEmpty {
                    Text("No posts found.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    // List of Posts
                    List(filteredPosts) { post in
                        NavigationLink(destination: PostView(post: post, viewModel: viewModel, username: $username)) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(post.title)
                                    .font(.headline)
                                Text(post.content)
                                    .lineLimit(2)
                                    .font(.body)
                                Text("By \(post.author) • \(formattedDate(post.timestamp))")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Community Board")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isPresentingNewPostView = true
                    }) {
                        Image(systemName: "square.and.pencil")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $isPresentingNewPostView) {
                NewPostView(viewModel: viewModel, username: $username)
            }
        }
    }

    var filteredPosts: [Post] {
        if searchText.isEmpty {
            return viewModel.posts
        } else {
            return viewModel.posts.filter { post in
                post.title.localizedCaseInsensitiveContains(searchText) ||
                post.content.localizedCaseInsensitiveContains(searchText) ||
                post.author.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
