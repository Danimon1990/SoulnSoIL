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
            if let location = project.location, !location.isEmpty {
                Text("Location: \(location)")
                    .font(.title2)
            }
            
            // Category
            if let category = project.category, !category.isEmpty {
                Text("Category: \(category)")
                    .font(.headline)
            }
            
            // Description
            Text("Description:")
                .font(.headline)
                .padding(.top)
            Text(project.description)
                .font(.body)
            
            // Offers Section
            if !project.offers.isEmpty {
                Text("Offers:")
                    .font(.headline)
                    .padding(.top)
                
                ForEach(project.offers, id: \.id) { offer in
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
            
            // Contact Section
            VStack(alignment: .leading) {
                Text("Contact:")
                    .font(.headline)
                    .padding(.top, 5)
                
                if let phoneNumber = project.phoneNumber, !phoneNumber.isEmpty {
                    Text("Phone: \(phoneNumber)")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
                
                if let email = project.email, !email.isEmpty {
                    Text("Email: \(email)")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
                
                if let website = project.website, !website.isEmpty {
                    Text("Website: \(website)")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle(project.name)
    }
}
