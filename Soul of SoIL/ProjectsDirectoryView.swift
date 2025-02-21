import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProjectsDirectoryView: View {
    @State private var projects: [CommunityProject] = []
    @State private var searchText = ""
    @State private var isAdmin: Bool = false
    @State private var showAddProjectView = false

    var body: some View {
        NavigationView {
            VStack {
                // Show "Create New Project" button only for admins
                if isAdmin {
                    Button(action: {
                        showAddProjectView = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.white)
                            Text("Create New Project")
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    }
                    .sheet(isPresented: $showAddProjectView) {
                        NewProjectView()
                    }
                }

                // List of projects
                List(filteredProjects) { project in
                    NavigationLink(destination: ProjectDetailView(project: project)) {
                        VStack(alignment: .leading) {
                            Text(project.name)
                                .font(.headline)
                            Text(project.location ?? "Unknown Location")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .navigationTitle("Projects Directory")
                .onAppear {
                    checkAdminStatus()
                    loadProjects()
                }
                .searchable(text: $searchText, prompt: "Search Projects")
            }
        }
    }

    private var filteredProjects: [CommunityProject] {
        if searchText.isEmpty {
            return projects
        } else {
            return projects.filter {
                $0.name.contains(searchText) || ($0.category?.contains(searchText) ?? false)
            }
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

    private func checkAdminStatus() {
        guard let uid = Auth.auth().currentUser?.uid else {
            isAdmin = false
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)

        userRef.getDocument { document, error in
            if let document = document, document.exists {
                let userData = document.data()
                if let role = userData?["role"] as? String, role == "admin" {
                    isAdmin = true
                } else {
                    isAdmin = false
                }
            } else {
                isAdmin = false
            }
        }
    }
}
