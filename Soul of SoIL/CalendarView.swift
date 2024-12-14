import SwiftUI

struct CalendarView: View {
    let events: [Event] // Accept events as a parameter
    @State private var selectedDate: Date? = nil

    var body: some View {
        VStack {
            Text("Community Calendar")
                .font(.largeTitle)
                .padding()

            // Calendar UI
            DatePicker(
                "Select a Date",
                selection: Binding<Date>(
                    get: { selectedDate ?? Date() },
                    set: { selectedDate = $0 }
                ),
                displayedComponents: [.date]
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()
            .overlay(highlightedDaysOverlay(), alignment: .center) // Highlight days with events

            // Display the list of events
            Text("Upcoming Events")
                .font(.title2)
                .padding(.vertical)

            List(filteredEvents) { event in
                VStack(alignment: .leading) {
                    Text(event.title)
                        .font(.headline)
                    Text("\(event.time) at \(event.location)")
                        .font(.subheadline)
                    Text(event.description)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding()
            }
        }
    }

    // Filter events by the selected date, or show all if no date is selected
    private var filteredEvents: [Event] {
        if let selectedDate = selectedDate {
            let formattedSelectedDate = formattedDate(selectedDate)
            return events.filter { $0.date == formattedSelectedDate }
        }
        return events // Show all events if no date is selected
    }

    // Format the date to compare with event dates
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    // Overlay to highlight days with events
    private func highlightedDaysOverlay() -> some View {
        GeometryReader { geometry in
            let calendar = Calendar.current
            let daysWithEvents = events.map { event -> Date in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                return formatter.date(from: event.date) ?? Date()
            }

            return ForEach(daysWithEvents, id: \.self) { date in
                if let dayComponent = calendar.dateComponents([.day, .month, .year], from: date).day {
                    Text("\(dayComponent)")
                        .font(.caption)
                        .frame(width: 20, height: 20)
                        .background(Color.green.opacity(0.3))
                        .cornerRadius(10)
                }
            }
        }
    }
}
