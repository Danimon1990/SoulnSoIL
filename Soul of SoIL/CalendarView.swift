import SwiftUI
import FirebaseFirestore
struct CalendarView: View {
    @State private var events: [Event] = []
    @State private var selectedDate = Date()

    var body: some View {
        NavigationView {
            VStack {
                // Calendar Display
                CalendarSection(events: $events, selectedDate: $selectedDate)

                // Upcoming Events List
                List {
                    ForEach(events.filter { event in
                        guard let eventDate = event.date else { return false }
                        return eventDate >= Date() // Show only future events
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
                fetchEvents()
            }
        }
    }
    private func fetchEvents() {
        let db = Firestore.firestore()
        db.collection("events").order(by: "date").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching events: \(error.localizedDescription)")
                return
            }

            self.events = snapshot?.documents.compactMap { document in
                let data = document.data()
                let id = document.documentID
                let title = data["title"] as? String ?? "Untitled Event"
                let location = data["location"] as? String ?? "Unknown Location"
                let description = data["description"] as? String ?? "No description provided"
                let createdBy = data["createdBy"] as? String ?? "Unknown Creator"
                let town = data["town"] as? String ?? "Unknown Town"

                // ✅ FIX: Convert Timestamp to Date safely
                            let date: Date? = (data["date"] as? Timestamp)?.dateValue()

                            return Event(id: id, title: title, location: location, town: town, description: description, date: date, createdBy: createdBy)
                        } ?? []
        }
    }
}
