//
//  EventView.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 12/12/24.
//

import SwiftUI

struct EventView: View {
    let event: Event

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(event.title)
                .font(.largeTitle)
                .fontWeight(.bold)

            HStack {
                Image(systemName: "calendar")
                Text(event.date)
            }
            .font(.headline)

            HStack {
                Image(systemName: "clock")
                Text(event.time)
            }
            .font(.headline)

            HStack {
                Image(systemName: "map")
                Text(event.location)
            }
            .font(.headline)

            Text(event.description)
                .font(.body)
                .padding(.top, 10)

            Spacer()
        }
        .padding()
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(
                    item: "Check out this event: \(event.title) on \(event.date) at \(event.time). Location: \(event.location). Description: \(event.description)"
                        ) {
                    Image(systemName: "square.and.arrow.up")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
