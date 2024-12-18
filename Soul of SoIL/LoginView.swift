import SwiftUI
import Combine

struct LoginView: View {
    @Binding var isAuthenticated: Bool
    @Binding var username: String // Add username

    @State private var password: String = ""
    @State private var isLoginFailed: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()

                Text("Soul n' SoIL")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)

                TextField("Username", text: $username) // Bind username
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button(action: {
                    // Simulated login logic
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
            }
            .padding()
        }
    }
}
