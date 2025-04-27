import Foundation
import FirebaseFirestore
import Firebase

// Struct for Community Members (People)
/*struct CommunityMember: Identifiable, Codable {
    let id: String
    let name: String
    let category: String
    let description: String
    let offers: [Offer]
    let tags: [String]
    let availability: String
    let contact: String
    let picture: String
}*/

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
    var bio: String?
    var avatar: String?
    var location: String?

    // Offerings: array of Offer objects
    var offers: [Offer]

    // Timestamps & more
    var createdDate: Date?
}


// Struct for Community Projects
struct CommunityProject: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var email: String?
    var description: String
    var phoneNumber: String?
    var website: String?
    var avatarURL: String?
    var location: String?
    var category: String?
    var offers: [Offer]
    var peopleRelated: [String] // List of user IDs linked to this project
    var createdBy: String  // Admin who created the project
}

// Struct for Offers
struct Offer: Identifiable, Codable {
    let id: String
    var title: String
    var type: String  // e.g., "Service" or "Product"
    var description: String
    var contact: String?  // Email, Phone, or Website
}
extension User {
    var contact: String {
        if let phone = phoneNumber, !phone.isEmpty {
            return phone
        } else if let web = website, !web.isEmpty {
            return web
        } else {
            return email  // Default to email if nothing else is available
        }
    }
}

// Struct for Posts
struct Post: Identifiable, Codable {
    @DocumentID var id: String? // Firestore document ID (Optional)
    var title: String
    var content: String
    var timestamp: Date // Firestore stores as Timestamp, must convert
    var authorID: String
    var authorName: String
    var categories: [String]? // Optional
    var status: String? // Optional: "published" or "draft"

    // 🔹 Manual CodingKeys for Firebase Firestore compatibility
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case timestamp
        case authorID = "authorID"
        case authorName = "authorName"
        case categories
        case status
    }

    // 🔹 Custom Encoder for Firestore Timestamp Conversion
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(content, forKey: .content)
        try container.encode(authorID, forKey: .authorID)
        try container.encode(authorName, forKey: .authorName)
        try container.encodeIfPresent(categories, forKey: .categories)
        try container.encodeIfPresent(status, forKey: .status)

        // Convert Date to Firestore Timestamp
        let timestamp = Timestamp(date: timestamp)
        try container.encode(timestamp, forKey: .timestamp)
    }
}

struct Comment: Identifiable, Codable {
    @DocumentID var id: String?
    var postID: String // The ID of the post this comment belongs to
    var content: String
    var timestamp: Date
    var authorID: String // The user ID of the commenter
    var authorName: String
}

class DataLoader {
    private let db = Firestore.firestore()
    
    // Load Events Data
    func loadEventsData(completion: @escaping ([Event]?) -> Void) {
        db.collection("events").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("❌ Error fetching events: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("⚠️ No events found")
                completion(nil)
                return
            }
            
            let events = documents.compactMap { document in
                return Event(document: document)
            }
            
            print("✅ Loaded \(events.count) events from Firestore")
            completion(events)
        }
    }
    
    // Load People JSON Data
    func loadPeopleData(completion: @escaping ([User]?) -> Void) {
        db.collection("users")
          .whereField("isInDirectory", isEqualTo: true)
          .getDocuments { (querySnapshot, error) in
            if let error = error {
                print("❌ Error fetching people: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("⚠️ No people data found!")
                completion(nil)
                return
            }

            var people: [User] = []

            for document in documents {
                let data = document.data()
                
                let id = document.documentID
                let firstName = data["firstName"] as? String ?? "Unknown"
                let lastName = data["lastName"] as? String ?? "Unknown"
                let email = data["email"] as? String ?? "No Email"
                let isInDirectory = data["isInDirectory"] as? Bool ?? false
                let role = data["role"] as? String ?? "user"
                let category = data["category"] as? String
                let phoneNumber = data["phoneNumber"] as? String
                let website = data["website"] as? String
                let bio = data["bio"] as? String
                let avatar = data["avatar"] as? String
                let location = data["location"] as? String
                
                // ✅ Extract the offerings array
                let offeringsData = data["offerings"] as? [[String: Any]] ?? []
                let offerings = offeringsData.compactMap { dict in
                    return Offer(
                        id: dict["id"] as? String ?? UUID().uuidString,
                        title: dict["title"] as? String ?? "Unnamed Offer",
                        type: dict["type"] as? String ?? "Service",
                        description: dict["description"] as? String ?? "",
                        contact: dict["contact"] as? String ?? ""
                    )
                }

                let user = User(
                    id: id,
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    isInDirectory: isInDirectory,
                    role: role,
                    category: category,
                    phoneNumber: phoneNumber,
                    website: website,
                    bio: bio,
                    avatar: avatar,
                    location: location,
                    offers: offerings,
                    createdDate: nil
                )

                people.append(user)
            }

            print("✅ Loaded \(people.count) people from Firestore")
            completion(people)
        }
    }
    
    // Load Projects JSON Data
    func loadProjectsData(completion: @escaping ([CommunityProject]?) -> Void) {
        db.collection("projects").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching projects: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No projects found.")
                completion(nil)
                return
            }

            var projects: [CommunityProject] = []

            for document in documents {
                let data = document.data()
                
                let id = document.documentID
                let name = data["name"] as? String ?? "Unnamed Project"
                let email = data["email"] as? String ?? "No Email"
                let description = data["description"] as? String ?? "No description available"
                let phoneNumber = data["phoneNumber"] as? String
                let website = data["website"] as? String
                let avatarURL = data["avatarURL"] as? String
                let location = data["location"] as? String
                let category = data["category"] as? String
                let createdBy = data["createdBy"] as? String ?? "Unknown"
                
                let peopleRelated = data["peopleRelated"] as? [String] ?? []
                
                let offeringsData = data["offerings"] as? [[String: Any]] ?? []
                let offerings = offeringsData.compactMap { dict in
                    Offer(
                        id: dict["id"] as? String ?? UUID().uuidString,
                        title: dict["title"] as? String ?? "Unnamed Offer",
                        type: dict["type"] as? String ?? "Service",
                        description: dict["description"] as? String ?? "",
                        contact: dict["contact"] as? String ?? ""
                    )
                }

                let project = CommunityProject(
                    id: id,
                    name: name,
                    email: email,
                    description: description,
                    phoneNumber: phoneNumber,
                    website: website,
                    avatarURL: avatarURL,
                    location: location,
                    category: category,
                    offers: offerings,  // ✅ Now projects include offers!
                    peopleRelated: peopleRelated,
                    createdBy: createdBy
                )

                projects.append(project)
            }

            completion(projects)
        }
    }
    
    // Load Offerings from People and Projects
    func loadOfferings(
        people: [User],
        projects: [CommunityProject],
        completion: @escaping ([Offer]) -> Void
    ) {
        var offerings: [Offer] = []

        // ✅ Extract Offers from Community Members
        for person in people {
            for offer in person.offers {
                offerings.append(
                    Offer(
                        id: offer.id, // Keep original ID
                        title: offer.title,
                        type: offer.type,
                        description: offer.description,
                        contact: person.contact // ✅ Use person's contact info
                    )
                )
            }
        }

        // ✅ Extract Offers from Community Projects
        for project in projects {
            for offer in project.offers {
                offerings.append(
                    Offer(
                        id: offer.id, // Keep original ID
                        title: offer.title,
                        type: offer.type,
                        description: offer.description,
                        contact: project.phoneNumber ?? project.website ?? "No contact info" // ✅ Use project contact info
                    )
                )
            }
        }

        // ✅ Call the completion handler with the offers
        completion(offerings)
    }
}
