//
//  ContentView.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 10/15/24.
//
import SwiftUI

struct ContentView: View {
    @State private var isAuthenticated = false
    @State private var username: String = "" // Define username

    var body: some View {
        NavigationStack {
            if isAuthenticated {
                MainTabView(isAuthenticated: $isAuthenticated, username: username) // Pass username
            } else {
                LoginView(isAuthenticated: $isAuthenticated, username: $username) // Pass username
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
