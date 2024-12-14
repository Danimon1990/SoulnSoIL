import SwiftUI
import Combine

struct LoginView: View {
    @State var username = ""
    @State var password = ""
    @Binding var isAuthenticated: Bool
    @State private var isLoginFailed = false
    
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
                
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: {
                    // Replace this with your actual login logic
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
                        .frame(width: 100, height: 45)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .alert(isPresented: $isLoginFailed) {
                    Alert(title: Text("Login Failed"), message: Text("Invalid username or password. Please try again."), dismissButton: .default(Text("OK")))
                }
                .navigationDestination(isPresented: $isAuthenticated) {
                    MainTabView(isAuthenticated: $isAuthenticated)
                }
            }
            .padding()
            
        }
    
    }
}
