import SwiftUI

struct HomeView: View {
    @State private var events: [CommunityEvent] = []
    @State private var isLoading = true
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // Intro Text
                Text("""
                    A growing conscious community in Southern Illinois where we live in solidarity with people, in peace with nature, and in truth within ourselves.
                    """)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // List of Upcoming Events
                List(events) { event in
                    NavigationLink(destination: EventDetailView(event: event)) {
                        VStack(alignment: .leading) {
                            Text(event.title)
                                .font(.headline)
                            Text(event.date, style: .date)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .navigationTitle("Community Events")
                .onAppear {
                    loadEvents()
                }
            }
            .padding()
        }
    }
    
    // Load Events from DataLoader
    private func loadEvents() {
        let dataLoader = DataLoader()
        dataLoader.loadEventsData { loadedEvents in
            if let loadedEvents = loadedEvents {
                self.events = loadedEvents
            }
            self.isLoading = false
        }
    }
}

struct EventDetailView: View {
    var event: CommunityEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(event.title)
                .font(.largeTitle)
                .padding(.top)
            Text("Date: \(event.date, style: .date)")
                .font(.title2)
            Text(event.description)
                .font(.body)
                .padding(.top)
            Spacer()
        }
        .padding()
        .navigationTitle(event.title)
    }
}
