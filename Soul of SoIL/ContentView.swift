//
//  ContentView.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 10/15/24.
//
import SwiftUI

struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isAuthenticated = false
    @State private var isLoginFailed = false
    @State private var keyboardOffset: CGFloat = 0

    var body: some View {
        NavigationStack {
                    if isAuthenticated {
                        MainTabView(isAuthenticated: $isAuthenticated)
                    } else {
                        LoginView(isAuthenticated: $isAuthenticated)
                    }
                }
            }
        
    }
    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
