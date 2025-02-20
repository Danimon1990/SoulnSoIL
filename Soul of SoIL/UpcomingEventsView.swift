import SwiftUI

struct UpcomingEventsView: View {
    @State private var events: [Event] = []
    
    var body: some View {
        VStack {
            Text("Upcoming Events")
                .font(.largeTitle)
                .padding()
            
            List(events) { event in
                VStack(alignment: .leading) {
                    Text(event.title)
                        .font(.headline)
                    
                    // Unwrapping the optional date safely
                    if let eventDate = event.date {
                        Text("\(eventDate.formatted(date: .long, time: .shortened))")
                            .font(.subheadline)
                    } else {
                        Text("Date unavailable")
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }
                    
                    Text(event.location)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding()
            }
        }
        .onAppear {
            DataLoader().loadEventsData { loadedEvents in
                if let loadedEvents = loadedEvents {
                    // Safely unwrap and sort events by date
                    self.events = loadedEvents
                        .filter { $0.date != nil } // ✅ Remove unnecessary variable
                        .sorted(by: { $0.date ?? Date() < $1.date ?? Date() })
                }
            }
        }
    }
}
