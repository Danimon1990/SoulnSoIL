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
            Text("Offers: \(member.offers.map(\.title).joined(separator: ", "))")
            Spacer()
        }
        .padding()
        .navigationTitle(member.name)
    }
}
