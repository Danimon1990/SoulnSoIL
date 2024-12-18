import SwiftUI

// Enum for Home Sections
enum HomeSection {
    case calendar
    case board
}

struct HomeView: View {
    @Binding var isAuthenticated: Bool
    @State private var selectedSection: HomeSection = .calendar
    @State private var events: [Event] = [] // Events data
    @State private var selectedDate: Date = Date()

    var body: some View {
        NavigationView {
            VStack {
                // Section Selector Buttons
                HStack {
                    Button(action: {
                        selectedSection = .calendar
                    }) {
                        Text("Calendar")
                            .font(.headline)
                            .foregroundColor(selectedSection == .calendar ? .white : .green)
                            .padding()
                            .background(selectedSection == .calendar ? Color.green : Color.clear)
                            .cornerRadius(8)
                    }

                    Button(action: {
                        selectedSection = .board
                    }) {
                        Text("Board")
                            .font(.headline)
                            .foregroundColor(selectedSection == .board ? .white : .green)
                            .padding()
                            .background(selectedSection == .board ? Color.green : Color.clear)
                            .cornerRadius(8)
                    }
                }
                .padding()

                if selectedSection == .calendar {
                    ScrollView { // Add ScrollView here to allow scrolling
                        VStack {
                            // Calendar UI
                            Text("Community Calendar")
                                .font(.largeTitle)
                                .padding(.bottom)

                            DatePicker(
                                "Select a Date",
                                selection: $selectedDate,
                                displayedComponents: [.date]
                            )
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding()

                            // Event List
                            Text("Upcoming Events")
                                .font(.title2)
                                .padding(.vertical)

                            ForEach(events) { event in
                                NavigationLink(destination: EventView(event: event)) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(event.title)
                                            .font(.headline)
                                        Text("\(event.date) at \(event.time)")
                                            .font(.subheadline)
                                        Text(event.location)
                                            .font(.body)
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .shadow(radius: 1)
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding()
                    }
                } else if selectedSection == .board {
                    CommunityBoardView() // Placeholder for Community Board
                }

                Spacer()
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(isAuthenticated: .constant(true))
    }
}
