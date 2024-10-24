//
//  ContentView.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 10/15/24.
//
import SwiftUI

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isAuthenticated: Bool = false
    @State private var isLoginFailed: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Logo Image
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .padding()

                // Title
                Text("Soul n' SoIL")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)

                // Welcome Text
                Text("""
                    Welcome to the Soul n' SoIL app,
                    used to connect a growing conscious community in Southern Illinois where we decide to live in solidarity with people, in peace with nature, and in truth within ourselves.
                    Understanding that we are part of a bigger project that we co-create.
                    """)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // Username Field
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // Password Field
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // Login Button
                Button(action: {
                    // Simulate login logic (replace with actual logic)
                    if username == "user" && password == "password" {
                        isAuthenticated = true
                        isLoginFailed = false
                    } else {
                        isLoginFailed = true
                    }
                }) {
                    Text("Log In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .alert(isPresented: $isLoginFailed) {
                    Alert(title: Text("Login Failed"), message: Text("Invalid username or password. Please try again."), dismissButton: .default(Text("OK")))
                }

                // Navigate to MainTabView when authenticated
                .navigationDestination(isPresented: $isAuthenticated) {
                    MainTabView()
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
