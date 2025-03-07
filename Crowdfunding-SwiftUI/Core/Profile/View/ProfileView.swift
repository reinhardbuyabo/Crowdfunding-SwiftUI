// ProfileView.swift
import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                } else {
                    List(viewModel.userCampaigns) { campaign in
                        NavigationLink(destination: CampaignDetailView(campaign: campaign)) {
                            VStack(alignment: .leading) {
                                Text(campaign.title)
                                    .font(.headline)
                                Text(campaign.description)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("My Campaigns")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
