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
            // Project Name
            Text(project.name)
                .font(.largeTitle)
                .padding(.top)
            
            // Location
            Text("Location: \(project.location)")
                .font(.title2)
            
            // Category
            Text("Category: \(project.category)")
                .font(.headline)
            
            // Description
            Text("Description: \(project.description)")
                .font(.body)
                .padding(.top)
            
            // Offers
            if let offers = project.offers, !offers.isEmpty {
                Text("Offers:")
                    .font(.headline)
                    .padding(.top)
                
                ForEach(offers, id: \.id) { offer in
                    VStack(alignment: .leading, spacing: 5) {
                        Text("• \(offer.title)")
                            .font(.body)
                            .bold()
                        Text(offer.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            } else {
                Text("No offers available.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            // Contact
            Text("Contact: \(project.contact)")
                .font(.footnote)
                .foregroundColor(.blue)
                .padding(.top)
            
            Spacer()
        }
        .padding()
        .navigationTitle(project.name)
    }
}

struct ProjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetailView(
            project: CommunityProject(
                id: "1",
                name: "Green Acres Farm",
                location: "123 Green Road",
                category: "Farm",
                description: "Organic produce and community-supported agriculture.",
                offers: [
                    Offer(id: "1", title: "Fresh Vegetables", type: "Product", description: "Organically grown vegetables available every week."),
                    Offer(id: "2", title: "Farm Tours", type: "Service", description: "Experience our farm and learn about sustainable agriculture.")
                ],
                contact: "info@greenacres.com",
                tags: ["organic", "farm"],
                picture: "green_acres_farm.jpg"
            )
        )
    }
}
