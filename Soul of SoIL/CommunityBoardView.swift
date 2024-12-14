
import SwiftUI

struct CommunityBoardView: View {
    @StateObject private var viewModel = CommunityBoardViewModel()
    @State private var isPresentingNewPostView = false
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search posts...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if filteredPosts.isEmpty {
                    Text("No posts found.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(filteredPosts) { post in
                        NavigationLink(destination: PostView(post: post)) {
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
                NewPostView(viewModel: viewModel)
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
