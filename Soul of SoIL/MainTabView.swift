//
//  MainTabView.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 10/15/24.
//
import SwiftUI

struct MainTabView: View {
    @Binding var isAuthenticated: Bool // Binding to control login status
    @State var username: String

    var body: some View {
        TabView {
            // Home Tab
            HomeView(isAuthenticated: $isAuthenticated, username: $username)
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
        .navigationBarBackButtonHidden(true) // Hide the back button
    }
    
}
