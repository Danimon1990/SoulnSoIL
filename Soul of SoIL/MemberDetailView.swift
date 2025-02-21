//
//  MemberDetailView.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 10/17/24.
//
import SwiftUI

struct MemberDetailView: View {
    var member: User

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Member's Name
                Text("\(member.firstName) \(member.lastName)")
                    .font(.largeTitle)
                    .padding(.top)

                // Category
                if let category = member.category, !category.isEmpty {
                    Text("Category: \(category)")
                        .font(.title2)
                        .padding(.top, 2)
                }

                // Location
                if let location = member.location, !location.isEmpty {
                    Text("Location: \(location)")
                        .font(.title3)
                        .foregroundColor(.gray)
                }

                // Bio
                Text("Bio:")
                    .font(.headline)
                    .padding(.top)
                Text(member.bio ?? "No bio available")
                    .font(.body)
                    .foregroundColor(.primary)

                // Offers
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
                        .padding(.vertical, 2)
                    }
                } else {
                    Text("No offers available.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                // Contact Information
                if let phoneNumber = member.phoneNumber, !phoneNumber.isEmpty {
                    Text("Phone: \(phoneNumber)")
                        .font(.body)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            }
                        }
                }

                Text("Email: \(member.email)")
                    .font(.body)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        if let emailURL = URL(string: "mailto:\(member.email)"), UIApplication.shared.canOpenURL(emailURL) {
                            UIApplication.shared.open(emailURL)
                        }
                    }

                Spacer()
            }
            .padding()
            .navigationTitle("\(member.firstName) \(member.lastName)")
        }
    }
}
