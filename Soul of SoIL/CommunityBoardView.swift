import SwiftUI

struct CommunityBoardView: View {
    @StateObject private var viewModel = CommunityBoardViewModel()
    @State private var isPresentingNewPostView = false
    @State private var searchText = ""
    @State private var selectedPost: Post? // To track which post is being commented on
    @State private var isPresentingCommentView = false // Show CommentView

    var body: some View {
        NavigationView {
            VStack {
                // Search Field
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
                        VStack(alignment: .leading, spacing: 8) {
                            // Post Content
                            Text(post.title)
                                .font(.headline)
                            Text(post.content)
                                .lineLimit(2)
                                .font(.body)
                            Text("By \(post.author) • \(formattedDate(post.timestamp))")
                                .font(.footnote)
                                .foregroundColor(.gray)

                            // Comments Section
                            ForEach(post.comments) { comment in
                                HStack(alignment: .top) {
                                    Text("\(comment.author):")
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                                    Text(comment.content)
                                }
                                .font(.caption)
                                .foregroundColor(.secondary)
                            }

                            // Reply Button
                            Button("Reply") {
                                selectedPost = post
                                isPresentingCommentView = true
                            }
                            .font(.caption)
                            .foregroundColor(.green)
                        }
                        .padding(.vertical, 8)
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
                NewPostView(viewModel: viewModel)
            }
            .sheet(isPresented: $isPresentingCommentView) {
                if let post = selectedPost {
                    CommentView(post: post, viewModel: viewModel)
                }
            }
        }
    }

    var filteredPosts: [Post] {
        if searchText.isEmpty {
            return viewModel.posts
        } else {
            return viewModel.posts.filter { post in
                post.title.contains(searchText) || post.content.contains(searchText) || post.author.contains(searchText)
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
