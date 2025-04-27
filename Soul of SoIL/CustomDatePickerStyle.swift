import SwiftUI

struct CustomDatePickerStyle: DatePickerStyle {
    var highlightedDates: Set<Date>
    
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            HStack {
                configuration.label
                Spacer()
            }
            
            CustomCalendarView(selection: configuration.$selection, highlightedDates: highlightedDates)
        }
    }
}

struct CustomCalendarView: View {
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
