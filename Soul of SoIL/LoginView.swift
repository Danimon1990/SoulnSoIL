import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @Binding var isAuthenticated: Bool
    @Binding var username: String
    @State private var password: String = ""
    @State private var isLoginFailed: Bool = false
    @State private var errorMessage: String = ""
    @State private var signUpSuccessMessage: String = "" // New state for the success message
    @State private var showSignUpView: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            if !signUpSuccessMessage.isEmpty {
                Text(signUpSuccessMessage)
                    .font(.headline)
                    .foregroundColor(.green)
                    .multilineTextAlignment(.center)
                    .padding()
            }

            // **Logo at the top**
            Image("Icon-App-76x76")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding(.top, 20)

            // **Title**
            Text("Soul n' SoIL")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.green)

            // **Introduction text**
            Text("Welcome to Soul of SoIL, the perfect platform to connect with your local community and find a wide variety of offerings, events, and relevant info.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

            // **Login Fields**
            TextField("Email", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.horizontal)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            // **Login Button**
            Button(action: login) {
                Text("Log In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 150, height: 45)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            

            // **Sign-Up Button**
            Button(action: {
                showSignUpView = true
            }) {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 150, height: 45)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showSignUpView) {
                SignUpView(signUpSuccessMessage: $signUpSuccessMessage) // Pass success message
            }

            // **Login Failed Alert**
            .alert(isPresented: $isLoginFailed) {
                Alert(
                    title: Text("Login Failed"),
                    message: Text(errorMessage.isEmpty
                                  ? "Invalid username or password. Please try again."
                                  : errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .padding()
    }

    private func login() {
        Auth.auth().signIn(withEmail: username, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
                isLoginFailed = true
            } else {
                isAuthenticated = true
            }
        }
    }
}
