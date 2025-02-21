//
//  CommunityBoardViewModel.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 11/26/24.
//

import Foundation
import FirebaseFirestore

class CommunityBoardViewModel: ObservableObject {
    @Published var posts: [Post] = []
    private var db = Firestore.firestore()

    // ✅ Add or update a post manually
    func addPost(_ post: Post) {
        let docRef = db.collection("posts").document() // Let Firestore generate ID automatically

        let postData: [String: Any] = [
            "title": post.title.isEmpty ? "Untitled Post" : post.title,
            "content": post.content.isEmpty ? "No content available" : post.content,
            "timestamp": FieldValue.serverTimestamp(), // 🔹 Ensure timestamp is added
            "authorID": post.authorID.isEmpty ? "Unknown Author" : post.authorID,
            "authorName": post.authorName.isEmpty ? "Anonymous" : post.authorName,
            "categories": post.categories ?? [],
            "status": post.status ?? "draft"
        ]

        docRef.setData(postData) { error in
            if let error = error {
                print("❌ Error adding post: \(error.localizedDescription)")
            } else {
                print("✅ Post successfully added with ID: \(docRef.documentID)")
            }
        }
    }

    // ✅ Fetch posts manually
    func fetchPosts() {
        print("📡 Fetching posts from Firestore...")

        db.collection("posts")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("❌ Error fetching posts: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("❌ No documents found in Firestore.")
                    return
                }

                print("📥 Retrieved \(documents.count) posts from Firestore")

                self.posts = documents.compactMap { document in
                    let data = document.data()
                    print("📌 Post Loaded: \(data)")

                    return Post(
                        id: document.documentID,
                        title: data["title"] as? String ?? "Untitled",
                        content: data["content"] as? String ?? "",
                        timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date(),
                        authorID: data["authorID"] as? String ?? "Unknown",
                        authorName: data["authorName"] as? String ?? "Anonymous",
                        categories: data["categories"] as? [String] ?? [],
                        status: data["status"] as? String ?? "published"
                    )
                }

                print("✅ Posts successfully loaded into ViewModel: \(self.posts.count)")
            }
    }
}

// ✅ Separate ViewModel for Comments
class PostViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    private var db = Firestore.firestore()

    // ✅ Fetch comments manually
    func fetchComments(for postID: String) {
        let db = Firestore.firestore()
        
        print("📡 Fetching comments for post ID: \(postID)")

        db.collection("posts").document(postID).collection("comments")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("❌ Error fetching comments: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("❌ No comments found.")
                    return
                }

                print("📥 Retrieved \(documents.count) comments.")

                self.comments = documents.compactMap { document in
                    let data = document.data()

                    return Comment(
                        postID: postID,
                        content: data["content"] as? String ?? "",
                        timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date(),
                        authorID: data["authorID"] as? String ?? "",
                        authorName: data["authorName"] as? String ?? "Anonymous"
                    )
                }

                print("✅ Comments successfully loaded.")
            }
    }

    // ✅ Add a comment manually
    func addComment(_ comment: Comment, to post: Post) {
        let db = Firestore.firestore()
        let commentRef = db.collection("posts").document(post.id ?? "").collection("comments").document()

        let commentData: [String: Any] = [
            "content": comment.content,
            "timestamp": FieldValue.serverTimestamp(), // Ensure timestamp is correctly stored
            "authorID": comment.authorID,
            "authorName": comment.authorName
        ]

        print("📝 Attempting to save comment: \(commentData)")

        commentRef.setData(commentData) { error in
            if let error = error {
                print("❌ Error adding comment: \(error.localizedDescription)")
            } else {
                print("✅ Comment successfully added!")
                self.fetchComments(for: post.id ?? "") // Refresh comments immediately
            }
        }
    }
}
