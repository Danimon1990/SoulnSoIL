import SwiftUI

struct CommunityBoardView: View {
    @StateObject private var viewModel = CommunityBoardViewModel()
    @State private var isPresentingNewPostView = false
    @State private var searchText = ""
    @Binding var username: String // Use Binding<String> for user name

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
                        NavigationLink(destination: PostView(post: post, username: $username)) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(post.title)
                                    .font(.headline)
                                Text(post.content)
                                    .lineLimit(2)
                                    .font(.body)
                                Text("By \(post.authorName) • \(formattedDate(post.timestamp))")
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
            .onAppear {
                print("📡 Fetching posts on CommunityBoardView load...") // Debugging log
                viewModel.fetchPosts() // ✅ Fetch posts when the view appears
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
                post.authorName.localizedCaseInsensitiveContains(searchText)
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
