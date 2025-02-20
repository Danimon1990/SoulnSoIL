import SwiftUI

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

    var body: some View {
            NavigationView {
                VStack {
                    SectionSelector(
                        selectedSection: $selectedSection
                    )

                    if selectedSection == .calendar {
                        CalendarSection(
                            events: $events,
                            selectedDate: $selectedDate
                        )
                    } else if selectedSection == .board {
                        CommunityBoardView(username: $username)
                    }

                    Spacer()
                }
                .navigationTitle("Home")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: ProfileView()) {
                            Image(systemName: "person.circle") // Profile icon
                                .font(.title)
                        }
                    }
                }
                .onAppear {
                    loadEvents()
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

