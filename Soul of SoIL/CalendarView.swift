import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct CalendarView: View {
    @State private var events: [Event] = []
    @State private var selectedDate = Date()
    @State private var showError = false
    @State private var errorMessage = ""

    private var eventDates: Set<Date> {
        Set(events.compactMap { $0.date?.onlyDate })
    }

    var body: some View {
        NavigationView {
            VStack {
                // Calendar Display
                CalendarSection(events: $events, selectedDate: $selectedDate, highlightedDates: eventDates)

                // Upcoming Events List
                List {
                    ForEach(events.filter { event in
                        guard let eventDate = event.date else { return false }
                        return eventDate.onlyDate == Date().onlyDate
                    }) { event in
                        NavigationLink(destination: EventView(event: event)) {
                            VStack(alignment: .leading) {
                                Text(event.title)
                                    .font(.headline)
                                Text(event.date?.formatted(date: .abbreviated, time: .shortened) ?? "Unknown Date")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Community Calendar")
            .onAppear {
                checkAuthAndFetchEvents()
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }

    private func checkAuthAndFetchEvents() {
        print("🔐 Checking authentication status...")
        if let currentUser = Auth.auth().currentUser {
            print("✅ User is authenticated:")
            print("   - UID: \(currentUser.uid)")
            print("   - Email: \(currentUser.email ?? "No email")")
            print("   - Anonymous: \(currentUser.isAnonymous)")
            fetchEvents()
        } else {
            print("⚠️ No authenticated user, attempting anonymous sign in...")
            Auth.auth().signInAnonymously { authResult, error in
                if let error = error {
                    print("❌ Anonymous auth failed: \(error.localizedDescription)")
                    self.errorMessage = "Authentication error: \(error.localizedDescription)"
                    self.showError = true
                    return
                }
                
                if let user = authResult?.user {
                    print("✅ Anonymous auth successful:")
                    print("   - UID: \(user.uid)")
                    print("   - Anonymous: \(user.isAnonymous)")
                    fetchEvents()
                }
            }
        }
    }
    
    private func fetchEvents() {
        let db = Firestore.firestore()
        print("🔍 Fetching events...")
        
        // Get the current user's authentication status
        if let user = Auth.auth().currentUser {
            print("📱 Fetching with user: \(user.uid)")
        }
        
        db.collection("events")
            .order(by: "date", descending: false)  // Add ordering
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("❌ Error fetching events: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("❌ No documents found")
                    return
                }

                print("📅 Found \(documents.count) events")

                self.events = documents.compactMap { document in
                    let data = document.data()
                    print("📄 Processing document: \(document.documentID)")

                    let id = document.documentID
                    let title = data["title"] as? String ?? "Untitled Event"
                    let location = data["location"] as? String ?? "Unknown Location"
                    let description = data["description"] as? String ?? "No description provided"
                    let createdBy = data["createdBy"] as? String ?? "Unknown Creator"
                    let town = data["town"] as? String ?? "Unknown Town"

                    if let timestamp = data["date"] as? Timestamp {
                        let date = timestamp.dateValue()
                        let event = Event(id: id, 
                                        title: title, 
                                        location: location, 
                                        town: town, 
                                        description: description, 
                                        date: date, 
                                        createdBy: createdBy)
                        print("✅ Created event: \(title) for date: \(date)")
                        return event
                    } else {
                        print("❌ No timestamp found for event: \(title)")
                        return nil
                    }
                }
                
                print("🏁 Final events count: \(self.events.count)")
                self.events.forEach { event in
                    if let date = event.date {
                        print("📅 Event: \(event.title) - Date: \(date)")
                    }
                }
            }
    }
}
