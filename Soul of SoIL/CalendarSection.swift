//
//  CalendarSection.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 2/9/25.
//
import SwiftUI
import FirebaseFirestore

extension Date {
    var onlyDate: Date {
        return Calendar.current.startOfDay(for: self)
    }
}

struct CalendarSection: View {
    @Binding var events: [Event]
    @Binding var selectedDate: Date
    var highlightedDates: Set<Date>
    @State private var showAddEventView = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Calendar Title
                Text("Community Calendar")
                    .font(.title)
                    .padding(.top)
                
                // Simple Date Picker
                DatePicker(
                    "Select a Date",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                
                // Events for Selected Date
                VStack(alignment: .leading, spacing: 10) {
                    Text("Events for \(selectedDate.formatted(date: .long, time: .omitted))")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    let eventsForSelectedDate = events.filter { event in
                        guard let eventDate = event.date else { return false }
                        return Calendar.current.isDate(eventDate, inSameDayAs: selectedDate)
                    }
                    
                    if eventsForSelectedDate.isEmpty {
                        Text("No events scheduled for this day")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(eventsForSelectedDate) { event in
                            NavigationLink(destination: EventView(event: event)) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(event.title)
                                        .font(.headline)
                                    if let date = event.date {
                                        Text(date.formatted(date: .omitted, time: .shortened))
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Text(event.location)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemBackground))
                                .cornerRadius(10)
                                .shadow(radius: 2)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                // Upcoming Events Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Upcoming Events")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    let upcomingEvents = events.filter { event in
                        guard let eventDate = event.date else { return false }
                        return eventDate > Date()
                    }.sorted { $0.date ?? Date() < $1.date ?? Date() }
                    
                    if upcomingEvents.isEmpty {
                        Text("No upcoming events")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(upcomingEvents.prefix(10)) { event in
                            NavigationLink(destination: EventView(event: event)) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(event.title)
                                        .font(.headline)
                                    if let date = event.date {
                                        Text(date.formatted(date: .abbreviated, time: .shortened))
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Text(event.location)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemBackground))
                                .cornerRadius(10)
                                .shadow(radius: 2)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                // Add Event Button
                Button(action: {
                    showAddEventView = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add New Event")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
            .padding(.bottom)
        }
        .sheet(isPresented: $showAddEventView) {
            AddEventView()
        }
    }
}

struct MiniDatePickerStyle: DatePickerStyle {
    var highlightedDates: Set<Date>
    
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            HStack {
                configuration.label
                Spacer()
                DatePicker("", selection: configuration.$selection, displayedComponents: [.date])
                    .labelsHidden()
            }
            
            MiniCalendarView(selection: configuration.$selection, highlightedDates: highlightedDates)
        }
    }
}

struct MiniCalendarView: View {
    @Binding var selection: Date
    var highlightedDates: Set<Date>
    
    var body: some View {
        VStack {
            let calendar = Calendar.current
            let month = calendar.component(.month, from: selection)
            let year = calendar.component(.year, from: selection)
            
            Text("\(calendar.monthSymbols[month - 1]) \(year)")
                .font(.headline)
                .padding(.bottom)
            
            let days = calendar.range(of: .day, in: .month, for: selection)!
            let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: selection))!
            let startingSpaces = calendar.component(.weekday, from: firstDay) - 1
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(0..<7) { index in
                    Text(calendar.veryShortWeekdaySymbols[index])
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                ForEach(0..<startingSpaces, id: \.self) { _ in
                    Color.clear
                }
                
                ForEach(days, id: \.self) { day in
                    let date = calendar.date(bySetting: .day, value: day, of: selection)!
                    let isHighlighted = highlightedDates.contains(calendar.startOfDay(for: date))
                    
                    Button(action: {
                        selection = date
                    }) {
                        VStack(spacing: 4) {
                            Text("\(day)")
                                .font(.system(size: 16))
                                .foregroundColor(calendar.isDate(date, inSameDayAs: selection) ? .white : .primary)
                            
                            if isHighlighted {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 6, height: 6)
                            }
                        }
                        .frame(width: 32, height: 32)
                        .background(
                            Group {
                                if calendar.isDate(date, inSameDayAs: selection) {
                                    Color.blue.cornerRadius(8)
                                } else {
                                    Color.clear.cornerRadius(8)
                                }
                            }
                        )
                    }
                }
            }
        }
        .padding()
    }
}
