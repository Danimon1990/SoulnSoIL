//
//  EditEventView.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 2/20/25.
//

import SwiftUI
import FirebaseFirestore

struct EditEventView: View {
    @State var event: Event
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Title", text: $event.title)
                    TextField("Location", text: $event.location)
                    TextField("Description", text: $event.description)
                    DatePicker("Date", selection: Binding(
                        get: { event.date ?? Date() },
                        set: { event.date = $0 }
                    ), displayedComponents: [.date, .hourAndMinute])
                }

                Button(action: updateEvent) {
                    Text("Save Changes")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Edit Event")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    // **🚀 Function to Update Event in Firestore**
    private func updateEvent() {
        let db = Firestore.firestore()
        guard let eventId = event.id else { return }

        let eventData: [String: Any] = [
            "title": event.title,
            "location": event.location,
            "description": event.description,
            "date": event.date ?? Date()
        ]

        db.collection("events").document(eventId).updateData(eventData) { error in
            if let error = error {
                print("Error updating event: \(error.localizedDescription)")
            } else {
                print("Event updated successfully!")
                DispatchQueue.main.async {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}
