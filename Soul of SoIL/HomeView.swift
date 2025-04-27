import SwiftUI
import FirebaseAuth

// Enum for Home Sections
enum HomeSection {
    case calendar
    case board
}

struct HomeView: View {
    @Binding var isAuthenticated: Bool
    @Binding var username: String
    @State private var selectedSection: HomeSection = .calendar
    @State private var events: [Event] = [] // Events data
    @State private var selectedDate: Date = Date()
    @State private var showMessage: Bool = false
    @State private var messageText: String = ""
    @State private var isVerified: Bool = true // Default to true, will check onAppear

    private var eventDates: Set<Date> {
        Set(events.compactMap { $0.date?.onlyDate })
    }

    var body: some View {
        NavigationView {
            VStack {
                SectionSelector(
                    selectedSection: $selectedSection
                )

                if selectedSection == .calendar {
                    CalendarSection(
                        events: $events,
                        selectedDate: $selectedDate,
                        highlightedDates: eventDates
                    )
                } else if selectedSection == .board {
                    CommunityBoardView(username: $username)
                }

                Spacer()
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ProfileView(isAuthenticated: $isAuthenticated)) {
                        Image(systemName: "person.circle") // Profile icon
                            .font(.title)
                    }
                }

                // ✅ Show "Resend Verification Email" button ONLY if the user is NOT verified
                if !isVerified {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: resendVerificationEmail) {
                            Text("Verify Email")
                                .font(.system(size: 14))
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .onAppear {
                checkVerificationStatus()
                loadEvents()
            }
            .alert(isPresented: $showMessage) {
                Alert(title: Text("Email Verification"), message: Text(messageText), dismissButton: .default(Text("OK")))
            }
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

    private func loadEvents() {
        let dataLoader = DataLoader()
        dataLoader.loadEventsData { loadedEvents in
            if let loadedEvents = loadedEvents {
                self.events = loadedEvents
            }
        }
    }
}
