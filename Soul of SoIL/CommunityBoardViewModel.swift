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
        loadPosts()
    }

    func loadPosts() {
        // Example for testing: Load from UserDefaults (or replace with backend integration)
        if let data = UserDefaults.standard.data(forKey: "CommunityPosts") {
            let decoder = JSONDecoder()
            if let savedPosts = try? decoder.decode([Post].self, from: data) {
                posts = savedPosts
            }
        }
    }

    func savePosts() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(posts) {
            UserDefaults.standard.set(encoded, forKey: "CommunityPosts")
        }
    }

    func addPost(title: String, content: String, author: String) {
        let newPost = Post(id: UUID(), title: title, content: content, author: author, timestamp: Date())
        posts.insert(newPost, at: 0) // Add to the top of the list
        savePosts()
    }
}
