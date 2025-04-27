import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var signUpSuccessMessage: String
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var bio: String = ""
    @State private var isSigningUp: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Info")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                }

                Section(header: Text("Account Info")) {
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                    
                    SecureField("Password", text: $password)
                        .textContentType(.newPassword)
                }

                Section {
                    Button(action: signUp) {
                        HStack {
                            if isSigningUp {
                                ProgressView()
                                    .padding(.trailing, 5)
                            }
                            Text(isSigningUp ? "Creating Account..." : "Sign Up")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(isSigningUp || firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty)
                }
                
                if !errorMessage.isEmpty {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                }
            }
            .navigationTitle("Create Account")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .alert("Sign Up Failed", isPresented: $showError) {
                Button("OK", role: .cancel) {
                    errorMessage = ""
                }
            } message: {
                Text(errorMessage)
            }
            .disabled(isSigningUp)
        }
    }

    // **🔥 Sign Up Function**
    private func signUp() {
        isSigningUp = true
        errorMessage = ""
        
        // Basic validation
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters long"
            isSigningUp = false
            return
        }
        
        guard email.contains("@") else {
            errorMessage = "Please enter a valid email address"
            isSigningUp = false
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                    self.isSigningUp = false
                }
                return
            }

            guard let user = result?.user else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to create user"
                    self.showError = true
                    self.isSigningUp = false
                }
                return
            }
        
            // Send Email Verification
            user.sendEmailVerification { error in
                if let error = error {
                    print("Error sending verification email: \(error.localizedDescription)")
                }
            }
            
            // Save User Profile to Firestore
            let db = Firestore.firestore()
            let userData: [String: Any] = [
                "firstName": firstName,
                "lastName": lastName,
                "email": email,
                "role": "user",
                "isInDirectory": false,
                "offerings": [],
                "phoneNumber": "",
                "website": "",
                "description": "",
                "avatar": "",
                "location": "",
                "createdDate": FieldValue.serverTimestamp()
            ]

            db.collection("users").document(user.uid).setData(userData) { error in
                DispatchQueue.main.async {
                    self.isSigningUp = false
                    
                    if let error = error {
                        self.errorMessage = "Error saving user data: \(error.localizedDescription)"
                        self.showError = true
                    } else {
                        self.signUpSuccessMessage = "Account created successfully! Please check your email for verification."
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
