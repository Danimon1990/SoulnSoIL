//
//  CalendarSection.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 2/9/25.
//
import SwiftUI
import FirebaseFirestore

struct CalendarSection: View {
    @Binding var events: [Event]
    @Binding var selectedDate: Date
    @State private var showAddEventView = false

    var body: some View {
        ScrollView {
            VStack {
                Text("Community Calendar")
                    .font(.largeTitle)
                    .padding(.bottom)

                DatePicker(
                    "Select a Date",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .overlay(
                    GeometryReader { geometry in
                        ZStack {
                            ForEach(events, id: \.id) { event in
                                if let eventDate = event.date,
                                   Calendar.current.isDate(eventDate, inSameDayAs: selectedDate) {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 8, height: 8)
                                        .offset(x: geometry.size.width / 2 - 15, y: geometry.size.height / 2 - 15)
                                }
                            }
                        }
                    }
                )
                .padding()

                Text("Upcoming Events")
                    .font(.title2)
                    .padding(.vertical)

                // ✅ **Filter events to show future ones**
                let filteredEvents = events.filter { event in
                    guard let eventDate = event.date else { return false }
                    return eventDate >= Date() // Show only upcoming events
                }

                if filteredEvents.isEmpty {
                    Text("No upcoming events")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(filteredEvents) { event in
                        NavigationLink(destination: EventView(event: event)) {
                            VStack(alignment: .leading) {
                                Text(event.title)
                                    .font(.headline)
                                if let date = event.date {
                                    Text(date.formatted(date: .long, time: .shortened))
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
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

                Button(action: {
                    showAddEventView = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add New Event")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
            .padding()
        }
        .sheet(isPresented: $showAddEventView) {
            AddEventView()
        }
    }
}
