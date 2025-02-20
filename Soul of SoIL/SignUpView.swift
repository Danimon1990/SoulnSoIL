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
    @State private var age: String = ""
    @State private var introduction: String = ""
    @State private var isSigningUp: Bool = false
    @State private var errorMessage: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Info")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                }

                Section(header: Text("Account Info")) {
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    SecureField("Password", text: $password)
                }

                Section(header: Text("Introduction")) {
                    TextEditor(text: $introduction)
                        .frame(height: 80)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
                }

                Section {
                    Button(action: signUp) {
                        HStack {
                            if isSigningUp {
                                ProgressView()
                            }
                            Text("Sign Up")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty)
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
            .alert(isPresented: .constant(!errorMessage.isEmpty)) {
                Alert(title: Text("Sign Up Failed"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    // **🔥 Sign Up Function**
    private func signUp() {
        isSigningUp = true
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.isSigningUp = false
                return
            }

            guard let user = result?.user else { return }

            // **🚀 Save User Profile to Firestore**
            let db = Firestore.firestore()
            let userData: [String: Any] = [
                "firstName": firstName,
                "lastName": lastName,
                "email": email,
                "age": Int(age) ?? 0,
                "introduction": introduction
            ]

            db.collection("users").document(user.uid).setData(userData) { error in
                self.isSigningUp = false
                if let error = error {
                    self.errorMessage = "Error saving user data: \(error.localizedDescription)"
                } else {
                    signUpSuccessMessage = "Welcome to Soul of SoIL, you just signed up. You are ready to log in."
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}
