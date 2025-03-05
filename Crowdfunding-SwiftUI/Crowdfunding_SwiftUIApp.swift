import SwiftUI

@main
struct Crowdfunding_SwiftUIApp: App {
    // Use existing view models if they're already defined
    @StateObject private var campaignsViewModel = CampaignsViewModel()
    @StateObject private var createCampaignViewModel = CreateCampaignViewModel()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                // If HomeView is not defined, replace with a placeholder
                Text("Home")
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                // Campaigns view with view model
                CampaignsView(viewModel: campaignsViewModel)
                    .tabItem {
                        Label("Campaigns", systemImage: "chart.bar")
                    }
                
                // Create Campaign view with view model
                CreateCampaignsView(viewModel: createCampaignViewModel)
                    .tabItem {
                        Label("Create Campaign", systemImage: "plus.circle")
                    }
            }
        }
    }
}
