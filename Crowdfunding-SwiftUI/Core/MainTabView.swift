// Main Tab View
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            CampaignsView()
                .tabItem {
                    Label("Campaigns", systemImage: "house.fill")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}
