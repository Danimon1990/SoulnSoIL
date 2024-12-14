import SwiftUI

struct OfferingsView: View {
    @State private var offerings: [Offering] = []
    private let dataLoader = DataLoader()

    var body: some View {
        NavigationView {
            List(offerings) { offering in
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
                }
            }
        }
    }
}
