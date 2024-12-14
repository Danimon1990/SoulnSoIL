//
//  PostView.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 12/12/24.
//

import SwiftUI

struct PostView: View {
    let post: Post // A single post passed from the CommunityBoardView

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(post.title)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("By \(post.author)")
                .font(.subheadline)
                .foregroundColor(.gray)

            Text(post.content)
                .font(.body)
                .padding(.top)

            Spacer()
        }
        .padding()
        .navigationTitle("Post Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
