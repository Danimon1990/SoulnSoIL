import Foundation
import FirebaseFirestore
import Firebase

// Struct for Community Members (People)
struct CommunityMember: Identifiable, Codable {
    let id: String
    let name: String
    let category: String
    let description: String
    let offers: [Offer]
    let tags: [String]
    let availability: String
    let contact: String
    let picture: String
}
/*
struct User: Identifiable, Codable {
    // The Firestore Document ID
    @DocumentID var id: String?
    // Basic user info
    var firstName: String
    var lastName: String
    var email: String

    // Directory & Role
    var isInDirectory: Bool
    var role: String  // "admin" or "user"

    // Additional profile fields
    var category: String?  // e.g. "Health Practices"
    var phoneNumber: String?
    var website: String?
    var description: String?
    var avatar: String?

    // Offerings: array of Offer objects
    var offerings: [Offer]

    // Timestamps & more
    var createdDate: Date?
}
*/

// Struct for Community Projects
struct CommunityProject: Identifiable, Codable {
    let id: String
    let name: String
    let location: String
    let category: String
    let description: String
    let offers: [Offer]?
    let contact: String
    let tags: [String]
    let picture: String
}

// Struct for Offers
struct Offer: Identifiable, Codable {
    let id: String
    let title: String
    let type: String
    let description: String
}

// Struct for Events
struct Event: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var location: String
    var town: String
    var description: String
    var date: Date?
    var createdBy: String
}

// Struct for Offerings
struct Offering: Identifiable {
    let id: String
    let title: String
    let sourceName: String
    let sourceType: String // "Person" or "Project"
    let sourceDescription: String
    let contact: String?
}

// Struct for Posts
struct Post: Identifiable, Codable {
    let id: String
    let title: String
    let content: String
    let author: String
    let timestamp: Date
    var comments: [Comment] // Array of comments
}

struct Comment: Identifiable, Codable {
    let id: String
    let author: String
    let content: String
    let timestamp: Date
}

class DataLoader {
    private let db = Firestore.firestore()
    
    // Load People JSON Data
    func loadPeopleData(completion: @escaping ([CommunityMember]?) -> Void) {
        guard let url = URL(string: "https://raw.githubusercontent.com/Danimon1990/SoulnSoIL/main/Soul%20of%20SoIL/people.json") else {
            fatalError("Invalid URL for people.json")
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Failed to fetch people.json: \(error)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data returned for people.json")
                completion(nil)
                return
            }

            let decoder = JSONDecoder()
            do {
                let people = try decoder.decode([CommunityMember].self, from: data)
                DispatchQueue.main.async {
                    completion(people)
                }
            } catch {
                print("Failed to decode people.json: \(error)")
                completion(nil)
            }
        }.resume()
    }

    // Load Projects JSON Data
    func loadProjectsData(completion: @escaping ([CommunityProject]?) -> Void) {
        guard let url = URL(string: "https://raw.githubusercontent.com/Danimon1990/SoulnSoIL/main/Soul%20of%20SoIL/projects.json") else {
            fatalError("Invalid URL for projects.json")
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Failed to fetch projects.json: \(error)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data returned for projects.json")
                completion(nil)
                return
            }

            let decoder = JSONDecoder()
            do {
                let projects = try decoder.decode([CommunityProject].self, from: data)
                DispatchQueue.main.async {
                    completion(projects)
                }
            } catch {
                print("Failed to decode projects.json: \(error)")
                completion(nil)
            }
        }.resume()
    }

    // Load Events JSON Data
    func loadEventsData(completion: @escaping ([Event]?) -> Void) {
        db.collection("events").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching events: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No events found.")
                completion(nil)
                return
            }

            var events: [Event] = []

            for document in documents {
                let data = document.data()

                let id = document.documentID
                let title = data["title"] as? String ?? "Untitled Event"
                let location = data["location"] as? String ?? "Unknown Location"
                let description = data["description"] as? String ?? "No description provided"
                let createdBy = data["createdBy"] as? String ?? "Unknown User"
                let town = data["town"] as? String ?? "Unknown Town"

                // ✅ Convert Firestore Timestamp to Date
                let timestamp = data["date"] as? Timestamp
                let date = timestamp?.dateValue()  // ✅ This converts FIRTimestamp to Date

                let event = Event(id: id, title: title, location: location, town: town, description: description, date: date, createdBy: createdBy)
                events.append(event)
            }

            completion(events)
        }
    }

    // Load Offerings from People and Projects
    func loadOfferings(
        people: [CommunityMember],
        projects: [CommunityProject],
        completion: @escaping ([Offering]) -> Void
    ) {
        var offerings: [Offering] = []

        // Extract Offers from Community Members
        for person in people {
            for offer in person.offers {
                offerings.append(
                    Offering(
                        id: UUID().uuidString,
                        title: offer.title,
                        sourceName: person.name,
                        sourceType: "Person",
                        sourceDescription: person.description,
                        contact: person.contact
                    )
                )
            }
        }

        // Extract Offers from Community Projects
        for project in projects {
            if let projectOffers = project.offers {
                for offer in projectOffers {
                    offerings.append(
                        Offering(
                            id: UUID().uuidString,
                            title: offer.title,
                            sourceName: project.name,
                            sourceType: "Project",
                            sourceDescription: project.description,
                            contact: project.contact
                        )
                    )
                }
            }
        }

        completion(offerings)
    }
}
