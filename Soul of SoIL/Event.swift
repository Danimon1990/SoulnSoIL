import Foundation
import FirebaseFirestore

struct Event: Identifiable, Codable {
    let id: String
    var title: String
    var location: String
    var town: String
    var description: String
    var date: Date?
    var createdBy: String
    
    init(id: String, title: String, location: String, town: String, description: String, date: Date?, createdBy: String) {
        self.id = id
        self.title = title
        self.location = location
        self.town = town
        self.description = description
        self.date = date
        self.createdBy = createdBy
    }
    
    // Add a convenience initializer for Firestore documents
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let title = data["title"] as? String,
              let location = data["location"] as? String,
              let town = data["town"] as? String,
              let description = data["description"] as? String,
              let createdBy = data["createdBy"] as? String else {
            return nil
        }
        
        self.id = document.documentID
        self.title = title
        self.location = location
        self.town = town
        self.description = description
        self.createdBy = createdBy
        
        if let timestamp = data["date"] as? Timestamp {
            self.date = timestamp.dateValue()
        } else {
            self.date = nil
        }
    }
    
    // Add Firestore data dictionary conversion
    var firestoreData: [String: Any] {
        var data: [String: Any] = [
            "title": title,
            "location": location,
            "town": town,
            "description": description,
            "createdBy": createdBy
        ]
        
        if let date = date {
            data["date"] = Timestamp(date: date)
        }
        
        return data
    }
} 