import SwiftUI
import Foundation

struct OfferingsView: View {
    @State private var offers: [Offer] = []
    @State private var filteredOffers: [Offer] = []
    @State private var searchText: String = ""
    @State private var selectedSortOption: SortOption = .alphabetical
    @State private var providerInfo: [String: (name: String, contact: String?)] = [:]

    private let dataLoader = DataLoader()

    enum SortOption: String, CaseIterable {
        case alphabetical = "A-Z"
        case category = "Category"
        case location = "Location"
    }

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Search offers...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: searchText) {
                        filterOffers()
                    }
                    .onSubmit {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }

                // Sorting Picker
                Picker("Sort by", selection: $selectedSortOption) {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        Text(option.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .onChange(of: selectedSortOption) {
                    sortOffers()
                }

                // Offers List
                List(filteredOffers, id: \.id) { offer in
                    NavigationLink(destination: OfferView(
                        offer: offer,
                        providerName: providerInfo[offer.id]?.name ?? "Unknown Provider",
                        providerContact: providerInfo[offer.id]?.contact
                    )) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(offer.title)
                                .font(.headline)

                            if !offer.type.isEmpty {
                                Text("Category: \(offer.type)")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }

                            if let contact = offer.contact, !contact.isEmpty {
                                Text("Contact: \(contact)")
                                    .font(.footnote)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Offers")
        }
        .onAppear {
            loadOffers()
        }
    }

    // MARK: - Load Offers from Firebase
    private func loadOffers() {
        dataLoader.loadPeopleData { people in
            guard let people = people else {
                print("⚠️ No people data found!")
                return
            }
            self.dataLoader.loadProjectsData { projects in
                guard let projects = projects else {
                    print("⚠️ No projects data found!")
                    return
                }
                self.dataLoader.loadOfferings(people: people, projects: projects) { offers in
                    print("✅ Offers Loaded: \(offers.count)")
                    
                    // Store provider information
                    for person in people {
                        for offer in person.offers {
                            providerInfo[offer.id] = (name: "\(person.firstName) \(person.lastName)", contact: person.phoneNumber)
                        }
                    }
                    
                    for project in projects {
                        for offer in project.offers {
                            providerInfo[offer.id] = (name: project.name, contact: project.phoneNumber)
                        }
                    }
                    
                    self.offers = offers
                    self.filteredOffers = offers
                    sortOffers()
                }
            }
        }
    }

    // MARK: - Filter Offers by Search
    private func filterOffers() {
        if searchText.isEmpty {
            filteredOffers = offers
        } else {
            filteredOffers = offers.filter { offer in
                offer.title.localizedCaseInsensitiveContains(searchText) ||
                offer.type.localizedCaseInsensitiveContains(searchText) ||
                (offer.contact ?? "").localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    // MARK: - Sort Offers
    private func sortOffers() {
        switch selectedSortOption {
        case .alphabetical:
            filteredOffers.sort { $0.title < $1.title }
        case .category:
            filteredOffers.sort { $0.type < $1.type }
        case .location:
            filteredOffers.sort { ($0.contact ?? "") < ($1.contact ?? "") }
        }
    }
}
