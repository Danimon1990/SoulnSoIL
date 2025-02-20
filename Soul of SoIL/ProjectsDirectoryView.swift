import SwiftUI

struct ProjectsDirectoryView: View {
    @State private var projects: [CommunityProject] = []
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List(filteredProjects) { project in
                NavigationLink(destination: ProjectDetailView(project: project)) {
                    VStack(alignment: .leading) {
                        Text(project.name)
                            .font(.headline)
                        Text(project.location)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Projects Directory")
            .onAppear {
                loadProjects()
            }
            .searchable(text: $searchText, prompt: "Search Projects")
        }
    }
    
    private var filteredProjects: [CommunityProject] {
        if searchText.isEmpty {
            return projects
        } else {
            return projects.filter { $0.name.contains(searchText) || $0.category.contains(searchText) }
        }
    }
    
    private func loadProjects() {
        let dataLoader = DataLoader()
        dataLoader.loadProjectsData { loadedProjects in
            if let loadedProjects = loadedProjects {
                self.projects = loadedProjects
            }
        }
    }
}
