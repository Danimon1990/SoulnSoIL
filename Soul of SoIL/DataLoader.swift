//
//  DataLoader.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 10/17/24.
//

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
//Struct for events
struct CommunityEvent: Identifiable, Codable {
    let id: String
    let title: String
    let date: Date
    let description: String
}
// DataLoader class to load and decode JSON data
class DataLoader {
    
    // Load People JSON Data
    func loadPeopleData() -> [CommunityMember] {
        guard let url = Bundle.main.url(forResource: "people", withExtension: "json") else {
            fatalError("Failed to locate people.json in bundle.")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let people = try decoder.decode([CommunityMember].self, from: data)
            return people
        } catch {
            fatalError("Failed to decode people.json: \(error)")
        }
    }
    
    // Load Projects JSON Data
    func loadProjectsData() -> [CommunityProject] {
        guard let url = Bundle.main.url(forResource: "projects", withExtension: "json") else {
            fatalError("Failed to locate projects.json in bundle.")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let projects = try decoder.decode([CommunityProject].self, from: data)
            return projects
        } catch {
            fatalError("Failed to decode projects.json: \(error)")
        }
    }
    func loadEventsData(completion: @escaping ([CommunityEvent]?) -> Void) {
        // Use the raw URL of your GitHub JSON file
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
            decoder.dateDecodingStrategy = .iso8601 // Ensure dates are decoded correctly
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
