
import SwiftUI

struct HomeView: View {
    // Sample event data
    @State private var events = [
        CommunityEvent(title: "Permaculture Workshop", date: Date(), description: "Join us for a hands-on permaculture workshop on Saturday."),
        CommunityEvent(title: "Community Potluck", date: Date().addingTimeInterval(86400 * 2), description: "Potluck dinner on Sunday evening."),
        CommunityEvent(title: "Yoga Class", date: Date().addingTimeInterval(86400 * 5), description: "Outdoor yoga class in the garden.")
    ]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // Full intro text
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
            }
            .padding()
        }
    }
}

struct CommunityEvent: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let description: String
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
            Text("Description: \(event.description)")
                .font(.body)
                .padding(.top)
            Spacer()
        }
        .padding()
        .navigationTitle(event.title)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

