import Foundation

// Struct for Community Members (People)
struct CommunityMember: Identifiable, Codable {
    let id: String
    let name: String
    let category: String
    let description: String
    let offers: [String]
    let tags: [String]
    let availability: String
}

// Struct for Community Projects
struct CommunityProject: Identifiable, Codable {
    let id: String
    let name: String
    let location: String
    let category: String
    let description: String
    let tags: [String]
    let picture: String
}

// Struct for Community Events
struct CommunityEvent: Identifiable, Codable {
    let id: String
    let title: String
    let date: Date
    let description: String
}

class DataLoader {

    // Load People JSON Data from GitHub
    func loadPeopleData(completion: @escaping ([CommunityMember]?) -> Void) {
        guard let url = URL(string: "https://raw.githubusercontent.com/Danimon1990/SoulnSoIL/refs/heads/main/Soul%20of%20SoIL/people.json") else {
            fatalError("Invalid URL for people.json")
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
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

    // Load Projects JSON Data from GitHub
    func loadProjectsData(completion: @escaping ([CommunityProject]?) -> Void) {
        guard let url = URL(string: "https://raw.githubusercontent.com/Danimon1990/SoulnSoIL/refs/heads/main/Soul%20of%20SoIL/projects.json") else {
            fatalError("Invalid URL for projects.json")
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
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

    // Load Events JSON Data from GitHub
    func loadEventsData(completion: @escaping ([CommunityEvent]?) -> Void) {
        guard let url = URL(string: "https://raw.githubusercontent.com/Danimon1990/SoulnSoIL/refs/heads/main/Soul%20of%20SoIL/events.json") else {
            fatalError("Invalid URL for events.json")
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch events.json: \(error)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data returned for events.json")
                completion(nil)
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                let events = try decoder.decode([CommunityEvent].self, from: data)
                DispatchQueue.main.async {
                    completion(events)
                }
            } catch {
                print("Failed to decode events.json: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
