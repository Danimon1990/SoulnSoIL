import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var isAuthenticated = false
    @State private var username: String = ""

    var body: some View {
        if isAuthenticated {
            MainTabView(isAuthenticated: $isAuthenticated, username: username)
        } else {
            LoginView(isAuthenticated: $isAuthenticated, username: $username)
        }
    }

    init() {
        checkUserStatus()
    }

    private func checkUserStatus() {
        if let user = Auth.auth().currentUser {
            isAuthenticated = true
            username = user.displayName ?? "User"
        }
    }
}
