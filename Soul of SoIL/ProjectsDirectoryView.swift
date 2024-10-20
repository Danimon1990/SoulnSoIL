import SwiftUI

struct ProjectsDirectoryView: View {
    // Load projects data using DataLoader
    let projects = DataLoader().loadProjectsData()

    var body: some View {
        NavigationView {
            List(projects) { project in
                NavigationLink(destination: ProjectDetailView(project: project)) {
                    VStack(alignment: .leading) {
                        Text(project.name)
                            .font(.headline)
                        Text(project.location)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(project.category)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Projects Directory")
        }
    }
}
