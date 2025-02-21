import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct EventView: View {
    let event: Event
    @State private var isEditing = false
    @State private var showDeleteAlert = false
    @Environment(\.presentationMode) var presentationMode
    @State private var creatorFullName: String = "Loading..."

    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(event.title)
                .font(.largeTitle)
                .fontWeight(.bold)

            HStack {
                Image(systemName: "calendar")
                if let eventDate = event.date {
                    Text(formatDate(eventDate))
                } else {
                    Text("Date not available")
                        .foregroundColor(.red)
                }
            }
            .font(.headline)

            HStack {
                Image(systemName: "clock")
                if let eventDate = event.date {
                    Text(timeFormatter.string(from: eventDate)) // ✅ Extracts only time
                } else {
                    Text("Time not available")
                        .foregroundColor(.red)
                }
            }
            .font(.headline)

            HStack {
                Image(systemName: "map")
                Text(event.location)
            }
            .font(.headline)
            HStack { // ✅ Add town display
                Image(systemName: "building.2.crop.circle")
                Text(event.town)
            }
            .font(.headline)

            Text(event.description)
                .font(.body)
                .padding(.top, 10)

            Divider() // ✅ Add a line before the "Created by" section

            // ✅ Add the event creator at the bottom
            HStack {
                            Image(systemName: "person.crop.circle")
                            Text("Created by: \(creatorFullName)")
                                .font(.footnote)
                                .foregroundColor(.blue)
                        }
            .padding(.top, 5)

            Spacer()
        }
        .padding()
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            //  Show Edit Button ONLY if the logged-in user is the creator
            if Auth.auth().currentUser?.email == event.createdBy {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { isEditing.toggle() }) {
                            Label("Edit Event", systemImage: "pencil")
                        }
                        Button(role: .destructive, action: { showDeleteAlert.toggle() }) {
                            Label("Delete Event", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                    }
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            EditEventView(event: event) // ✅ Show Edit View
        }
        .alert("Delete Event", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteEvent()
            }
        } message: {
            Text("Are you sure you want to delete this event?")
        }
        .onAppear {
                    fetchCreatorName()
                }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    private func fetchCreatorName() {
            let db = Firestore.firestore()
            db.collection("users").whereField("email", isEqualTo: event.createdBy).getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching user data: \(error.localizedDescription)")
                    return
                }

                if let document = snapshot?.documents.first {
                    let firstName = document.data()["firstName"] as? String ?? ""
                    let lastName = document.data()["lastName"] as? String ?? ""
                    DispatchQueue.main.async {
                        self.creatorFullName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.creatorFullName = "Unknown User"
                    }
                }
            }
        }

    // **🚀 Function to Delete the Event**
    private func deleteEvent() {
        let db = Firestore.firestore()
        db.collection("events").document(event.id ?? "").delete { error in
            if let error = error {
                print("Error deleting event: \(error.localizedDescription)")
            } else {
                print("Event deleted successfully!")
                DispatchQueue.main.async {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}
