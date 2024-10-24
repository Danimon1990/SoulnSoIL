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
            Spacer()
        }
        .padding()
        .navigationTitle(member.name)
    }
}

struct MemberDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MemberDetailView(member: CommunityMember(id: "1", name: "Alice", category: "Health Practices", description: "Yoga Instructor", offers: ["Yoga Classes"], tags: ["yoga", "wellness"], availability: "Weekdays"))
    }
}
