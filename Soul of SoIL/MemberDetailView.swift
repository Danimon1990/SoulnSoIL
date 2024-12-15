//
//  MemberDetailView.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 10/17/24.
//
import SwiftUI

struct MemberDetailView: View {
    var member: CommunityMember

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(member.name)
                .font(.largeTitle)
                .padding(.top)

            Text("Category: \(member.category)")
                .font(.title2)

            Text("Description: \(member.description)")
                .font(.body)
                .padding(.top)

            if !member.offers.isEmpty {
                Text("Offers:")
                    .font(.headline)
                    .padding(.top)

                ForEach(member.offers, id: \.id) { offer in
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

            Spacer()
        }
        .padding()
        .navigationTitle(member.name)
    }
}

struct MemberDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MemberDetailView(
            member: CommunityMember(
                id: "1",
                name: "Alice",
                category: "Health Practices",
                description: "Yoga Instructor specializing in mindfulness.",
                offers: [
                    Offer(id: "1", title: "Yoga Classes", type: "Service", description: "Personalized yoga sessions for relaxation and strength."),
                    Offer(id: "2", title: "Meditation Coaching", type: "Service", description: "Guided meditation sessions for stress relief.")
                ],
                tags: ["yoga", "wellness"],
                availability: "Weekdays",
                contact: "alice@example.com",
                picture: "alice_profile"
            )
        )
    }
}
