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
                    Text("\(event.date) at \(event.time)")
                        .font(.subheadline)
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
                    // Safely unwrap the optional and sort the events
                    self.events = loadedEvents.sorted(by: { $0.date < $1.date })
                } else {
                    print("Failed to load events data")
                }
            }
        }
    }
}
