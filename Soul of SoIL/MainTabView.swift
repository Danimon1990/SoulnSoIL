//
//  MainTabView.swift
//  Soul of SoIL
//
//  Created by Daniel Moreno on 10/15/24.
//
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // Home Tab
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            // People Directory Tab
            PeopleDirectoryView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("People")
                }

            // Projects Directory Tab
            ProjectsDirectoryView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Projects")
                }
        }
    }
}




struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
