//
//  NetworkView.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 11/18/24.
//
import SwiftUI

struct NetworkView: View {
    @State private var isShowingPeople = true // Toggle between People and Projects

    var body: some View {
        VStack {
            // Top Buttons for Switching Views
            HStack {
                Button(action: {
                    isShowingPeople = true
                }) {
                    Text("People")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isShowingPeople ? Color.green : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button(action: {
                    isShowingPeople = false
                }) {
                    Text("Projects")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(!isShowingPeople ? Color.blue : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()

            // Display Content Based on Selected View
            if isShowingPeople {
                PeopleDirectoryView()
            } else {
                ProjectsDirectoryView()
            }
        }
    }
}
