import SwiftUI
import FirebaseAuth

struct NetworkView: View {
    @State private var isShowingPeople = true // Toggle between People and Programs
    @State private var isVerified = true // Will check user's verification status
    @State private var showMessage = false
    @State private var messageText = ""

    var body: some View {
        VStack {
            // Top Buttons for Switching Views
            HStack {
                Button(action: {
                    isShowingPeople = true
                }) {
                    Text("People")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isShowingPeople ? Color.green : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button(action: {
                    isShowingPeople = false
                }) {
                    Text("Programs")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(!isShowingPeople ? Color.blue : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()

            // ✅ Check if user is verified before showing content
            if isVerified {
                if isShowingPeople {
                    PeopleDirectoryView()
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Programs Directory")
                            .font(.title)
                            .padding(.horizontal)
                        
                        // Categories
                        VStack(alignment: .leading, spacing: 5) {
                            Text("• Businesses")
                            Text("• Community Initiatives")
                            Text("• Creative Developments")
                        }
                        .padding(.horizontal)
                        .foregroundColor(.gray)
                        
                        ProjectsDirectoryView()
                    }
                }
            } else {
                // ❌ Show message if user is not verified
                VStack {
                    Text("You must verify your email to view the community board and network.")
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(.red)

                    Button(action: resendVerificationEmail) {
                        Text("Resend Verification Email")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .onAppear {
            checkVerificationStatus()
        }
        .alert(isPresented: $showMessage) {
            Alert(title: Text("Email Verification"), message: Text(messageText), dismissButton: .default(Text("OK")))
        }
    }

    // ✅ Function to check if user is verified
    private func checkVerificationStatus() {
        if let user = Auth.auth().currentUser {
            isVerified = user.isEmailVerified
        }
    }

    // ✅ Function to send verification email
    private func resendVerificationEmail() {
        if let user = Auth.auth().currentUser {
            user.sendEmailVerification { error in
                if let error = error {
                    messageText = "Error: \(error.localizedDescription)"
                } else {
                    messageText = "Verification email sent! Check your inbox."
                }
                showMessage = true
            }
        }
    }
}
