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

struct ProjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetailView(project: CommunityProject(id: "1", name: "Green Acres Farm", location: "123 Green Road", category: "Farm", description: "Organic produce and community-supported agriculture.", tags: ["organic", "farm"], picture: "green_acres_farm.jpg"))
    }
}
