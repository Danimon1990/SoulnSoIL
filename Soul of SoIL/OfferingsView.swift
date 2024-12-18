import SwiftUI

struct OfferingsView: View {
    @State private var offerings: [Offering] = []
    @State private var filteredOfferings: [Offering] = []
    @State private var searchText: String = ""
    private let dataLoader = DataLoader()

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Search offerings...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: searchText) {
                        filterOfferings()
                    }
                // Offerings List
                List(filteredOfferings) { offering in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(offering.title)
                            .font(.headline)

                        Text("Source: \(offering.sourceName) (\(offering.sourceType))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text(offering.sourceDescription)
                            .font(.body)

                        if let contact = offering.contact {
                            Text("Contact: \(contact)")
                                .font(.footnote)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 5)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Offerings")
        }
        .onAppear {
            loadOfferings()
        }
    }

    private func loadOfferings() {
        dataLoader.loadPeopleData { people in
            guard let people = people else { return }
            self.dataLoader.loadProjectsData { projects in
                guard let projects = projects else { return }
                self.dataLoader.loadOfferings(people: people, projects: projects) { loadedOfferings in
                    self.offerings = loadedOfferings
                    self.filteredOfferings = loadedOfferings // Initialize filtered list
                }
            }
        }
    }

    private func filterOfferings() {
        if searchText.isEmpty {
            filteredOfferings = offerings
        } else {
            filteredOfferings = offerings.filter { offering in
                offering.title.localizedCaseInsensitiveContains(searchText) ||
                offering.sourceName.localizedCaseInsensitiveContains(searchText) ||
                offering.sourceType.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}
