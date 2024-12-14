//
//  Untitled.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 10/17/24.
//


import SwiftUI

struct ProjectDetailView: View {
    var project: CommunityProject

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(project.name)
                .font(.largeTitle)
                .padding(.top)
            Text("Location: \(project.location)")
                .font(.title2)
            Text("Category: \(project.category)")
                .font(.headline)
            Text("Description: \(project.description)")
                .font(.body)
                .padding(.top)
            Spacer()
        }
        .padding()
        .navigationTitle(project.name)
    }
}
