//
//  CommunityBoardViewModel.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 11/26/24.
//
import Foundation

class CommunityBoardViewModel: ObservableObject {
    @Published var posts: [Post] = []

    init() {
        loadPosts() // Load posts when initializing the ViewModel
    }

    // MARK: - Load Posts
    func loadPosts() {
        // Load posts from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "CommunityPosts") {
            let decoder = JSONDecoder()
            if let savedPosts = try? decoder.decode([Post].self, from: data) {
                posts = savedPosts
            }
        }
    }

    // MARK: - Save Posts
    func savePosts() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(posts) {
            UserDefaults.standard.set(encoded, forKey: "CommunityPosts")
        }
    }

    // MARK: - Add a New Post
    func addPost(title: String, content: String, author: String) {
        let newPost = Post(
            id: UUID().uuidString,
            title: title,
            content: content,
            author: author,
            timestamp: Date(),
            comments: [] // Start with an empty comment list
        )
        posts.insert(newPost, at: 0) // Add the new post at the top
        savePosts()
    }

    // MARK: - Add Comment to Post
    func addComment(toPostId postId: String, author: String, content: String) {
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            let comment = Comment(
                id: UUID().uuidString, // Convert UUID to String
                author: author,
                content: content,
                timestamp: Date()
            )
            posts[index].comments.append(comment) // Directly append to the array
            savePosts()
        }
    }
}
