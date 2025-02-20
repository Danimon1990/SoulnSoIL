//
//  SectionSelector.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 2/9/25.
//
import SwiftUI

struct SectionSelector: View {
    @Binding var selectedSection: HomeSection

    var body: some View {
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
    }
}
