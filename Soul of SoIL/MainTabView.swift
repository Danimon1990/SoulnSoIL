//
//  MainTabView.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 10/15/24.
//
import SwiftUI

struct MainTabView: View {
    @Binding var isAuthenticated: Bool // Binding to control login status

    var body: some View {
        TabView {
            // Home Tab
            HomeView(isAuthenticated: $isAuthenticated)
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            // Network Tab
            NetworkView()
                .tabItem {
                    Label("Network", systemImage: "person.3")
                }

            // Offerings Tab
            OfferingsView()
                .tabItem {
                    Label("Offerings", systemImage: "hand.raised")
                }
        }
        .toolbar {
            // Log-out button in the top-right corner
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isAuthenticated = false // Log the user out
                }) {
                    Image(systemName: "rectangle.portrait.and.arrow.right") // Log-out icon
                        .foregroundColor(.red)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
        .navigationBarBackButtonHidden(true) // Hide the back button
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(isAuthenticated: .constant(true))
    }
}
